import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/style/colors.dart';

class FirstIntroScreen extends StatelessWidget {
  const FirstIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 320,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/3x/intro_first_image.png'),
                              fit: BoxFit.contain)),
                    ),
                    const SizedBox(height: 40),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          child: SvgPicture.asset(
                            'assets/icons/leading_icon.svg',
                            color: isDark
                                ? const Color(0xFF404040)
                                : const Color(0xFFE7E7ED),
                          ),
                        ),
                        Positioned(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 30.0,
                                  left: 30,
                                  right: 30,
                                  bottom: 12,
                                ),
                                child: Text(
                                  '${useYourJournalTo.tr}:',
                                  style: TextStyle(
                                    color:
                                        isDark ? Colors.white : blackTextColor,
                                    fontSize: 24,
                                    fontFamily: 'SF Pro Display',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              _initText(trackYourProgress.tr, context),
                              _initText(findInspiration.tr, context),
                              _initText(gainSelfConfidence.tr, context),
                              _initText(strengthenMemory.tr, context),
                              _initText(writeDownYourGoals.tr, context),
                              _initText(trackYourGrowth.tr, context),
                              _initText(improveWritingCommunicationSkills.tr,
                                  context),
                              12.verticalSpace,
                            ],
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(secondIntroRoute);
                        },
                        child: Text(next.tr),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _initText(String text, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
        bottom: 5,
      ),
      child: Text(
        '- ${text}',
        style: TextStyle(
          color: isDark ? Colors.white : blackTextColor,
          fontSize: 20,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
