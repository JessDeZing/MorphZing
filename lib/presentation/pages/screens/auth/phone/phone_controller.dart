import 'package:get/get.dart';
import 'package:morphzing/presentation/pages/screens/auth/phone/phone_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/registration/registration_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';

class PhoneController extends GetxController {
  final PhoneScreenParam _param = Get.arguments;

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

  // Any country: country code + number, 8 to 15 digits (same rule as the server)
  bool isValidate() => RegExp(r'^[1-9]\d{7,14}$').hasMatch(phone);
}
