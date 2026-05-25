import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/style/colors.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final String labelText;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final Widget? suffixIcon;
  final bool obscureText;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;

  const CustomInputField({
    Key? key,
    required this.hintText,
    required this.textEditingController,
    required this.labelText,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.suffixIcon,
    this.onChanged,
    this.textCapitalization,
    this.obscureText = false,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool isPassword;
  bool _isHidden = true;

  @override
  void initState() {
    super.initState();
    if (widget.labelText.contains('Password') ||
        widget.labelText.contains('password')) {
      isPassword = true;
    } else {
      isPassword = false;
    }
  }

  void _showPassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: widget.textEditingController,
      keyboardType: widget.keyboardType,
      obscureText: isPassword ? _isHidden : false,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines,
      minLines: 1,
      maxLength: isPassword ? 35 : widget.maxLength,
      onChanged: widget.onChanged,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      decoration: InputDecoration(
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: isPassword
            ? CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  _showPassword();
                },
                child: Icon(
                  _isHidden
                      ? CupertinoIcons.eye_fill
                      : CupertinoIcons.eye_slash_fill,
                  color: isDark ? Colors.white : const Color(0xFF050A41),
                ),
              )
            : null,
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'SF Pro Display',
            color: isDark ? Colors.white : hintTextColor),
      ),
    );
  }
}
