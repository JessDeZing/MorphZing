import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/app_functions.dart';
import 'package:morphzing/utils/style/colors.dart';

class JourneyBottomSheet extends StatefulWidget {
  final VoidCallback onPressedLocation;
  final VoidCallback onPressedWebLink;
  final VoidCallback onPressedDocument;
  final VoidCallback onPressedCamera;
  final VoidCallback onPressedPhoto;

  const JourneyBottomSheet({
    Key? key,
    required this.onPressedLocation,
    required this.onPressedWebLink,
    required this.onPressedDocument,
    required this.onPressedCamera,
    required this.onPressedPhoto,
  }) : super(key: key);

  @override
  State<JourneyBottomSheet> createState() => _JourneyBottomSheetState();
}

class _JourneyBottomSheetState extends State<JourneyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(10),
      height: 400,
      decoration: BoxDecoration(
          color: isDark ? darkBgColor : whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    media.tr,
                    style: staticTextStyle(
                      20,
                      isDark ? Colors.white : blackTextColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isDark ? darkBgColor : bgColor,
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.clear,
                        size: 18,
                        color: isDark ? Colors.white : blackTextColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: GestureDetector(
              onTap: () => widget.onPressedLocation(),
              child: Container(
                padding: const EdgeInsets.all(14),
                height: 50,
                width: Get.width,
                decoration: BoxDecoration(
                    color: isDark ? darkBgColor : bgColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Image(
                        image: AssetImage('assets/images/location.png'),
                        color: isDark ? whiteColor : blackTextColor,
                        height: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        location.tr,
                        style: staticTextStyle(
                          17,
                          isDark ? Colors.white : blackTextColor,
                        ),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.forward,
                      size: 20,
                      color: isDark ? Colors.white : blackTextColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: GestureDetector(
              onTap: () => widget.onPressedWebLink(),
              child: Container(
                padding: const EdgeInsets.all(14),
                height: 50,
                width: Get.width,
                decoration: BoxDecoration(
                    color: isDark ? darkBgColor : bgColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Image(
                        image: AssetImage('assets/images/weblink.png'),
                        color: isDark ? whiteColor : blackTextColor,
                        height: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        weblink.tr,
                        style: staticTextStyle(
                          17,
                          isDark ? Colors.white : blackTextColor,
                        ),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.forward,
                      size: 20,
                      color: isDark ? Colors.white : blackTextColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: GestureDetector(
              onTap: () => widget.onPressedDocument(),
              child: Container(
                padding: const EdgeInsets.all(14),
                height: 50,
                width: Get.width,
                decoration: BoxDecoration(
                    color: isDark ? darkBgColor : bgColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Image(
                        image: AssetImage('assets/images/document.png'),
                        color: isDark ? whiteColor : blackTextColor,
                        height: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        document.tr,
                        style: staticTextStyle(
                          17,
                          isDark ? Colors.white : blackTextColor,
                        ),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.forward,
                      size: 20,
                      color: isDark ? Colors.white : blackTextColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: GestureDetector(
              onTap: () {
                widget.onPressedCamera();
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                height: 50,
                width: Get.width,
                decoration: BoxDecoration(
                    color: isDark ? darkBgColor : bgColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Image(
                        image: AssetImage('assets/images/camera.png'),
                        color: isDark ? whiteColor : blackTextColor,
                        height: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        camera.tr,
                        style: staticTextStyle(
                          17,
                          isDark ? Colors.white : blackTextColor,
                        ),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.forward,
                      size: 20,
                      color: isDark ? Colors.white : blackTextColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: GestureDetector(
              onTap: () => widget.onPressedPhoto(),
              child: Container(
                padding: const EdgeInsets.all(14),
                height: 50,
                width: Get.width,
                decoration: BoxDecoration(
                    color: isDark ? darkBgColor : bgColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Image(
                        image: AssetImage('assets/images/photo.png'),
                        color: isDark ? whiteColor : blackTextColor,
                        height: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        photo.tr,
                        style: staticTextStyle(
                          17,
                          isDark ? Colors.white : blackTextColor,
                        ),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.forward,
                      size: 20,
                      color: isDark ? Colors.white : blackTextColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
