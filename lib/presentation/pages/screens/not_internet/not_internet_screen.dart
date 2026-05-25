import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:morphzing/utils/theme_service.dart';

class NotInternetScreen extends StatefulWidget {
  const NotInternetScreen({Key? key}) : super(key: key);

  @override
  State<NotInternetScreen> createState() => _NotInternetScreenState();
}

class _NotInternetScreenState extends State<NotInternetScreen> {
  late StreamSubscription listenerConnectivity;

  @override
  @override
  void initState() {
    super.initState();
    listenerConnectivity = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      // Take the first result as the current connectivity status
      if (results.isNotEmpty) {
        _handleConnectivityChange(results.first);
      }
    });
  }

  Future<void> _handleConnectivityChange(ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      bool isDeviceConnected = await InternetConnectionChecker().hasConnection;

      if (!mounted) return;

      if (isDeviceConnected) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    listenerConnectivity.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: isDark ? darkBgColor : whiteColor,
        appBar: AppBar(
          backgroundColor: isDark ? darkBgColor : whiteColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SvgPicture.asset('assets/icons/not_internet.svg'),
                  10.verticalSpace,
                  Text(
                    noInternetTitle.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: isDark ? whiteColor : blackTextColor,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    noInternetDesc.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? whiteColor : dividerColor,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ElevatedButton(
                      onPressed: () async {
                        bool isDeviceConnected =
                            await getIt<InternetConnectionChecker>()
                                .hasConnection;
                        if (!mounted) return;

                        if (isDeviceConnected) {
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Try again'),
                    ),
                  ),
                  24.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
