import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/locale_enum.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/entry/setup_language/setup_language_controller.dart';

/// First screen on a new install: one tap picks English or Spanish,
/// then goes to the intro pages (the intro saves the choice).
class SetupLanguageScreen extends StatefulWidget {
  const SetupLanguageScreen({Key? key}) : super(key: key);

  @override
  State<SetupLanguageScreen> createState() => _SetupLanguageScreenState();
}

class _SetupLanguageScreenState extends State<SetupLanguageScreen> {
  final SetupLanguageController controller = SetupLanguageController();
  static const _white = TextStyle(color: Colors.white, fontFamily: 'SF Pro Display');
  bool _busy = false;

  void _pick(LocaleEnum locale) {
    if (_busy) return;
    _busy = true;
    controller.changeLanguage(locale);
    // Short pause so the new language is applied before the intro opens.
    Future.delayed(const Duration(milliseconds: 200), controller.onPressedNext);
    // Allow picking again if the user comes back to this screen.
    Future.delayed(const Duration(milliseconds: 900), () => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset('assets/images/intro/intro_language.jpg',
                        fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 24),
                Text(chooseLanguageBoth.tr,
                    textAlign: TextAlign.center,
                    style: _white.copyWith(fontSize: 22, fontWeight: FontWeight.w700, height: 1.3)),
                const SizedBox(height: 28),
                _langButton(languageNameEn.tr, () => _pick(LocaleEnum.en)),
                const SizedBox(height: 12),
                _langButton(languageNameEs.tr, () => _pick(LocaleEnum.es)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _langButton(String label, VoidCallback onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Colors.white.withOpacity(0.14),
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 56,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.25), width: 0.6),
              ),
              child: Text(label,
                  style: _white.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
}
