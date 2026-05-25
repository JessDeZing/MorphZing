import 'package:get/get.dart';
import 'package:morphzing/data/models/verification/phone_verification_provider.dart';
import 'package:morphzing/data/repositories/auth/auth_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/verification/verification_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';

class SignUpController extends GetxController {
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final RxString _phone = ''.obs;
  final RxBool smsTwilioConsentAccepted = RxBool(false);

  String get phone => _phone.value;

  set phone(String value) => _phone.value = value;

  void onPressedLogin() => Get.back();

  void onPressedSignUp() {
    _authRepository.auth(PhoneVerificationPost(phone: phone)).then((value) {
      LoadingOverlay.hide();
      Get.toNamed(
        verificationRoute,
        arguments: VerificationScreenParam(
          verificationType: VerificationType.signUpVerification,
          phone: phone,
        ),
      );
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  bool isValidate() {
    return phone.length == 11 && smsTwilioConsentAccepted.value;
  }
}
