import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/entry/splash/splash_controller.dart';
import 'package:morphzing/utils/style/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController controller = SplashController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<SplashController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          backgroundColor: blueColor,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.height / 2,
                  child: const Center(
                      child: Image(
                          image: AssetImage("assets/icons/app_icon.png"))),
                ),
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      appName.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: "SF Pro Display",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
