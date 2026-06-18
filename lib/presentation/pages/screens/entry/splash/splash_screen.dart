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
          backgroundColor: const Color(0xFF1a1f30),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'MorphZing',
                  style: TextStyle(
                    color: Color(0xFFeceaf8),
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get organized. Get inspired. Find peace.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6a6a88),
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Text(
                    'One simple app. One beautiful journey.',
                    style: TextStyle(
                      color: Color(0xFF4a4a62),
                      fontSize: 12,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
