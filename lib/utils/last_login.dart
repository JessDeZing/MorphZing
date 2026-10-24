import 'package:get_storage/get_storage.dart';

/// Remembers how the user last signed in: 'google', 'email' or 'phone'.
/// Survives log out (log out only removes the login tokens).
class LastLogin {
  static const _key = 'lastLoginMethod';

  static String? get() {
    try {
      return GetStorage().read<String>(_key);
    } catch (_) {
      return null;
    }
  }

  static void save(String method) {
    try {
      GetStorage().write(_key, method);
    } catch (_) {}
  }
}
