import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/di/di_config.dart';

/// Keeps the To-Do list in sync with the server, privately per account.
/// The phone copy ('tasks') stays the main copy, so the screen works offline.
/// 'tasksSynced' is the last copy the server confirmed. Anything different on
/// the phone (new, edited or removed) is sent on the next sync.
class TaskSync {
  TaskSync._();
  static final TaskSync instance = TaskSync._();

  /// Goes up by one whenever sync changes the phone list. The screen listens and reloads.
  final ValueNotifier<int> changes = ValueNotifier<int>(0);

  final GetStorage _box = GetStorage();
  static const String _tasksKey = 'tasks';
  static const String _ownerKey = 'tasksOwner';
  static const String _syncedKey = 'tasksSynced';
  static const int _batch = 500;
  bool _busy = false;
  bool _again = false;

  int? get _userId {
    try {
      return Get.find<AppController>().user?.id;
    } catch (_) {
      return null;
    }
  }

  List<dynamic> _local() => List<dynamic>.from(_box.read<List>(_tasksKey) ?? const []);

  /// Call before showing the list. If the phone list belongs to another account,
  /// set it aside (kept, never deleted) so nobody sees someone else's to-dos.
  void prepareForCurrentUser() {
    final uid = _userId;
    final owner = _box.read(_ownerKey);
    if (uid == null || owner == null || owner == uid) return;
    _box.write('tasks_setAside_$owner', _local());
    _box.write(_tasksKey, <dynamic>[]);
    _box.remove(_syncedKey);
    _box.write(_ownerKey, uid);
  }

  /// Send phone changes, then pull the server list. Silent: never shows pop-ups.
  Future<void> syncNow() async {
    final uid = _userId;
    if (uid == null) return;
    if (_busy) {
      _again = true;
      return;
    }
    _busy = true;
    try {
      // First sync on this phone: the current list belongs to this account.
      if (_box.read(_ownerKey) == null) _box.write(_ownerKey, uid);

      final startLocal = _local();
      final startJson = jsonEncode(startLocal);
      final synced = Map<String, dynamic>.from(_box.read(_syncedKey) ?? const {});

      // What changed on the phone since the last confirmed sync.
      final payload = <Map<String, dynamic>>[];
      final localIds = <String>{};
      for (final t in startLocal) {
        final id = '${t['id']}';
        localIds.add(id);
        if (synced[id] == jsonEncode(t)) continue;
        final title = '${t['title'] ?? ''}';
        payload.add({
          'client_id': id,
          'title': title.length > 500 ? title.substring(0, 500) : title,
          'color': t['color'],
          'due_date': t['dueDate'],
          'completed': t['completed'] ?? false,
          'is_deleted': false,
        });
      }
      for (final id in synced.keys) {
        if (localIds.contains(id)) continue;
        payload.add({'client_id': id, 'title': '-', 'is_deleted': true});
      }

      final dio = await getIt.getAsync<Dio>();
      final opts = Options(extra: {'silent': true});
      for (var i = 0; i < payload.length; i += _batch) {
        final end = i + _batch < payload.length ? i + _batch : payload.length;
        await dio.post('/tasks/sync/', data: {'tasks': payload.sublist(i, end)}, options: opts);
      }

      // Pull this account's list from the server.
      final res = await dio.get('/tasks/', options: opts);
      final server = <String, Map<String, dynamic>>{};
      for (final e in (res.data as List)) {
        if (e['is_deleted'] == true) continue;
        final id = '${e['client_id']}';
        server[id] = <String, dynamic>{
          'id': id,
          'title': e['title'],
          'color': e['color'],
          'dueDate': e['due_date'],
          'completed': e['completed'] ?? false,
        };
      }
      _box.write(_syncedKey, {for (final e in server.entries) e.key: jsonEncode(e.value)});

      final nowLocal = _local();
      if (jsonEncode(nowLocal) == startJson) {
        // Keep the phone's order; new ones from the server go at the end.
        final ordered = <dynamic>[];
        for (final t in nowLocal) {
          final s = server.remove('${t['id']}');
          if (s == null) continue;
          ordered.add(s);
        }
        ordered.addAll(server.values);
        if (jsonEncode(ordered) == startJson) return;
        _box.write(_tasksKey, ordered);
        changes.value = changes.value + 1;
      } else {
        // The user changed something while we were syncing: go again.
        _again = true;
      }
    } catch (_) {
      // Offline or server busy: keep everything on the phone and try next time.
    } finally {
      _busy = false;
      if (_again) {
        _again = false;
        Future.microtask(syncNow);
      }
    }
  }
}
