import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
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
                onPressed: () {},
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
                  onPressed: () {},
                  icon: Icon(Icons.keyboard_arrow_down, color: linkColor),
                  label: Text(
                    moreOptions.tr,
                    style: TextStyle(color: linkColor, fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
