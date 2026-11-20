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
  final bool hideHintOnFocus; // example shows until tapped, then the box is empty

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
    this.hideHintOnFocus = false,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool isPassword;
  bool _isHidden = true;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (mounted) setState(() {});
    });
    if (widget.labelText.contains('Password') ||
        widget.labelText.contains('password')) {
      isPassword = true;
    } else {
      isPassword = false;
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
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
      focusNode: _focus,
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
        floatingLabelBehavior: widget.hideHintOnFocus ? FloatingLabelBehavior.always : null,
        hintText: (widget.hideHintOnFocus && _focus.hasFocus) ? null : widget.hintText,
        hintStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'SF Pro Display',
            color: isDark ? Colors.white54 : hintTextColor),
      ),
    );
  }
}
