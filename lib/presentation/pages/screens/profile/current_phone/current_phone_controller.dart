import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/user/recovery_password_provider.dart';
import 'package:morphzing/data/models/verification/phone_verification_provider.dart';
import 'package:morphzing/data/repositories/auth/auth_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/pages/screens/auth/phone/phone_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/verification/verification_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';

class CurrentPhoneController extends GetxController {
  final AppController _appController = Get.find<AppController>();
  final AuthRepository _authRepository = getIt<AuthRepository>();

  late final RxString _phone = ''.obs;

  String get phone => _phone.value;

  set phone(String value) => _phone.value = value;

  Future<void> onPressedChangePhoneNumber() async {
    _authRepository.auth(PhoneVerificationPost(phone: phone)).then((value) {
      LoadingOverlay.hide();
      Get.toNamed(
        verificationRoute,
        arguments: VerificationScreenParam(
          verificationType: VerificationType.updatePhoneVerification,
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
