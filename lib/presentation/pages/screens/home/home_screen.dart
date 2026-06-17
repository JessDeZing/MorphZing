import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:morphzing/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/user/user_info.dart';
import 'package:morphzing/data/repositories/home/home_repositories.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/home/home_controller.dart';
import 'package:morphzing/presentation/pages/screens/home/images_widgets/quote_image.dart';
import 'package:morphzing/presentation/pages/screens/home/images_widgets/uploaded_image.dart';
import 'package:morphzing/presentation/pages/screens/home/images_widgets/zingrart_image.dart';
  // import removed - pending invitations deleted
import 'package:morphzing/presentation/pages/screens/subscription/subscription_controller.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_dialog.dart';
import 'package:morphzing/presentation/pages/screens/subscription_plan.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/theme_settings_widget.dart';
import 'package:morphzing/utils/dynamic_deeplink_service.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static GlobalKey<ScaffoldState> homeKey = GlobalKey();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  final logic = Get.put(HomeController());
  final appController = Get.find<AppController>();
  final controller = Get.put<HomeController>(HomeController());


  int current = 0;
  // final CarouselController _controller = CarouselController();
  final CarouselSliderController _controller = CarouselSliderController();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final result = await logic.checkSubscriptionShownStatus();
      if (!result) {
        SubscriptionDialog.show(context: context);
        logic.setSubscriptionShown();
      }
      DynamicDeepLinkService.instance.initDynamicLinks(context);
      await fetchUserInfo();
      await checkPremiumLightValidity();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    fetchUserInfo();
    checkPremiumLightValidity();
    setState(() {
      current = current == 0 ? 1 : 0;
      _controller.jumpToPage(current);
    });
  }

  Future checkPremiumLightValidity() async {
    try {
      var result = await HomeRepositories.getUserData(
        box.read('token').toString(),
      );

      if (result.statusCode == 200) {
        var resultDecoded = jsonDecode(result.toString());
        var userSubscription = resultDecoded['user_subscription'];
        if (userSubscription != null) {
          if (userSubscription['tariff_type'] == 'premium' &&
              userSubscription['price'] == '0') {
            DateTime endDate = DateTime.parse(userSubscription[
                'end_date']); // Parse the end date string to DateTime
            DateTime currentDate =
                DateTime.now(); // Get the current date and time

            if (endDate.isBefore(currentDate)) {
              // The end date has passed
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text(thanksForGivingUsTry.tr),
                    content: Text(freetrialExpired.tr),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            }
          }
          if (userSubscription['is_premium_lite']) {
            DateTime currentDate = DateTime.now();
            DateTime oneDayBeforeEndDate =
                DateTime.parse(userSubscription['end_date'])
                    .subtract(Duration(days: 1));

            // Compare only the date part by creating DateTime objects with just the year, month, and day
            DateTime currentDateTruncated =
                DateTime(currentDate.year, currentDate.month, currentDate.day);
            DateTime oneDayBeforeEndDateTruncated = DateTime(
                oneDayBeforeEndDate.year,
                oneDayBeforeEndDate.month,
                oneDayBeforeEndDate.day);

            if (currentDateTruncated
                .isAtSameMomentAs(oneDayBeforeEndDateTruncated)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  return CupertinoAlertDialog(
                    title: Text(specialOfferEndingSoon.tr),
                    content: Column(
                      children: [
                        // MorphZing Free
                        GestureDetector(
                          behavior: HitTestBehavior
                              .translucent, // Ensure gestures work
                          onTap: () async {
                            Navigator.of(context).pop();
                            await box.write('planNameArg', 'MorphZing Free');
                            Navigator.pushNamed(context, subscriptionPlanRoute);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? darkBgColor
                                  : const Color.fromARGB(222, 238, 238, 238),
                            ),
                            child: Text(
                              "MorphZing Free",
                              style: GoogleFonts.barlow(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : monthlySubsPlanOptions,
                              ),
                            ),
                          ),
                        ),
                        // MorphZing Basic
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            await box.write('planNameArg', 'MorphZing Basic');
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, subscriptionPlanRoute);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? darkBgColor
                                  : basicSubscriptionBackground,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "MorphZing Basic",
                                  style: GoogleFonts.barlow(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : monthlySubsPlanOptions,
                                  ),
                                ),
                                Text(
                                  '\$3.99/Monthly',
                                  style: GoogleFonts.barlow(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white
                                        : monthlySubsPlanOptions,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow
                                      .visible, // Allow text to wrap
                                ),
                              ],
                            ),
                          ),
                        ),
                        // MorphZing Premium
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            await box.write('planNameArg', 'MorphZing Premium');
                            Navigator.of(context).pop();

                            Navigator.pushNamed(context, subscriptionPlanRoute);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFEDDBF),
                                  Color(0xFFFDFFBE),
                                  Color(0xFFBFFFC3),
                                  Color(0xFFBFFAFE),
                                  Color(0xFFC1BFFE),
                                  Color(0xFFFFBFFB),
                                  Color(0xFFFFBFBF),
                                ],
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "MorphZing Premium",
                                  style: GoogleFonts.barlow(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : monthlySubsPlanOptions,
                                  ),
                                ),
                                Text(
                                  '\$7.99/Monthly',
                                  style: GoogleFonts.barlow(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white
                                        : monthlySubsPlanOptions,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow
                                      .visible, // Allow text to wrap
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future fetchUserInfo() async {
    try {
      var result = await HomeRepositories.getUserData(
        box.read('token').toString(),
      );

      if (result.statusCode == 200) {
        var resultDecoded = jsonDecode(result.toString());
        var userSubscription = resultDecoded['user_subscription'];

        if (userSubscription != null) {
          String? startDateString = userSubscription['start_date'];
          String? endDateString = userSubscription['end_date'];
          _checkTrialPeriod(startDateString ?? "", endDateString ?? "");
        }
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  void _checkTrialPeriod(String? startDateString, String? endDateString) async {
    bool showPopup = await box.read('showFreeTrialPopup') ?? false;
    if ((endDateString ?? "").isEmpty) {
      return;
    }
    DateTime endDateTime = DateTime.parse(endDateString ?? "");
    DateTime currentDateTime = DateTime.now();
    if (currentDateTime.isBefore(endDateTime) && !showPopup) {
      _showTrialPopup();
    }
  }

  void _showTrialPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(freetrialperiodactive.tr),
          content: Text(oneMonthfreeMonthTrial.tr),
          actions: [
            TextButton(
              onPressed: () async {
                await box.write('showFreeTrialPopup', true);
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _pushAndUpdateBanners(String _route) {
    logic.getBannerImage();
    Get.toNamed(_route);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      return Scaffold(
        key: HomeScreen.homeKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: StaticAppBar.homeAppBar(context, home.tr, true, ""),
        drawer: Drawer(
          backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
          child: Column(
            children: [
              const SizedBox(height: 40),
              // const SizedBox(height: 30),
              drawerButton(
                profileRoute,
                'assets/icons/myAccount.svg',
                myAccount.tr,
                opacity: 1,
              ),
              drawerButton(
                templatesScreen,
                'assets/icons/ic_templates.svg',
                templates.tr,
                opacity: 1,
              ),
              drawerButton(
                notificationSettingsRoute,
                'assets/icons/notfication_sv.svg',
                notificationSettings.tr,
                opacity: 1,
              ),
              drawerButton(
                missionStatementRoute,
                'assets/icons/missionStatement.svg',
                missionStatement.tr,
              ),
              drawerButton(
                aboutTheAppRoute,
                'assets/icons/about.svg',
                aboutTheApp.tr,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            const ThemeSettingsWidget(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      isScrollControlled: true,
                    );
                  },
                  child: Container(
                    height: 52,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Icon(
                              Icons.brightness_6,
                              color: Theme.of(context).iconTheme.color ??
                                  blackTextColor,
                              size: 16,
                            ),
                          ),
                          Text(
                            'themeSettings'.tr,
                            style: TextStyle(
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color ??
                                  blackTextColor,
                              fontFamily: 'SF Pro Display',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: logOutButton(
                    '',
                    'assets/icons/logout.svg',
                    logout.tr,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16,
                        top: 30,
                      ),
                      child: SizedBox(
                        height:
                            ((MediaQuery.of(context).size.width - 32) * 9) / 12,
                        width: MediaQuery.of(context).size.width,
                        child: logic.bannerLoading.value
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : CarouselSlider(
                                items: [
                                  ZingArtImage(
                                    imageUrl: logic.homePageImages.value
                                        .zingArtImage?.image,
                                    url: logic
                                        .homePageImages.value.zingArtImage?.url,
                                  ),
                                  QuoteImage(
                                      imageUrl: logic
                                          .homePageImages.value.quoteImage),
                                ],
                                carouselController: _controller,
                                options: CarouselOptions(
                                    viewportFraction: 1,
                                    autoPlay: true,
                                    enlargeCenterPage: false,
                                    aspectRatio: 0.1,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        current = index;
                                      });
                                    }),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          logic.homePageImages.value.zingArtImage?.image,
                          logic.homePageImages.value.quoteImage,
                        ].asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 4.0,
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (isDark ? Colors.white : blueColor)
                                      .withOpacity(
                                          current == entry.key ? 0.9 : 0.4)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _featureRow(
                      context: context,
                      icon: SvgPicture.asset(
                        'assets/icons/todo.svg',
                        colorFilter: ColorFilter.mode(
                          isDark ? Colors.white : blackTextColor,
                          BlendMode.srcIn,
                        ),
                        height: 24,
                        width: 24,
                      ),
                      iconBg: const Color(0xFF3D2B6B),
                      label: 'To-Do',
                      subtitle: "Tackle today's tasks",
                      isDark: isDark,
                      onTap: () => _pushAndUpdateBanners(todoRoute),
                    ),
                    _featureRow(
                      context: context,
                      icon: const Text('📓', style: TextStyle(fontSize: 22)),
                      iconBg: const Color(0xFF6B3A1F),
                      label: 'Journal',
                      subtitle: 'Write about your day',
                      isDark: isDark,
                      onTap: () => _pushAndUpdateBanners(allJournal),
                    ),
                    _featureRow(
                      context: context,
                      icon: const Text('📝', style: TextStyle(fontSize: 22)),
                      iconBg: const Color(0xFF1F5C3A),
                      label: 'Notes',
                      subtitle: 'Quick thoughts & ideas',
                      isDark: isDark,
                      onTap: () => _pushAndUpdateBanners(allNoteRoute),
                    ),
                    _featureRow(
                      context: context,
                      icon: Icon(Icons.palette_outlined, color: Colors.white, size: 24),
                      iconBg: const Color(0xFF5C1F4A),
                      label: 'Calm Corner',
                      subtitle: 'Breathe. Color. Reset.',
                      isDark: isDark,
                      onTap: () => Get.toNamed(calmCornerRoute),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

            ],
          ),
        ),
      );
    });
  }

  Widget _featureRow({
    required BuildContext context,
    required Widget icon,
    required Color iconBg,
    required String label,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141414) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF222222) : const Color(0xFFE0E0E0),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: icon),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isDark ? Colors.white : blackTextColor,
                      fontFamily: 'SF Pro Display',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
                      fontFamily: 'SF Pro Display',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? const Color(0xFF444444) : const Color(0xFFBBBBBB),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  drawerButton(String route, String svg, String title, {double opacity = 1.0}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5,
      ),
      child: Container(
        // Wrap with Container
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // color: (title == pendingInvitations.tr && myArray.isNotEmpty) ? blueColor : Colors.transparent, // testing wid local
          color: Colors.transparent,
        ),
        child: Opacity(
          opacity: opacity,
          child: GestureDetector(
            onTap: () {
              if (opacity == 1) {
                Navigator.pushNamed(context, route);
              }
            },
            child: Container(
              height: 52,
              width: double.infinity,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: SvgPicture.asset(
                        svg,
                        color: isDark ? Colors.white : blackTextColor,
                        width: 16,
                        height: title == 'Pending invitations'
                            ? 14
                            : title == 'My Account'
                                ? 18 // Specify the height for "My Account"
                                : 16,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        overflow:
                            TextOverflow.visible, // Ensure the text can wrap
                        maxLines: 2,
                        title,
                        style: TextStyle(
                          color: isDark ? Colors.white : blackTextColor,
                          fontFamily: 'SF Pro Display',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // drawerButton(String route, String svg, String title, {double opacity = 1.0}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: 10.0,
  //       vertical: 5,
  //     ),
  //     child: Container(
  //       color: Colors.amber,
  //       child: GestureDetector(
  //         onTap: () {
  //           if (opacity == 1) {
  //             Navigator.pushNamed(context, route);
  //           }
  //         },
  //         child: Opacity(
  //           opacity: opacity,
  //           child: Container(
  //             height: 52,
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(5),
  //               color: greyButton,
  //             ),
  //             child: Center(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 14),
  //                     child: SvgPicture.asset(
  //                       svg,
  //                       color: blackTextColor,
  //                       width: 16,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                   Text(
  //                     title,
  //                     style: const TextStyle(
  //                       color: blackTextColor,
  //                       fontFamily: 'SF Pro Display',
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  logOutButton(
    String route,
    String svg,
    String title,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: const Text('Are you sure you want to log out?'),
                  actions: <Widget>[
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context); //close Dialog
                      },
                      child: const Text('No'),
                    ),
                    CupertinoButton(
                      onPressed: () async {
                        box.remove("token");
                        await Get.find<SubscriptionController>().logOut();
                        Get.offAllNamed(loginRoute);
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              });
        },
        child: Container(
          height: 52,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isDark ? darkBorderColor : logOutButtonColor,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: SvgPicture.asset(
                    svg,
                    color: Colors.red,
                    width: 16,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'SF Pro Display',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
