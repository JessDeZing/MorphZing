import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/logic/controllers/social_controller.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';

class SocialComponent extends StatelessWidget {
  const SocialComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<SocialController>(
      init: SocialController(),
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                LoadingOverlay.show(context);
                await controller.socialGoogle().then((value) {
                  LoadingOverlay.hide();
                }).onError((error, stackTrace) {
                  LoadingOverlay.hide();
                  showInternalError(title: 'Social', desc: error.toString());
                });
              },
              child: socialLinks(
                isDark
                    ? Theme.of(context).appBarTheme.backgroundColor ??
                        whiteColor
                    : whiteColor,
                'assets/icons/google.svg',
                context,
                isDark,
              ),
            ),
            GestureDetector(
              onTap: () async {
                LoadingOverlay.show(context);
                await controller.socialFacebook().then((value) {
                  print('onSuccess');
                  LoadingOverlay.hide();
                }).onError((error, stackTrace) {
                  print('onError');
                  LoadingOverlay.hide();
                  showInternalError(title: 'Social', desc: error.toString());
                });
              },
              child: socialLinks(
                isDark
                    ? Theme.of(context).appBarTheme.backgroundColor ??
                        whiteColor
                    : whiteColor,
                'assets/icons/facebook.svg',
                context,
                isDark,
              ),
            ),
            Platform.isIOS
                ? GestureDetector(
                    onTap: () async {
                      LoadingOverlay.show(context);
                      await controller.socialApple().then((value) {
                        print('onSuccess');
                        LoadingOverlay.hide();
                      }).onError((error, stackTrace) {
                        print('onError');
                        LoadingOverlay.hide();
                        showInternalError(
                            title: 'Social', desc: error.toString());
                      });
                    },
                    child: socialLinks(
                      Colors.black,
                      'assets/icons/apple.svg',
                      context,
                      isDark,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  socialLinks(Color clr, String asset, BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 40,
        width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: clr,
            border: (clr ==
                    (isDark
                        ? Theme.of(context).appBarTheme.backgroundColor ??
                            whiteColor
                        : whiteColor))
                ? Border.all(
                    width: 1,
                    color: isDark
                        ? Theme.of(context).appBarTheme.backgroundColor ??
                            borderColor
                        : borderColor)
                : Border.all(color: clr)),
        child: Center(
          child: SizedBox(
            height: 14,
            width: 14,
            child: SvgPicture.asset(asset),
          ),
        ),
      ),
    );
  }
}
