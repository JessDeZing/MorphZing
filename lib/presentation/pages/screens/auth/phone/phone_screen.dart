import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/phone/phone_controller.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class PhoneScreenParam {
  final String secretKey;
  final String? email;
  final String? password; // email sign-up only
  final bool isEmail; // true = email sign-up, false = Google/Apple

  PhoneScreenParam({required this.secretKey, this.email, this.password, this.isEmail = false});
}

/// Sign-up step for Google/Apple/email users: add a phone number (any country).
/// No text code is sent here, so it's free and works worldwide.
class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  static const Color _purple = Color(0xFF8B6FE8);
  static const String _font = 'SF Pro Display';

  final PhoneController controller = PhoneController();
  final TextEditingController _numberController = TextEditingController();
  String _dialCode = '+1';

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  // The server wants digits only: country code + number (e.g. 13125551234).
  void _updatePhone() {
    controller.phone = (_dialCode + _numberController.text).replaceAll(RegExp(r'[^0-9]'), '');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : blackTextColor;
    final subColor = isDark ? const Color(0xFFA9A6BD) : greyTextColor;
    final fieldFill = isDark ? const Color(0xFF1E1E2A) : Colors.white;
    final fieldBorder = isDark ? const Color(0xFF2E3456) : borderColor;
    final bg = isDark ? darkBgColor : bgColor;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          createAccountTitle.tr,
          style: TextStyle(color: textColor, fontFamily: _font, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                phoneStepTitle.tr,
                style: TextStyle(color: textColor, fontFamily: _font, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                phoneStepDesc.tr,
                style: TextStyle(color: subColor, fontFamily: _font, fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 28),
              Container(
                decoration: BoxDecoration(
                  color: fieldFill,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: fieldBorder),
                ),
                child: Row(children: [
                  CountryCodePicker(
                    onChanged: (code) {
                      _dialCode = code.dialCode ?? '+1';
                      _updatePhone();
                    },
                    initialSelection: 'US',
                    favorite: const ['US', 'CA', 'MX'],
                    showFlag: true,
                    textStyle: TextStyle(color: textColor, fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w600),
                    dialogBackgroundColor: bg,
                    dialogTextStyle: TextStyle(color: textColor, fontFamily: _font),
                    searchStyle: TextStyle(color: textColor, fontFamily: _font),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _numberController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 ()-]'))],
                      style: TextStyle(color: textColor, fontFamily: _font, fontSize: 16),
                      onChanged: (_) => _updatePhone(),
                      decoration: InputDecoration(
                        hintText: '312 555 1234',
                        hintStyle: TextStyle(color: subColor, fontFamily: _font),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 32),
              Obx(() {
                final enabled = controller.isValidate();
                return SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: enabled
                        ? () {
                            LoadingOverlay.show(context);
                            controller.onPressedContinue();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _purple,
                      disabledBackgroundColor: _purple.withValues(alpha: 0.35),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      continueButton.tr,
                      style: const TextStyle(color: Colors.white, fontFamily: _font, fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
