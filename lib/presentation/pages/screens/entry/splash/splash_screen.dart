import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/presentation/pages/screens/entry/splash/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController controller = SplashController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFF000000),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: Image.asset('assets/images/black_mz_logo.png'),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
