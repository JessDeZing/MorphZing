import 'package:flutter/foundation.dart';

/// Network logs show in debug and profile runs (emulator testing),
/// but stay quiet in release builds (Play Store), so login tokens and
/// personal info never reach the phone's log.
void safeLogPrint(Object object) {
  if (!kReleaseMode) debugPrint(object.toString());
}
