import 'package:flutter/material.dart';

import '../../utils/style/colors.dart';

class DefaultButton extends StatefulWidget {
  final String text;
  final String route;
  final BuildContext ctx;
  final Map arg;

  const DefaultButton({
    Key? key,
    required this.text,
    required this.route,
    required this.ctx,
    required this.arg,
  }) : super(key: key);

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        if (widget.route == '/login') {
          Navigator.pushNamedAndRemoveUntil(
              widget.ctx, widget.route, (route) => false);
        } else if (widget.route == '/home') {
          Navigator.pushNamedAndRemoveUntil(
              widget.ctx, widget.route, (route) => false);
        } else {
          print("This is Arg: ${widget.arg}");
          Navigator.pushNamed(widget.ctx, widget.route,
              arguments: widget.arg[1]);
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: blueColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: isDark
                  ? Theme.of(context)
                      .elevatedButtonTheme
                      .style
                      ?.foregroundColor
                      ?.resolve({})
                  : Colors.white,
              fontSize: 16,
              fontFamily: "SF Pro Display",
            ),
          ),
        ),
      ),
    );
  }
}
