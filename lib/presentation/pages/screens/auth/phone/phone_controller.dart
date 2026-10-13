import 'package:get/get.dart';
import 'package:morphzing/data/models/user/recovery_password_provider.dart';
import 'package:morphzing/data/models/verification/phone_verification_provider.dart';
import 'package:morphzing/data/repositories/auth/auth_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/pages/screens/auth/phone/phone_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/registration/registration_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/verification/verification_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';

class PhoneController extends GetxController {
  final PhoneScreenParam _param = Get.arguments;
  final AuthRepository _authRepository = getIt<AuthRepository>();

  PhoneScreenParam get param => _param;

  final RxString _phone = ''.obs;

  String get phone => _phone.value;

  set phone(String value) => _phone.value = value;

  // Google/Apple/email sign-up: no text code (free, works worldwide).
  // The phone goes straight to the profile step; the server checks it there.
  Future<void> onPressedContinue() async {
    LoadingOverlay.hide();
    Get.toNamed(
      registrationRoute,
      arguments: RegistrationScreenParam(
        secretKey: _param.secretKey,
        isSocial: true,
        phone: phone,
        email: _param.email,
      ),
    );
  }

  bool isValidate() {
    if (phone.length == 11) return true;
    return false;
  }
}
