import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/locale_enum.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/entry/setup_language/setup_language_controller.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SetupLanguageScreen extends StatefulWidget {
  const SetupLanguageScreen({Key? key}) : super(key: key);

  @override
  State<SetupLanguageScreen> createState() => _SetupLanguageScreenState();
}

class _SetupLanguageScreenState extends State<SetupLanguageScreen> {
  final SetupLanguageController controller = SetupLanguageController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<SetupLanguageController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/3x/language_logo.png'),
                          fit: BoxFit.cover)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 30.0,
                  left: 30,
                  right: 30,
                  bottom: 5,
                ),
                child: Text(
                  setupLanguageDescription.tr,
                  style: TextStyle(
                    color: isDark ? Colors.white : blackTextColor,
                    fontSize: 22,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    left: 30,
                    right: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientText(
                        'M',
                        style: TextStyle(
                          color: isDark ? Colors.white : blackTextColor,
                          fontSize: 34,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.bold,
                        ),
                        colors: const [
                          Colors.red,
                          Colors.pink,
                          Colors.purple,
                          Colors.deepPurple,
                          Colors.deepPurple,
                          Colors.indigo,
                          Colors.blue,
                          Colors.lightBlue,
                          Colors.cyan,
                          Colors.teal,
                          Colors.green,
                          Colors.lightGreen,
                          Colors.lime,
                          Colors.yellow,
                          Colors.amber,
                          Colors.orange,
                          Colors.deepOrange,
                        ],
                      ),
                      Text('orph your future',
                          style: TextStyle(
                            color: isDark ? Colors.white : blackTextColor,
                            fontSize: 34,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('into something',
                          style: TextStyle(
                            color: isDark ? Colors.white : blackTextColor,
                            fontSize: 34,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                    bottom: 5,
                    left: 30,
                    right: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ama',
                          style: TextStyle(
                            color: isDark ? Colors.white : blackTextColor,
                            fontSize: 34,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.bold,
                          )),
                      GradientText(
                        'Z',
                        style: TextStyle(
                          color: isDark ? Colors.white : blackTextColor,
                          fontSize: 34,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.bold,
                        ),
                        colors: const [
                          Colors.red,
                          Colors.pink,
                          Colors.purple,
                          Colors.deepPurple,
                          Colors.deepPurple,
                          Colors.indigo,
                          Colors.blue,
                          Colors.lightBlue,
                          Colors.cyan,
                          Colors.teal,
                          Colors.green,
                          Colors.lightGreen,
                          Colors.lime,
                          Colors.yellow,
                          Colors.amber,
                          Colors.orange,
                          Colors.deepOrange,
                        ],
                      ),
                      Text('ing',
                          style: TextStyle(
                            color: isDark ? Colors.white : blackTextColor,
                            fontSize: 34,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.changeLanguage(LocaleEnum.en);
                      },
                      child: Text(
                        english.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro Display',
                          color: Get.locale == LocaleEnum.en.getLocale()
                              ? blueColor
                              : isDark
                                  ? Colors.white
                                  : greyTextColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        width: 1,
                        height: 16,
                        color: isDark
                            ? Colors.white
                            : greyTextColor.withOpacity(0.5),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.changeLanguage(LocaleEnum.es);
                      },
                      child: Text(
                        spanish.tr,
                        style: TextStyle(
                          fontSize: 18,
                          // fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro Display',
                          color: Get.locale == LocaleEnum.es.getLocale()
                              ? blueColor
                              : isDark
                                  ? Colors.white
                                  : greyTextColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () => controller.onPressedNext(),
                  child: Text(next.tr),
                ),
              ),
              24.verticalSpace,
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        );
      },
    );
  }
}
