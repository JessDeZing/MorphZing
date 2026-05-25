import 'package:get/get.dart';
import 'package:morphzing/data/models/user/recovery_password_provider.dart';
import 'package:morphzing/data/models/verification/phone_verification_provider.dart';
import 'package:morphzing/data/repositories/auth/auth_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/pages/screens/auth/verification/verification_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';

class RecoveryPasswordController extends GetxController {
  final AuthRepository _authRepository = getIt<AuthRepository>();

  final RxString _phone = ''.obs;

  String get phone => _phone.value;

  set phone(value) => _phone.value = value;

  Future<void> onPressedContinue() async {
    _authRepository.recoveryPassword(RecoveryPasswordProvider(phone: phone)).then((value) {
      LoadingOverlay.hide();
      Get.toNamed(
        verificationRoute,
        arguments: VerificationScreenParam(
          verificationType: VerificationType.recoveryVerification,
          phone: phone,
        ),
      );
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  bool isValidate() {
    if (phone.length == 11) return true;
    return false;
  }
}
