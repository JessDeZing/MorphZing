import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:morphzing/app_controller_binding.dart';
import 'package:morphzing/data/repositories/common/common_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/app_localization.dart';
import 'package:morphzing/localization/locale_enum.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/core/constants/router.dart';
import 'package:morphzing/utils/app_theme.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:morphzing/utils/theme_service.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  await GetStorage.init();
  initDi();
  final locale = getIt<CommonRepository>().getLocale();
  await initializeDateFormatting();
  runApp(MyApp(
    localeEnum: locale == 'es' ? LocaleEnum.es : LocaleEnum.en,
  ));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final LocaleEnum localeEnum;

  const MyApp({
    Key? key,
    required this.localeEnum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, _) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GetMaterialApp(
            initialBinding: AppControllerBinding(),
            translations: AppLocalization(),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.generateRoute,
            fallbackLocale: localeEnum.getLocale(),
            locale: localeEnum.getLocale(),
            initialRoute: splashRoute,
            navigatorObservers: [routeObserver],
            title: 'Morphzing',
            theme: ThemeData.light().copyWith(
              primaryColor: bgColor,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    foregroundColor: whiteColor,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    textStyle: const TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                      fontFamily: "SF Pro Display",
                    ),
                    fixedSize: const Size(double.maxFinite, 50),
                    minimumSize: const Size(double.maxFinite, 50),
                    maximumSize: const Size(double.maxFinite, 50),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
            ),
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeService.themeMode,
          ),
        ),
      ),
    );
  }
}

//RziPBu9A_eaK6u_cTM-o
