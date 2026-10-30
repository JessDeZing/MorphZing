import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/repositories/notifications/reminders.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/utils/style/colors.dart';

/// Reminders: free notifications scheduled on the phone. Up to 2 daily ones.
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>
    with WidgetsBindingObserver {
  final Reminders _r = Reminders.instance;
  Map<String, Map<String, dynamic>> _s = Reminders.instance.settings;
  bool _allowed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAllowed();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Coming back from the phone's settings: check again.
    if (state == AppLifecycleState.resumed) _checkAllowed();
  }

  Future<void> _checkAllowed() async {
    final ok = await _r.notificationsAllowed();
    if (mounted) setState(() => _allowed = ok);
  }

  Future<void> _toggle(String type, bool on) async {
    if (on && _allowed == false) {
      await _r.requestPermission();
      await _checkAllowed();
    }
    final ok = await _r.setOn(type, on);
    if (ok == false && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(remindersMaxTwo.tr)));
    }
    if (mounted) setState(() => _s = _r.settings);
  }

  Future<void> _pickTime(String type) async {
    final cur = _s[type] ?? const {};
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: cur['h'] is int ? cur['h'] : 20,
        minute: cur['m'] is int ? cur['m'] : 0,
      ),
    );
    if (picked == null) return;
    await _r.setTime(type, picked.hour, picked.minute);
    if (mounted) setState(() => _s = _r.settings);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? Colors.white : blackTextColor;
    final sub = isDark ? Colors.white70 : greyTextColor;
    final card = isDark ? darkBgColor : const Color(0xFFF6F6F6);
    return Scaffold(
      appBar: StaticAppBar.homeAppBar(context, remindersTitle.tr, false, ''),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          Text(
            remindersIntro.tr,
            style: customTextStyle(fontSize: 15, color: sub, fontWeight: FontWeight.w400),
          ),
          if (_allowed == false) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
              decoration: BoxDecoration(
                color: errorColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    remindersBlocked.tr,
                    style: customTextStyle(fontSize: 14, color: text, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () => AppSettings.openAppSettings(type: AppSettingsType.notification),
                    child: Text(remindersOpenSettings.tr),
                  ),
                ],
              ),
            ),
          ],
          _section(remindersDaily.tr, text),
          _row('journal', reminderJournal.tr, true, text, sub, card),
          _row('quote', reminderQuote.tr, true, text, sub, card),
          _row('breather', reminderBreather.tr, true, text, sub, card),
          _section(remindersWeekly.tr, text),
          _row('sunday', reminderSunday.tr, true, text, sub, card),
          _section(remindersSpecial.tr, text),
          _row('birthday', reminderBirthday.tr, false, text, sub, card),
          _row('streak', reminderStreak.tr, false, text, sub, card),
          _row('comeback', reminderComeback.tr, false, text, sub, card),
        ],
      ),
    );
  }

  Widget _section(String title, Color text) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Text(
          title,
          style: customTextStyle(fontSize: 18, color: text, fontWeight: FontWeight.w600),
        ),
      );

  Widget _row(String type, String label, bool hasTime, Color text, Color sub, Color card) {
    final cur = _s[type] ?? const {};
    final on = cur['on'] == true;
    final t = TimeOfDay(
      hour: cur['h'] is int ? cur['h'] : 0,
      minute: cur['m'] is int ? cur['m'] : 0,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: customTextStyle(fontSize: 15, color: text, fontWeight: FontWeight.w500),
                ),
                if (hasTime)
                  GestureDetector(
                    onTap: on ? () => _pickTime(type) : null,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        t.format(context),
                        style: customTextStyle(
                          fontSize: 14,
                          color: on ? blueColor : sub,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Switch(value: on, onChanged: (v) => _toggle(type, v), activeColor: blueColor),
        ],
      ),
    );
  }
}
