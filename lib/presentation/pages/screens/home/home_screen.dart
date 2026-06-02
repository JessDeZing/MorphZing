import 'dart:convert';
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
import 'package:morphzing/presentation/pages/screens/pending_invitations/pending_invitations_controller.dart';
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
  final controller =
      Get.put<PendingInvitationsController>(PendingInvitationsController());

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
    // Called when navigating back to HomeScreen
    fetchUserInfo();
    checkPremiumLightValidity();
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
                pendingInvitationsRoute,
                'assets/icons/pendingInvitations.svg',
                pendingInvitations.tr,
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
                            ((MediaQuery.of(context).size.width - 32) * 9) / 16,
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
                                  Obx(() {
                                    return UploadedImage(
                                      uploadedImage:
                                          logic.homePageImages.value.phoneImage,
                                      id: logic.homePageImages.value.id,
                                    );
                                  }),
                                ],
                                carouselController: _controller,
                                options: CarouselOptions(
                                    viewportFraction: 1,
                                    autoPlay: false,
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
                          logic.homePageImages.value.phoneImage,
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
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pushAndUpdateBanners(todoRoute),
                            child: SizedBox(
                                height: Platform.isAndroid ? 140 : 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/icons/todo.svg'),
                                        )),
                                    const SizedBox(height: 6),
                                    Text(
                                      'To-Do',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : blackTextColor,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pushAndUpdateBanners(allJournal),
                            child: SizedBox(
                              height: Platform.isAndroid ? 140 : 130,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Image(
                                        image: AssetImage(
                                            'assets/icons/Journal.png'),
                                      )),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    journal.tr,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : blackTextColor,
                                      fontFamily: 'SF Pro Display',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            // _pushAndUpdateBanners(allJournal)
                            onTap: () => _pushAndUpdateBanners(webViewRoute),
                            // async {
                            //   launchUrl(
                            //     Uri.parse('https://zingphotography.com'),
                            //     mode: LaunchMode.externalApplication,
                            //   );
                            // },
                            child: SizedBox(
                                height: Platform.isAndroid ? 140 : 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/icons/ZingPhotography.png'),
                                          color: isDark
                                              ? Colors.white
                                              : blackTextColor,
                                        )),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      zingPhotography.tr,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : blackTextColor,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pushAndUpdateBanners(allNoteRoute),
                            child: SizedBox(
                                height: Platform.isAndroid ? 140 : 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/icons/notes.png'),
                                        )),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      notes.tr,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : blackTextColor,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        // Expanded(
                        //   child: GestureDetector(
                        //     onTap: () =>
                        //         _pushAndUpdateBanners(worldChangersRoute),
                        //     child: SizedBox(
                        //         height: 130,
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             SizedBox(
                        //                 height: 100,
                        //                 width: 100,
                        //                 child: Image(
                        //                   image: AssetImage(
                        //                       'assets/icons/wordl_changer.png'),
                        //                 )),
                        //             SizedBox(
                        //               height: 6,
                        //             ),
                        //             Text(
                        //               worldChangers.tr,
                        //               style: TextStyle(
                        //                 color: isDark
                        //                     ? Colors.white
                        //                     : blackTextColor,
                        //                 fontFamily: 'SF Pro Display',
                        //                 fontSize: 14,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             )
                        //           ],
                        //         )),
                        //   ),
                        // ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                              height: Platform.isAndroid ? 140 : 130,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Image(
                                        image:
                                            AssetImage('assets/icons/Chat.png'),
                                      )),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    chat.tr,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : blackTextColor,
                                      fontFamily: 'SF Pro Display',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 37,
                  right: 37,
                  bottom: Platform.isAndroid ? 18 : 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        launchUrlString(
                          'https://www.facebook.com/',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              SvgPicture.asset('assets/icons/ic_facebook.svg')),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrlString(
                          'https://www.instagram.com/',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset(
                              'assets/icons/ic_instagram.svg')),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrlString(
                          'https://twitter.com/',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset(
                            'assets/icons/twitterx.svg',
                            color: isDark ? Colors.white : blackTextColor,
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrlString(
                          'https://www.youtube.com/',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                          height: 33,
                          width: 33,
                          child: SvgPicture.asset('assets/icons/youtube.svg')),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrlString(
                          'https://www.tiktok.com/',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              SvgPicture.asset('assets/icons/ic_tiktok.svg')),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrlString(
                          'https://www.snapchat.com/',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              SvgPicture.asset('assets/icons/ic_snapchat.svg')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
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
          color: (title == pendingInvitations.tr &&
                  (controller.work.isNotEmpty ||
                      controller.finances.isNotEmpty ||
                      controller.travel.isNotEmpty ||
                      controller.selfCare.isNotEmpty ||
                      controller.specialOccasions.isNotEmpty ||
                      controller.meetUp.isNotEmpty))
              ? blueColor
              : Colors.transparent, // Set your desired background color here
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
