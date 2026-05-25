import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/create_password/create_password_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/registration/registration_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/verification/verification_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

class CreatePasswordController extends GetxController {
  final CreatePasswordScreenParam _param = Get.arguments;

  final RxString _password = ''.obs;

  final RxString _confirmPassword = ''.obs;

  String get password => _password.value;

  set password(value) => _password.value = value;

  String get confirmPassword => _confirmPassword.value;

  set confirmPassword(value) => _confirmPassword.value = value;

  void onPressedContinue() {
    if (_password.value.length >= 8) {
      if (_password.value == _confirmPassword.value) {
        Get.toNamed(
          registrationRoute,
          arguments: RegistrationScreenParam(
            secretKey: _param.secretKey,
            isSocial: _param.verificationType == VerificationType.socialVerification ? true : false,
            password: password,
          ),
        );
      } else {
        Get.snackbar('', passwordDoesNotMatch.tr);
      }
    } else {
      Get.snackbar('', passwordLengthMustBeAt.tr);
    }
  }

  bool isValidate() {
    if (_password.value.length >= 8 && _password.value == _confirmPassword.value) return true;

    return false;
  }
}
