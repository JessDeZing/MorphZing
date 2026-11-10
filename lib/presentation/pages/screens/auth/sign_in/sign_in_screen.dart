import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/utils/last_login.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/logic/controllers/social_controller.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/user/login_provider.dart';
import 'package:morphzing/data/repositories/auth/auth_repository.dart';
import 'package:morphzing/data/repositories/auth/token_repository.dart';
import 'package:morphzing/data/repositories/common/common_repository.dart';
import 'package:morphzing/data/repositories/user/user_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

/// New combined sign-in / sign-up screen (login redesign).
/// Piece 1: layout only. Buttons are wired up in later pieces.
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  static const List<Color> _rainbow = [
    Colors.red, Colors.pink, Colors.purple, Colors.deepPurple, Colors.indigo,
    Colors.blue, Colors.lightBlue, Colors.cyan, Colors.teal, Colors.green,
    Colors.lightGreen, Colors.lime, Colors.yellow, Colors.amber,
    Colors.orange, Colors.deepOrange,
  ];
  static const Color _purple = Color(0xFF8B6FE8);
  static const String _font = 'SF Pro Display';

  int _tab = 0; // 0 = email (default), 1 = phone (small link at the bottom)
  bool _loginFailed = false; // shows the create-an-account nudge
  bool _hidePassword = true;
  String? _lastUsed; // 'apple', 'google', 'email' or 'phone'

  @override
  void initState() {
    super.initState();
    _lastUsed = LastLogin.get();
    _tab = _lastUsed == 'phone' ? 1 : 0;
  }
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final SocialController _social = SocialController();

  // Google sign-in. Server errors (like "account already exists") are shown
  // automatically by the app's error pop-up; here we only cover Google itself failing.
  Future<void> _google() async {
    LoadingOverlay.show(context);
    try {
      await _social.socialGoogle();
    } catch (error) {
      final text = error.toString();
      if (!text.contains('DioException') && !text.contains('DioError')) {
        _showError(googleSignInFailed.tr);
      }
    } finally {
      LoadingOverlay.hide();
    }
  }

  // Apple sign-in (iPhone only). Same as Google: server errors show in the app's
  // error pop-up; tapping Cancel on Apple's sheet does nothing.
  Future<void> _apple() async {
    LoadingOverlay.show(context);
    try {
      await _social.socialApple();
    } catch (error) {
      final text = error.toString();
      if (text.contains('DioException') == false && text.contains('DioError') == false) {
        _showError(appleSignInFailed.tr);
      }
    } finally {
      LoadingOverlay.hide();
    }
  }

  final AuthRepository _authRepository = getIt<AuthRepository>();
  final TokenRepository _tokenRepository = getIt<TokenRepository>();
  final UserRepository _userRepository = getIt<UserRepository>();
  final CommonRepository _commonRepository = getIt<CommonRepository>();

  // Continue: log in with email + password (Email tab) or +1 phone + password (Phone tab).
  // Same steps as the old login screen. Server errors show in the app's error pop-up.
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF3B30),
        behavior: SnackBarBehavior.floating,
      ));
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    setState(() => _loginFailed = false);
    final password = _passwordController.text;
    final LoginProvider provider;
    if (_tab == 0) {
      final email = _emailController.text.trim();
      if (!GetUtils.isEmail(email) || password.length < 8) {
        _showError(checkEmailPassword.tr);
        return;
      }
      provider = LoginProvider(email: email, password: password);
    } else {
      final digits = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.length != 10 || password.length < 8) {
        _showError(checkPhonePassword.tr);
        return;
      }
      provider = LoginProvider(phone: '1$digits', password: password);
    }
    LoadingOverlay.show(context);
    try {
      final tokens = await _authRepository.login(provider);
      await _tokenRepository.saveToken(tokens.access, tokens.refresh!);
      Get.find<AppController>().user = await _userRepository.getUserInfo();
      await _commonRepository.setAuth(true);
      LastLogin.save(_tab == 0 ? 'email' : 'phone');
      LoadingOverlay.hide();
      Get.offAllNamed(homeRoute);
    } catch (e) {
      LoadingOverlay.hide();
      // Server said no (e.g. wrong password)
      if (e is DioException && e.response != null) {
        setState(() => _loginFailed = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : blackTextColor;
    final subColor = isDark ? const Color(0xFFA9A6BD) : greyTextColor;
    final linkColor = isDark ? const Color(0xFFB9A6FF) : const Color(0xFF5B3FD0);
    final lineColor = isDark ? const Color(0xFF2E3456) : borderColor;
    final tagline = TextStyle(
      color: textColor,
      fontSize: 32,
      fontFamily: _font,
      fontWeight: FontWeight.bold,
      height: 1.15,
    );

    return Scaffold(
      backgroundColor: isDark ? darkBgColor : bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 40, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Brand tagline (stays English, same as the old screen)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GradientText('M', style: tagline, colors: _rainbow),
                Text('orph your future', style: tagline),
              ]),
              Text('into something', style: tagline, textAlign: TextAlign.center),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('ama', style: tagline),
                GradientText('Z', style: tagline, colors: _rainbow),
                Text('ing', style: tagline),
              ]),
              const SizedBox(height: 36),
              Text(
                signInTitle.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontFamily: _font, fontSize: 26, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                signInSubtitle.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: subColor, fontFamily: _font, fontSize: 15),
              ),
              const SizedBox(height: 28),
              // Apple: hidden on Android (needs Service ID setup there).
              if (Platform.isAndroid == false) ...[
                _socialButton(
                  label: continueWithApple.tr,
                  icon: Icon(Icons.apple, size: 22, color: isDark ? Colors.black : Colors.white),
                  background: isDark ? Colors.white : Colors.black,
                  foreground: isDark ? Colors.black : Colors.white,
                  lastUsed: _lastUsed == 'apple',
                  onPressed: _apple,
                ),
                const SizedBox(height: 14),
              ],
              _socialButton(
                label: continueWithGoogle.tr,
                icon: SvgPicture.asset('assets/icons/google.svg', width: 20, height: 20),
                lastUsed: _lastUsed == 'google',
                background: isDark ? const Color(0xFF1E1E2A) : Colors.white,
                foreground: textColor,
                border: _purple,
                onPressed: _google,
              ),
              const SizedBox(height: 22),
              Row(children: [
                Expanded(child: Divider(color: lineColor, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(orDivider.tr, style: TextStyle(color: subColor, fontFamily: _font, fontSize: 13)),
                ),
                Expanded(child: Divider(color: lineColor, thickness: 1)),
              ]),
              const SizedBox(height: 18),
              ..._form(isDark, textColor, subColor, linkColor),
            ],
          ),
        ),
      ),
    );
  }

  // Email (default) or phone (small link at the bottom), password, Sign in,
  // then a clear Create an account button.
  List<Widget> _form(bool isDark, Color textColor, Color subColor, Color linkColor) {
    final fieldFill = isDark ? const Color(0xFF1E1E2A) : Colors.white;
    final fieldBorder = isDark ? const Color(0xFF2E3456) : borderColor;
    final errBg = isDark ? const Color(0xFF3A1E22) : const Color(0xFFFDECEC);
    final errText = isDark ? const Color(0xFFFF8A80) : const Color(0xFFB3261E);
    final labelStyle = TextStyle(color: subColor, fontFamily: _font, fontSize: 14);
    final fieldText = TextStyle(color: textColor, fontFamily: _font, fontSize: 16);
    InputDecoration deco(String hint) => InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: subColor, fontFamily: _font),
          filled: true,
          fillColor: fieldFill,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _loginFailed ? errText : fieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _purple, width: 2),
          ),
        );

    return [
      if (_tab == 1) ...[
        Text(fieldPhoneNumber.tr, style: labelStyle),
        const SizedBox(height: 6),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: fieldText,
          decoration: deco('(312) 555-1234').copyWith(
            // Phone login is US/Canada only, so +1 is built in
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 6),
              child: Text('+1', style: TextStyle(color: subColor, fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
        const SizedBox(height: 6),
        Text(phoneOutsideHint.tr, style: TextStyle(color: subColor, fontFamily: _font, fontSize: 13)),
      ] else ...[
        Text(fieldEmail.tr, style: labelStyle),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          style: fieldText,
          decoration: deco('you@example.com'),
        ),
      ],
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(fieldPassword.tr, style: labelStyle),
        TextButton(
          onPressed: () => Get.toNamed(forgotPasswordEmailRoute),
          child: Text(
            forgotPassword.tr,
            style: TextStyle(color: linkColor, fontFamily: _font, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ]),
      TextField(
        controller: _passwordController,
        obscureText: _hidePassword,
        style: fieldText,
        decoration: deco(passwordHint.tr).copyWith(
          suffixIcon: IconButton(
            onPressed: () => setState(() => _hidePassword = _hidePassword == false),
            icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility, color: subColor),
          ),
        ),
      ),
      if (_loginFailed) ...[
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
          decoration: BoxDecoration(color: errBg, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loginFailedTitle.tr, style: TextStyle(color: errText, fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(loginFailedBody.tr, style: TextStyle(color: textColor, fontFamily: _font, fontSize: 14)),
              TextButton(
                onPressed: () => Get.toNamed(emailSignUpRoute),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  '${createAnAccount.tr} \u2192',
                  style: TextStyle(color: linkColor, fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ],
      const SizedBox(height: 20),
      SizedBox(
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(colors: [Color(0xFF4F6BED), _purple]),
          ),
          child: ElevatedButton(
            onPressed: _continue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              signInButton.tr,
              style: const TextStyle(color: Colors.white, fontFamily: _font, fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
      Text(
        newToMorphZing.tr,
        textAlign: TextAlign.center,
        style: TextStyle(color: subColor, fontFamily: _font, fontSize: 15),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 56,
        child: OutlinedButton(
          onPressed: () => Get.toNamed(emailSignUpRoute),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: linkColor, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
            createAnAccount.tr,
            style: TextStyle(color: linkColor, fontFamily: _font, fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      const SizedBox(height: 18),
      Center(
        child: TextButton(
          onPressed: () => setState(() {
            _tab = _tab == 0 ? 1 : 0;
            _loginFailed = false;
          }),
          child: Text(
            (_tab == 0 ? usePhoneInstead : useEmailInstead).tr,
            style: TextStyle(
              color: subColor,
              fontFamily: _font,
              fontSize: 13,
              decoration: TextDecoration.underline,
              decorationColor: subColor,
            ),
          ),
        ),
      ),
    ];
  }

  // Small mint "Last used" tag
  Widget _lastUsedBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(color: const Color(0xFF86EFAC), borderRadius: BorderRadius.circular(6)),
        child: Text(
          lastUsedBadge.tr,
          style: const TextStyle(color: Color(0xFF050A41), fontFamily: _font, fontSize: 11, fontWeight: FontWeight.w600),
        ),
      );

  Widget _socialButton({
    required String label,
    Widget? icon,
    required Color background,
    required Color foreground,
    Color? border,
    required VoidCallback onPressed,
    bool lastUsed = false,
  }) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: border == null ? BorderSide.none : BorderSide(color: border, width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon, const SizedBox(width: 10)],
            Text(
              label,
              style: TextStyle(color: foreground, fontFamily: _font, fontSize: 17, fontWeight: FontWeight.w600),
            ),
            if (lastUsed) ...[const SizedBox(width: 8), _lastUsedBadge()],
          ],
        ),
      ),
    );
  }
}
