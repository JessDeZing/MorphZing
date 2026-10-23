import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/user/reset_password_provider.dart';
import 'package:morphzing/data/repositories/auth/auth_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/phone/phone_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';

/// Email sign-up: (1) email -> (2) 6-digit code -> (3) password,
/// then the phone step and the profile step (isEmail: true).
class EmailSignUpScreen extends StatefulWidget {
  /// true = "Forgot password?" reset by email instead of sign-up.
  final bool isReset;

  const EmailSignUpScreen({Key? key, this.isReset = false}) : super(key: key);

  @override
  State<EmailSignUpScreen> createState() => _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends State<EmailSignUpScreen> {
  static const String _font = 'SF Pro Display';
  static const Color _purple = Color(0xFF6A4FD6);

  final AuthRepository _authRepository = getIt<AuthRepository>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  int _stage = 0; // 0 = email, 1 = code, 2 = password
  String _email = '';
  String _secret = '';

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // Flutter SnackBar (GetX pop-ups don't show on these screens)
  void _showMessage(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFFF3B30) : const Color(0xFF383E42),
        behavior: SnackBarBehavior.floating,
      ));
  }

  // Server errors look like {"errors":[{"message":"..."}]}; show that message.
  String _errorText(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['errors'] is List) {
        final messages = (data['errors'] as List)
            .map((x) => x is Map ? (x['message'] ?? '').toString() : '')
            .where((m) => m.isNotEmpty)
            .toList();
        if (messages.isNotEmpty) return messages.join('\n');
      }
    }
    return somethingWentWrongRetry.tr;
  }

  Future<void> _sendCode({bool resend = false}) async {
    FocusScope.of(context).unfocus();
    final email = resend ? _email : _emailController.text.trim().toLowerCase();
    if (!GetUtils.isEmail(email)) {
      _showMessage(enterValidEmail.tr);
      return;
    }
    LoadingOverlay.show(context);
    try {
      if (widget.isReset) {
        await _authRepository.forgotPasswordEmail(email);
      } else {
        await _authRepository.emailSendCode(email);
      }
      LoadingOverlay.hide();
      setState(() {
        _email = email;
        _codeController.clear();
        _stage = 1;
      });
      if (resend) _showMessage(newCodeSent.tr, isError: false);
    } catch (e) {
      LoadingOverlay.hide();
      _showMessage(_errorText(e));
    }
  }

  Future<void> _verifyCode() async {
    FocusScope.of(context).unfocus();
    final code = _codeController.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      _showMessage(enterSixDigitCode.tr);
      return;
    }
    LoadingOverlay.show(context);
    try {
      final secret = widget.isReset
          ? await _authRepository.forgotPasswordEmailVerify(_email, code)
          : await _authRepository.emailVerify(_email, code);
      LoadingOverlay.hide();
      setState(() {
        _secret = secret;
        _stage = 2;
      });
    } catch (e) {
      LoadingOverlay.hide();
      _showMessage(_errorText(e));
    }
  }

  void _toPhoneStep() {
    FocusScope.of(context).unfocus();
    final password = _passwordController.text;
    if (password.length < 8) {
      _showMessage(passwordLengthMustBeAt.tr);
      return;
    }
    if (password != _confirmController.text) {
      _showMessage(passwordDoesNotMatch.tr);
      return;
    }
    Get.toNamed(
      phoneRoute,
      arguments: PhoneScreenParam(
        secretKey: _secret,
        email: _email,
        password: password,
        isEmail: true,
      ),
    );
  }

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();
    final password = _passwordController.text;
    if (password.length < 8) {
      _showMessage(passwordLengthMustBeAt.tr);
      return;
    }
    if (password != _confirmController.text) {
      _showMessage(passwordDoesNotMatch.tr);
      return;
    }
    LoadingOverlay.show(context);
    try {
      await _authRepository.resetPassword(ResetPasswordProvider(
        secret: _secret,
        password: password,
        confirmPassword: _confirmController.text,
      ));
      LoadingOverlay.hide();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop(); // back to sign-in
      messenger.showSnackBar(SnackBar(
        content: Text(passwordUpdatedLogin.tr),
        backgroundColor: const Color(0xFF383E42),
        behavior: SnackBarBehavior.floating,
      ));
    } catch (e) {
      LoadingOverlay.hide();
      _showMessage(_errorText(e));
    }
  }

  void _startOver() {
    setState(() {
      _stage = 0;
      _secret = '';
      _codeController.clear();
      _passwordController.clear();
      _confirmController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFB);
    final textColor = isDark ? Colors.white : const Color(0xFF050A41);
    final subColor = isDark ? const Color(0xFFA9A6BD) : const Color(0xFF676A8B);
    final linkColor = isDark ? const Color(0xFFB9A6FF) : const Color(0xFF5B3FD0);

    return PopScope(
      canPop: _stage == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _startOver();
      },
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => _stage == 0 ? Navigator.of(context).pop() : _startOver(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _stage == 0
                  ? _emailStage(textColor, subColor, isDark)
                  : _stage == 1
                      ? _codeStage(textColor, subColor, linkColor, isDark)
                      : _passwordStage(textColor, subColor, isDark),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String text, Color color) => Text(
        text,
        style: TextStyle(color: color, fontFamily: _font, fontSize: 28, fontWeight: FontWeight.w700),
      );

  Widget _sub(String text, Color color) => Text(
        text,
        style: TextStyle(color: color, fontFamily: _font, fontSize: 15, height: 1.4),
      );

  Widget _field(TextEditingController c, String hint, bool isDark,
      {TextInputType? type,
      bool obscure = false,
      List<TextInputFormatter>? formatters,
      Iterable<String>? autofill}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: isDark ? const Color(0xFF2E3456) : const Color(0xFFE5E5EC)),
    );
    return TextField(
      controller: c,
      keyboardType: type,
      obscureText: obscure,
      inputFormatters: formatters,
      autofillHints: autofill,
      autocorrect: false,
      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF050A41), fontFamily: _font, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? const Color(0xFFA9A6BD) : const Color(0xFF676A8B), fontFamily: _font),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E2A) : Colors.white,
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: const BorderSide(color: _purple, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _button(VoidCallback onPressed) => SizedBox(
        height: 52,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _purple,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
            continueButton.tr,
            style: const TextStyle(color: Colors.white, fontFamily: _font, fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ),
      );

  Widget _link(String text, Color color, VoidCallback onPressed) => Center(
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: color, fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );

  List<Widget> _emailStage(Color textColor, Color subColor, bool isDark) => [
        _title((widget.isReset ? resetPasswordTitle : emailSignUpTitle).tr, textColor),
        const SizedBox(height: 8),
        _sub((widget.isReset ? resetPasswordDesc : emailSignUpDesc).tr, subColor),
        const SizedBox(height: 24),
        _field(_emailController, emailFieldHint.tr, isDark,
            type: TextInputType.emailAddress, autofill: const [AutofillHints.email]),
        const SizedBox(height: 24),
        _button(() => _sendCode()),
      ];

  List<Widget> _codeStage(Color textColor, Color subColor, Color linkColor, bool isDark) => [
        _title(checkYourEmailTitle.tr, textColor),
        const SizedBox(height: 8),
        _sub('${(widget.isReset ? resetCodeSentTo : codeSentTo).tr} $_email', subColor),
        const SizedBox(height: 24),
        _field(_codeController, codeFieldHint.tr, isDark,
            type: TextInputType.number,
            formatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
            autofill: const [AutofillHints.oneTimeCode]),
        const SizedBox(height: 24),
        _button(_verifyCode),
        const SizedBox(height: 8),
        _link(resendCodeLink.tr, linkColor, () => _sendCode(resend: true)),
        _link(useDifferentEmail.tr, linkColor, _startOver),
      ];

  List<Widget> _passwordStage(Color textColor, Color subColor, bool isDark) => [
        _title((widget.isReset ? newPasswordTitle : createPasswordTitle).tr, textColor),
        const SizedBox(height: 8),
        _sub(passwordRuleDesc.tr, subColor),
        const SizedBox(height: 24),
        _field(_passwordController, passwordFieldHint.tr, isDark,
            obscure: true, autofill: const [AutofillHints.newPassword]),
        const SizedBox(height: 12),
        _field(_confirmController, confirmPasswordFieldHint.tr, isDark,
            obscure: true, autofill: const [AutofillHints.newPassword]),
        const SizedBox(height: 24),
        _button(widget.isReset ? _resetPassword : _toPhoneStep),
      ];
}
