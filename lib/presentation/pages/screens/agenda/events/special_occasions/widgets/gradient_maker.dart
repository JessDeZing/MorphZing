import 'package:flutter/material.dart';
import 'package:morphzing/utils/style/colors.dart';

class GradientMaker extends StatelessWidget {
  final Widget child;

  const GradientMaker({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) => specialOccasionGradient
          .createShader(Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height)),
      blendMode: BlendMode.srcIn,
      child: child,
    );
  }
}
