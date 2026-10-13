import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/logic/controllers/social_controller.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
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

  bool _expanded = false;
  int _tab = 0; // 0 = email (default, free), 1 = phone
  bool _hidePassword = true;
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
        showErrorSnackBar(message: googleSignInFailed.tr);
      }
    } finally {
      LoadingOverlay.hide();
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
          padding: const EdgeInsets.fromLTRB(28, 48, 28, 32),
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
              const SizedBox(height: 48),
              Text(
                signInOrCreate.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontFamily: _font, fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                oneTapIn.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: subColor, fontFamily: _font, fontSize: 15),
              ),
              const SizedBox(height: 36),
              _socialButton(
                label: continueWithApple.tr,
                icon: Icon(Icons.apple, size: 22, color: isDark ? Colors.black : Colors.white),
                background: isDark ? Colors.white : Colors.black,
                foreground: isDark ? Colors.black : Colors.white,
                onPressed: () {},
              ),
              const SizedBox(height: 14),
              _socialButton(
                label: continueWithGoogle.tr,
                background: isDark ? const Color(0xFF1E1E2A) : Colors.white,
                foreground: textColor,
                border: _purple,
                onPressed: _google,
              ),
              const SizedBox(height: 30),
              Row(children: [
                Expanded(child: Divider(color: lineColor, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(orDivider.tr, style: TextStyle(color: subColor, fontFamily: _font, fontSize: 13)),
                ),
                Expanded(child: Divider(color: lineColor, thickness: 1)),
              ]),
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  icon: Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: linkColor),
                  label: Text(
                    _expanded ? fewerOptions.tr : moreOptions.tr,
                    style: TextStyle(color: linkColor, fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              if (_expanded) ..._moreOptions(isDark, textColor, subColor, linkColor),
            ],
          ),
        ),
      ),
    );
  }

  // "More options": Phone | Email tabs, fields, Continue (wired up in piece 3)
  List<Widget> _moreOptions(bool isDark, Color textColor, Color subColor, Color linkColor) {
    final fieldFill = isDark ? const Color(0xFF1E1E2A) : Colors.white;
    final fieldBorder = isDark ? const Color(0xFF2E3456) : borderColor;
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
            borderSide: BorderSide(color: fieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _purple, width: 2),
          ),
        );

    return [
      const SizedBox(height: 8),
      _tabs(isDark, subColor),
      const SizedBox(height: 20),
      if (_tab == 1) ...[
        Text(fieldPhoneNumber.tr, style: labelStyle),
        const SizedBox(height: 6),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: fieldText,
          decoration: deco('(312) 555-1234').copyWith(
            // Phone tab is US/Canada only, so +1 is built in
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
          onPressed: () {}, // wired up in piece 3
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
            onPressed: () => setState(() => _hidePassword = !_hidePassword),
            icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility, color: subColor),
          ),
        ),
      ),
      const SizedBox(height: 24),
      SizedBox(
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(colors: [Color(0xFF4F6BED), _purple]),
          ),
          child: ElevatedButton(
            onPressed: () {}, // wired up in piece 3
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              continueButton.tr,
              style: const TextStyle(color: Colors.white, fontFamily: _font, fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Center(
        child: TextButton(
          onPressed: () {}, // wired up in piece 3
          child: Text(
            newHereCreate.tr,
            style: TextStyle(color: linkColor, fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ];
  }

  Widget _tabs(bool isDark, Color subColor) {
    final track = isDark ? const Color(0xFF1E1E2A) : const Color(0xFFEEECF5);
    const active = Color(0xFF6A4FD6);
    Widget tab(String label, int index) {
      final selected = _tab == index;
      return Expanded(
        child: TextButton(
          onPressed: () => setState(() => _tab = index),
          style: TextButton.styleFrom(
            backgroundColor: selected ? active : Colors.transparent,
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : subColor,
              fontFamily: _font,
              fontSize: 15,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: track, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [tab(tabEmail.tr, 0), const SizedBox(width: 4), tab(tabPhone.tr, 1)]),
    );
  }

  Widget _socialButton({
    required String label,
    Widget? icon,
    required Color background,
    required Color foreground,
    Color? border,
    required VoidCallback onPressed,
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
          ],
        ),
      ),
    );
  }
}
