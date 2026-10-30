import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// All MorphZing reminders are scheduled on the phone itself: free, private, offline.
/// Settings live in GetStorage ('reminderSettings'); nothing is sent to the server.
class Reminders {
  Reminders._();
  static final Reminders instance = Reminders._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  final GetStorage _box = GetStorage();
  bool _ready = false;

  static const String _settingsKey = 'reminderSettings';
  static const String _askedKey = 'reminderPermissionAsked';
  static const String _daysKey = 'journalDays';
  static const String _streakShownKey = 'streakShown';

  static const int _quoteId = 102;
  static const int _breatherId = 103;
  static const int _sundayId = 104;
  static const int _birthdayId = 105;
  static const int _comebackId = 106;
  static const int _streakId = 107;
  static const int _journalBaseId = 110; // 110-116: one per weekday so the 5 messages rotate

  static const List<String> dailyTypes = ['journal', 'quote', 'breather'];
  static const List<int> streakMilestones = [3, 7, 14, 30, 60, 100, 365];

  static const Map<String, Map<String, dynamic>> _defaults = {
    'journal': {'on': true, 'h': 20, 'm': 0},
    'quote': {'on': true, 'h': 8, 'm': 0},
    'breather': {'on': false, 'h': 12, 'm': 30},
    'sunday': {'on': true, 'h': 18, 'm': 0},
    'birthday': {'on': true},
    'streak': {'on': true},
    'comeback': {'on': true},
  };

  /// Current settings: defaults, overwritten by whatever the person saved.
  Map<String, Map<String, dynamic>> get settings {
    final saved = _box.read(_settingsKey);
    final out = <String, Map<String, dynamic>>{};
    _defaults.forEach((k, v) {
      final m = Map<String, dynamic>.from(v);
      if (saved is Map && saved[k] is Map) m.addAll(Map<String, dynamic>.from(saved[k]));
      out[k] = m;
    });
    return out;
  }

  int get dailyOnCount => dailyTypes.where((t) => settings[t]?['on'] == true).length;

  /// Turn one reminder on or off. Returns false if it would go over 2 daily reminders.
  Future<bool> setOn(String type, bool on) async {
    final s = settings;
    final alreadyOn = s[type]?['on'] == true;
    if (on && dailyTypes.contains(type) && alreadyOn == false && dailyOnCount >= 2) return false;
    s[type]?['on'] = on;
    await _box.write(_settingsKey, s);
    await rescheduleAll();
    return true;
  }

  Future<void> setTime(String type, int h, int m) async {
    final s = settings;
    s[type]?['h'] = h;
    s[type]?['m'] = m;
    await _box.write(_settingsKey, s);
    await rescheduleAll();
  }

  Future<void> init() async {
    if (_ready) return;
    try {
      tzdata.initializeTimeZones();
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      // Unknown time zone name: keep the default.
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _ready = true;
  }

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  Future<bool> notificationsAllowed() async {
    await init();
    return await _android?.areNotificationsEnabled() ?? true;
  }

  Future<bool> requestPermission() async {
    await init();
    return await _android?.requestNotificationsPermission() ?? true;
  }

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          'morphzing_reminders',
          'Reminders',
          channelDescription: 'Gentle reminders from MorphZing',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      );

  /// Next time it is h:m (optionally on a given weekday, 1 = Monday ... 7 = Sunday).
  tz.TZDateTime _next(int h, int m, {int? weekday}) {
    final now = tz.TZDateTime.now(tz.local);
    for (var add = 0; add < 8; add++) {
      final t = tz.TZDateTime(tz.local, now.year, now.month, now.day + add, h, m);
      if (t.isAfter(now) && (weekday == null || t.weekday == weekday)) return t;
    }
    return tz.TZDateTime(tz.local, now.year, now.month, now.day + 1, h, m);
  }

  Future<void> _schedule(int id, String title, String body, tz.TZDateTime when, DateTimeComponents? match) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: match,
    );
  }

  int _int(dynamic v, int fallback) => v is int ? v : fallback;

  DateTime? _birthday() {
    final raw = _box.read('userBirthday');
    return raw is String ? DateTime.tryParse(raw) : null;
  }

  /// Home passes the profile's birth_date here. Saved on the phone only.
  Future<void> rememberBirthday(dynamic raw) async {
    if (raw is String && raw.isNotEmpty && (_box.read('userBirthday') == raw) == false) {
      await _box.write('userBirthday', raw);
      await rescheduleAll();
    }
  }

  /// Cancel and re-create every reminder from the saved settings. Safe to call often
  /// (app start, Home, language change). Also restarts the 3-day comeback timer.
  Future<void> rescheduleAll() async {
    try {
      await init();
      final s = settings;
      final ids = <int>[_quoteId, _breatherId, _sundayId, _birthdayId, _comebackId];
      for (var i = 0; i < 7; i++) {
        ids.add(_journalBaseId + i);
      }
      for (final id in ids) {
        await _plugin.cancel(id: id);
      }

      final j = s['journal'] ?? const {};
      if (j['on'] == true) {
        final msgs = [journalReminder1, journalReminder2, journalReminder3, journalReminder4, journalReminder5];
        for (var wd = 1; wd <= 7; wd++) {
          await _schedule(_journalBaseId + wd - 1, notifJournalTitle.tr, msgs[(wd - 1) % 5].tr,
              _next(_int(j['h'], 20), _int(j['m'], 0), weekday: wd), DateTimeComponents.dayOfWeekAndTime);
        }
      }
      final q = s['quote'] ?? const {};
      if (q['on'] == true) {
        await _schedule(_quoteId, notifQuoteTitle.tr, notifQuoteBody.tr,
            _next(_int(q['h'], 8), _int(q['m'], 0)), DateTimeComponents.time);
      }
      final b = s['breather'] ?? const {};
      if (b['on'] == true) {
        await _schedule(_breatherId, notifBreatherTitle.tr, notifBreatherBody.tr,
            _next(_int(b['h'], 12), _int(b['m'], 30)), DateTimeComponents.time);
      }
      final su = s['sunday'] ?? const {};
      if (su['on'] == true) {
        await _schedule(_sundayId, notifSundayTitle.tr, notifSundayBody.tr,
            _next(_int(su['h'], 18), _int(su['m'], 0), weekday: DateTime.sunday), DateTimeComponents.dayOfWeekAndTime);
      }
      final bd = _birthday();
      if (s['birthday']?['on'] == true && bd is DateTime) {
        final now = tz.TZDateTime.now(tz.local);
        var t = tz.TZDateTime(tz.local, now.year, bd.month, bd.day, 9, 0);
        if (t.isBefore(now)) t = tz.TZDateTime(tz.local, now.year + 1, bd.month, bd.day, 9, 0);
        await _schedule(_birthdayId, notifBirthdayTitle.tr, notifBirthdayBody.tr, t, DateTimeComponents.dateAndTime);
      }
      if (s['comeback']?['on'] == true) {
        final now = tz.TZDateTime.now(tz.local);
        final t = tz.TZDateTime(tz.local, now.year, now.month, now.day + 3, 18, 0);
        await _schedule(_comebackId, notifComebackTitle.tr, notifComebackBody.tr, t, null);
      }
    } catch (_) {
      // Never crash the app over a reminder.
    }
  }

  int _streak(Set<String> days) {
    var d = DateTime.now();
    var n = 0;
    while (days.contains('${d.year}-${d.month}-${d.day}')) {
      n++;
      d = DateTime(d.year, d.month, d.day - 1);
    }
    return n;
  }

  /// Call after a journal entry is saved: counts the streak, celebrates milestones,
  /// and the first time ever asks if they want reminders.
  Future<void> onJournalSaved() async {
    try {
      final now = DateTime.now();
      final today = '${now.year}-${now.month}-${now.day}';
      final days = Set<String>.from(_box.read<List>(_daysKey) ?? const []);
      days.add(today);
      await _box.write(_daysKey, days.toList());
      final streak = _streak(days);
      final shownKey = '$streak-$today';
      if (settings['streak']?['on'] == true &&
          streakMilestones.contains(streak) &&
          (_box.read(_streakShownKey) == shownKey) == false) {
        await _box.write(_streakShownKey, shownKey);
        await init();
        await _plugin.show(
          id: _streakId,
          title: notifStreakTitle.tr,
          body: notifStreakBody.trParams({'days': '$streak'}),
          notificationDetails: _details,
        );
      }
      if (_box.read(_askedKey) == null) await _askOnce();
    } catch (_) {}
  }

  Future<void> _askOnce() async {
    final ctx = Get.context;
    if (ctx == null) return;
    await _box.write(_askedKey, true);
    final yes = await showDialog<bool>(
      context: ctx,
      builder: (c) => AlertDialog(
        title: Text(notifAskTitle.tr),
        content: Text(notifAskBody.tr),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: Text(notifAskNo.tr)),
          TextButton(onPressed: () => Navigator.of(c).pop(true), child: Text(notifAskYes.tr)),
        ],
      ),
    );
    if (yes == true) {
      await requestPermission();
      await rescheduleAll();
    } else {
      // Not now: turn everything off (older phones show notifications without asking).
      final s = settings;
      for (final k in s.keys) {
        s[k]?['on'] = false;
      }
      await _box.write(_settingsKey, s);
      await rescheduleAll();
    }
  }
}
