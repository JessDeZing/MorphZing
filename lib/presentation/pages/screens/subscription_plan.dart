import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/api/subscriptionPlan_repositories.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:morphzing/data/repositories/home/home_repositories.dart';
import 'package:morphzing/data/repositories/user/user_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/login/login_controller.dart';
import 'package:morphzing/presentation/pages/screens/home/home_controller.dart';
import 'package:morphzing/presentation/pages/screens/subscription/subscription_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  // Variable to hold the selected value
  final appController = Get.find<AppController>();
  final UserRepository _userRepository = getIt<UserRepository>();

  // final firstProduct = Get.find<SubscriptionController>().products.first;
  // final lastProduct = Get.find<SubscriptionController>().products.last;
  // Get the first product
  final firstProduct = Get.find<SubscriptionController>().products[0];

// Get the second product
  final secondProduct = Get.find<SubscriptionController>().products[1];

// Get the third product
  final thirdProduct = Get.find<SubscriptionController>().products[2];
  final _userRepo = getIt<UserRepository>();
  final LoginController controller = LoginController();

  String responseText = "No Response Yet";

  final box = GetStorage();

  String? _selectedValue;
  String? _selectedprice;

  // Variable to toggle between limited and full list
  bool _showAll = false;
  bool _showAllBasic = false;
  bool _showAllPremium = false;
  bool isCurrentPlan = false;
  bool isFreeTrialSubscribed = false;
  bool isPremiumLite = false;

  Future<void> makePostRequest() async {
    final token = box.read('token').toString();
    LoadingOverlay.show(context);
    try {
      // Make the POST request using user input from the screen
      final response =
          await SubscriptionRepositories.makePostRequest(token: token);
      debugPrint('response in subs PLAN $response');
      _userRepository.getUserInfo();
      Get.find<HomeController>().fetchUserInfo();
      setState(() {
        isFreeTrialSubscribed = true;
      });

      LoadingOverlay.hide();
    } catch (error) {
      setState(() {
        responseText = "Failed: $error";
      });
    }
  }

  // free package request

  Future<void> freePackageRequest() async {
    final token = box.read('token').toString();
    LoadingOverlay.show(context);
    try {
      final response =
          await SubscriptionRepositories.freePackageRequest(token: token);
      debugPrint('response freePackageRequest $response');
      //  await _userRepository.getUserInfo();
      Get.find<HomeController>().fetchUserInfo();

      LoadingOverlay.hide();
    } catch (error) {
      setState(() {
        responseText = "Failed: $error";
      });
    }
  }

  // List of subscription details
  final List<Map<String, String>> _freeSubscriptionDetails = [
    {"text": easycheckoff.tr},
    {"text": setandtrackyourgoals.tr},
    {"text": seealltasksweeklycalendar.tr},
    {"text": reminderstocompletegoal.tr},
    {"text": agendawithcolorcodedcalendar.tr},
    {"text": selfcarecalendartips.tr},
    {"text": smartInvitesTextEventInvitationsFromYourCalendar.tr},
    {"text": textToConfirmOrDeclineEvents.tr},
    {"text": remindersViaText.tr},
    {"text": addColorCodedEventsFromCalendarView.tr},
    {"text": shortcutInstantToDoAndEventCalendar.tr},
    {"text": easyScrollMyLifeJourneyJournalEntries.tr},
    {"text": trackYourJourneyWithTotalEntriesCount.tr},
    {"text": unleashYourCompetitiveStreak.tr},
    {"text": trackYourWeeksOfJournalingProgress.tr},
    {"text": divideEachJournalEntryIntoSections.tr},
    {"text": editYourJournalEntriesWithEase.tr},
    {"text": automaticDateTime.tr},
    {"text": titleYourJournalEntries.tr},
    {"text": fiveJournalingSpace.tr},
    {"text": monthlyJournalViewTrackYourJournalingDaysAtAGlance.tr},
    {"text": monthlyJournalViewWithSummaryAtAGlance.tr},
    {"text": pickYourProfilePictureFromOurLibrary.tr},
    {"text": englishSpanishFeatureSeamlessLanguageSwitching.tr},
    {"text": zingPhotographyElevateYourSpaceWithStyleAndGrace.tr},
    {"text": joinOurPhilanthropistMovementAndMakeADifferenceTogether.tr},
    {"text": oneStopShopForYourSocialMediaConnection.tr}
  ];

  // List of basicSubscription details
  final List<Map<String, String>> _basicSubscriptionDetails = [
    {"text": easycheckoff.tr},
    {"text": setandtrackyourgoals.tr},
    {"text": seealltasksweeklycalendar.tr},
    {"text": reminderstocompletegoal.tr},
    {"text": agendawithcolorcodedcalendar.tr},
    {"text": selfcarecalendartips.tr},
    {"text": smartInvitesTextEventInvitationsFromYourCalendar.tr},
    {"text": textToConfirmOrDeclineEvents.tr},
    {"text": remindersViaText.tr},
    {"text": easytousecolorcodedcalendar.tr},
    {"text": addColorCodedEventsFromCalendarView.tr},
    {"text": shortcutInstantToDoAndEventCalendar.tr},
    {"text": easyScrollMyLifeJourneyJournalEntries.tr},
    {"text": trackYourJourneyWithTotalEntriesCount.tr},
    {"text": unleashYourCompetitiveStreak.tr},
    {"text": trackYourWeeksOfJournalingProgress.tr},
    {"text": divideEachJournalEntryIntoSections.tr},
    {"text": editYourJournalEntriesWithEase.tr},
    {"text": automaticDateTime.tr},
    {"text": titleYourJournalEntries.tr},
    {"text": twentyfiveJournalingSpace.tr},
    {"text": monthlyJournalViewTrackYourJournalingDaysAtAGlance.tr},
    {"text": monthlyJournalViewWithSummaryAtAGlance.tr},
    {"text": customizeyourprofilepicturewithease.tr},
    {"text": pickYourProfilePictureFromOurLibrary.tr},
    {"text": englishSpanishFeatureSeamlessLanguageSwitching.tr},
    {"text": zingPhotographyElevateYourSpaceWithStyleAndGrace.tr},
    {"text": joinOurPhilanthropistMovementAndMakeADifferenceTogether.tr},
    {"text": oneStopShopForYourSocialMediaConnection.tr}
  ];

  // List of basicSubscription details
  final List<Map<String, String>> _premiumSubscriptionDetails = [
    {"text": easycheckoff.tr},
    {"text": setandtrackyourgoals.tr},
    {"text": seealltasksweeklycalendar.tr},
    {"text": reminderstocompletegoal.tr},
    {"text": seealltasksinmonthlycalendar.tr},
    {"text": abiitytocheckcomplete.tr},
    {"text": seealltasksinyouryearlycalendar.tr},
    {"text": agendawithcolorcodedcalendar.tr},
    {"text": travelagendawithphotouploads.tr},
    {"text": selfcarecalendartips.tr},
    {"text": smartInvitesTextEventInvitationsFromYourCalendar.tr},
    {"text": textToConfirmOrDeclineEvents.tr},
    {"text": remindersViaText.tr},
    {"text": easytousecolorcodedcalendar.tr},
    {"text": addColorCodedEventsFromCalendarView.tr},
    {"text": shortcutInstantToDoAndEventCalendar.tr},
    {"text": easyScrollMyLifeJourneyJournalEntries.tr},
    {"text": trackYourJourneyWithTotalEntriesCount.tr},
    {"text": unleashYourCompetitiveStreak.tr},
    {"text": trackYourWeeksOfJournalingProgress.tr},
    {"text": divideEachJournalEntryIntoSections.tr},
    {"text": editYourJournalEntriesWithEase.tr},
    {"text": automaticDateTime.tr},
    {"text": titleYourJournalEntries.tr},
    {"text": unlimitedJournalingSpace.tr},
    {"text": recordyourjournalentrieswithyourvoice.tr},
    {"text": monthlyJournalViewTrackYourJournalingDaysAtAGlance.tr},
    {"text": monthlyJournalViewWithSummaryAtAGlance.tr},
    {"text": organizedetailswitheasynotecreation.tr},
    {"text": organizenotesintocustomfolders.tr},
    {"text": customizeyourprofilepicturewithease.tr},
    {"text": pickYourProfilePictureFromOurLibrary.tr},
    {"text": englishSpanishFeatureSeamlessLanguageSwitching.tr},
    {"text": zingPhotographyElevateYourSpaceWithStyleAndGrace.tr},
    {"text": joinOurPhilanthropistMovementAndMakeADifferenceTogether.tr},
    {"text": oneStopShopForYourSocialMediaConnection.tr},
    {"text": rsvpmadeasy.tr}
  ];

  @override
  void initState() {
    super.initState();
    _initializeSelectedValue();
    fetchUserInfo();
  }

  String checkIfExpired(String endDateStr) {
    final DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ");
    final DateTime endDate = dateFormat.parse(endDateStr);
    final DateTime now = DateTime.now();
    if (endDate.isBefore(now)) {
      return 'Expired';
    } else {
      return 'Valid';
    }
  }

  void fetchUserInfo() async {
    try {
      final token = box.read('token')?.toString();

      if (token == null || token.isEmpty) {
        print("Token is null or empty");
        return;
      }

      // Fetch user data from API
      var response = await HomeRepositories.getUserData(token);
      if (response.data != null) {
        var result = response.data;
        print('user ka resultresultresultresultresultresult===== $result');
        if (result['user_subscription']['is_premium_lite']) {
          setState(() {
            isPremiumLite = true;
          });
        }

        bool usedFreeTrial = result['used_free_trial'] ?? false;
        print('user ka usedFreeTrial $usedFreeTrial');

        if (usedFreeTrial == true) {
          if (result['user_subscription']['end_date'] != null) {
            final String label =
                checkIfExpired(result['user_subscription']['end_date']);
            print(' user ka label $label');
            if (label == 'Valid') {
              print("Subscription is still valid.");
              setState(() {
                isFreeTrialSubscribed = true;
              });
              LoadingOverlay.hide();
            } else {
              print("hello worlldddddd");
              expire();
            }
          }
        }
      }
    } on Object catch (e) {
      LoadingOverlay.hide();

      print("Error: $e");
    }
  }

  void expire() async {
    print("Line 275");
    try {
      final token = box.read('token')?.toString();

      if (token == null || token.isEmpty) {
        print("Token is null or empty");
        return;
      }

      // Fetch user data from API
      var response = await HomeRepositories.expireFreeSubscription(token);
      _userRepository.getUserInfo();
      print("expire-result $response");
    } on Object catch (e) {
      print("Error: $e");
    }
  }

  void fetchUpdatedUserInfo() async {
    LoadingOverlay.show(context);
    try {
      final token = box.read('token')?.toString();

      if (token == null || token.isEmpty) {
        print("Token is null or empty");
        return;
      }

      var response = await HomeRepositories.getUserData(token);

      if (response.data != null) {
        var result = response.data;
        if ((appController.user?.paymentStatus == SubscriptionType.premium ||
                appController.user?.paymentStatus ==
                    SubscriptionType.familyShare) &&
            (result['user_subscription']['is_premium_lite'] == false)) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Container(
                height: 360,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF0099FF),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        premiumLiteTextHeader.tr,
                        style: GoogleFonts.barlow(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : monthlySubsPlanOptions,
                        ),
                      ),
                      Text(
                        keepItAll.tr,
                        style: GoogleFonts.barlow(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : monthlySubsPlanOptions,
                        ),
                      ),
                      Text(
                        threeNineNineNextMonth.tr,
                        style: GoogleFonts.barlow(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : monthlySubsPlanOptions,
                        ),
                      ),
                      // Text(
                      //   '\$3.99/Monthly',
                      //   style: GoogleFonts.barlow(
                      //     fontSize: 26,
                      //     fontWeight: FontWeight.w600,
                      //     color: monthlySubsPlanOptions,
                      //   ),
                      //   softWrap: true,
                      //   overflow: TextOverflow.visible, // Allow text to wrap
                      // ),
                      SizedBox(
                        height: 35,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          LoadingOverlay.show(context);
                          await Get.find<SubscriptionController>()
                              .makePurchase(secondProduct);
                          LoadingOverlay.hide();

                          Navigator.pop(context); // This closes the modal
                          Navigator.of(context).pop();
                        },
                        child: Text(subscribeNow.tr),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          LoadingOverlay.show(context);
                          await Get.find<SubscriptionController>()
                              .makePurchase(firstProduct);
                          Get.find<HomeController>().fetchUserInfo();
                          LoadingOverlay.hide();

                          Navigator.pop(context); // This closes the modal
                          Navigator.of(context).pop();
                        },
                        child: Text(continuewithmorphzingbasic.tr),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        enjoyTheChange.tr,
                        style: GoogleFonts.barlow(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : monthlySubsPlanOptions,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          setState(() {
            _selectedValue = 'MorphZing Basic';
            isCurrentPlan = false;
          });
        }
        print(' user ka result  for newww $result');
        LoadingOverlay.hide();
      }
    } on Object catch (e) {
      print("Error: $e");
    }
  }

  void handleFreePackage() {
    if (appController.user?.paymentStatus == SubscriptionType.basic) {
      setState(() {
        _selectedValue = 'MorphZing Free';
      });
    } else {
      requestFreePackage();
    }
  }

  // check info for going with free
  void requestFreePackage() async {
    LoadingOverlay.show(context);
    try {
      final token = box.read('token')?.toString();

      if (token == null || token.isEmpty) {
        print("Token is null or empty");
        return;
      }

      var response = await HomeRepositories.getUserData(token);

      if (response.data != null) {
        var result = response.data;
        if ((appController.user?.paymentStatus == SubscriptionType.premium ||
            appController.user?.paymentStatus ==
                SubscriptionType.familyShare)) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Container(
                height: 300,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xFF0099FF),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        premiumLiteText.tr,
                        style: GoogleFonts.barlow(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : monthlySubsPlanOptions,
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          LoadingOverlay.show(context);
                          await Get.find<SubscriptionController>()
                              .makePurchase(secondProduct);
                          Get.find<HomeController>().fetchUserInfo();
                          LoadingOverlay.hide();

                          Navigator.pop(context); // This closes the modal
                          Navigator.of(context).pop();
                        },
                        child: Text(subscribeNow.tr),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          LoadingOverlay.show(context);
                          await freePackageRequest();
                          LoadingOverlay.hide();

                          Navigator.pop(context); // This closes the modal
                          Navigator.of(context).pop();
                        },
                        child: Text(continuewithmorphzingfree.tr),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          setState(() {
            _selectedValue = 'MorphZing Free';
            isCurrentPlan = false;
          });
        }

        // if ((appController.user?.paymentStatus == SubscriptionType.premium ||
        //         appController.user?.paymentStatus ==
        //             SubscriptionType.familyShare) &&
        //     (result['user_subscription']['is_premium_lite'] == false)) {
        //   showModalBottomSheet(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return Container(
        //         height: 300,
        //         padding: EdgeInsets.all(16.0),
        //         child: Center(
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text(
        //                 premiumLiteText.tr,
        //                 style: GoogleFonts.barlow(
        //                   fontSize: 16,
        //                   fontWeight: FontWeight.w600,
        //                   color: monthlySubsPlanOptions,
        //                 ),
        //               ),
        //               // Text(
        //               //   '\$3.99/Monthly',
        //               //   style: GoogleFonts.barlow(
        //               //     fontSize: 26,
        //               //     fontWeight: FontWeight.w600,
        //               //     color: monthlySubsPlanOptions,
        //               //   ),
        //               //   softWrap: true,
        //               //   overflow: TextOverflow.visible, // Allow text to wrap
        //               // ),
        //               SizedBox(
        //                 height: 35,
        //               ),
        //               ElevatedButton(
        //                 onPressed: () async {
        //                   LoadingOverlay.show(context);
        //                   await Get.find<SubscriptionController>()
        //                       .makePurchase(secondProduct);
        //                   LoadingOverlay.hide();

        //                   Navigator.pop(context); // This closes the modal
        //                   Navigator.of(context).pop();
        //                 },
        //                 child: Text(subscribeNow.tr),
        //               ),
        //               SizedBox(
        //                 height: 15,
        //               ),
        //               ElevatedButton(
        //                 onPressed: () async {
        //                   LoadingOverlay.show(context);
        //                   await Get.find<SubscriptionController>()
        //                       .makePurchase(firstProduct);
        //                   LoadingOverlay.hide();

        //                   Navigator.pop(context); // This closes the modal
        //                   Navigator.of(context).pop();
        //                 },
        //                 child: Text(continuewithmorphzingbasic.tr),
        //               )
        //             ],
        //           ),
        //         ),
        //       );
        //     },
        //   );
        // } else {
        //   setState(() {
        //     _selectedValue = 'MorphZing Basic';
        //     isCurrentPlan = false;
        //   });
        // }
        LoadingOverlay.hide();
      }
    } on Object catch (e) {
      print("Error: $e");
    }
  }

  void _initializeSelectedValue() {
    final paymentStatus = appController.user?.paymentStatus;
    if (paymentStatus == SubscriptionType.free) {
      isCurrentPlan = true;
      _selectedValue = 'MorphZing Free';
      _selectedprice = '0';
    } else if (paymentStatus == SubscriptionType.basic) {
      _selectedValue = 'MorphZing Basic';
      isCurrentPlan = false;
      _selectedprice = '${firstProduct.storeProduct.priceString}';
    } else if (paymentStatus == SubscriptionType.premium ||
        paymentStatus == SubscriptionType.familyShare) {
      _selectedValue = 'MorphZing Premium';
      isCurrentPlan = false;
      _selectedprice = '${firstProduct.storeProduct.priceString}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final int freeItemsToShow = _showAll ? _freeSubscriptionDetails.length : 5;
    final int basicItemsToShow =
        _showAllBasic ? _basicSubscriptionDetails.length : 5;
    final int premiumItemsToShow =
        _showAllPremium ? _premiumSubscriptionDetails.length : 5;

    // // Access the argument in build method
    // final planNameArg = box.read('planNameArg').toString();
    // if (planNameArg.isNotEmpty) {
    //   setState(() {
    //     _selectedValue = planNameArg;
    //   });
    // }

    return Scaffold(
      appBar:
          StaticAppBar.subHomeAppBar(context, subscribeToPlan.tr, false, ''),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => handleFreePackage(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: _selectedValue == 'MorphZing Free'
                            ? Border.all(
                                color: Colors.grey, // Color of the border
                                width: 2,
                              )
                            : null,
                        color: const Color.fromARGB(222, 238, 238, 238),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'MorphZing Free',
                                style: GoogleFonts.barlow(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isDark ? Colors.white : subsPlanHeading,
                                ),
                              ),
                              Radio<String>(
                                value: 'MorphZing Free',
                                groupValue: _selectedValue,
                                onChanged: (value) {
                                  handleFreePackage();
                                },
                                activeColor: Color(0xFF0099FF),
                              ),
                            ],
                          ),
                          Center(
                            child: Image(
                              width: 100,
                              fit: BoxFit.contain,
                              image: AssetImage(
                                "assets/icons/freeSubs.png",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            style: GoogleFonts.barlow(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : subsPlanHeading,
                            ),
                            'Subscription includes:',
                            softWrap: true,
                            overflow:
                                TextOverflow.visible, // Allow text to wrap
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // Use ListView.builder to show checkmarks and text
                          ListView.builder(
                            physics:
                                NeverScrollableScrollPhysics(), // Disable scrolling
                            shrinkWrap: true,
                            itemCount: freeItemsToShow,
                            itemBuilder: (context, index) {
                              final detail = _freeSubscriptionDetails[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0), // Add bottom padding here
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/checkmark.svg',
                                      width: 16,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        style: GoogleFonts.barlow(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? Colors.white
                                              : subsPlanHeading,
                                        ),
                                        detail['text']!,
                                        softWrap: true,
                                        overflow: TextOverflow
                                            .visible, // Allow text to wrap
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_freeSubscriptionDetails.length > 5)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showAll = !_showAll;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/showIcon.svg',
                                    width: 16,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 8),
                                  Text(_showAll ? 'Show Less' : 'Show More',
                                      style: GoogleFonts.barlow(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: selectedFreeSubsColor,
                                      )),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // if (_selectedValue == 'MorphZing Basic' ||
                  //     _selectedValue == 'MorphZing Premium')
                  GestureDetector(
                    onTap: () {
                      fetchUpdatedUserInfo();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: _selectedValue == 'MorphZing Basic'
                            ? Border.all(
                                color:
                                    basicSubscriptionBorder, // Color of the border
                                width: 3,
                              )
                            : null,
                        color: basicSubscriptionBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align children to the start (left)
                                children: [
                                  Text(
                                    'MorphZing Basic',
                                    style: GoogleFonts.barlow(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : monthlySubsPlanOptions,
                                    ),
                                  ),
                                  Text(
                                    '\$3.99/Monthly',
                                    style: GoogleFonts.barlow(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
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
                              Radio<String>(
                                value: 'MorphZing Basic',
                                groupValue: _selectedValue,
                                onChanged: (value) {
                                  fetchUpdatedUserInfo();
                                  // setState(() {
                                  //   _selectedValue = value;
                                  // });
                                },
                                activeColor: Color(0xFF0099FF),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Image(
                            width: 100,
                            fit: BoxFit.contain,
                            image: AssetImage(
                              "assets/icons/basicSubs.png",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            style: GoogleFonts.barlow(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : monthlySubsPlanOptions,
                            ),
                            'Subscription includes:',
                            softWrap: true,
                            overflow:
                                TextOverflow.visible, // Allow text to wrap
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // Use ListView.builder to show checkmarks and text
                          ListView.builder(
                            physics:
                                NeverScrollableScrollPhysics(), // Disable scrolling
                            shrinkWrap: true,
                            itemCount: basicItemsToShow,
                            itemBuilder: (context, index) {
                              final detail = _basicSubscriptionDetails[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0), // Add bottom padding here
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/checkmarkBasic.svg',
                                      width: 16,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        style: GoogleFonts.barlow(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? Colors.white
                                              : monthlySubsPlanOptions,
                                        ),
                                        detail['text']!,
                                        softWrap: true,
                                        overflow: TextOverflow
                                            .visible, // Allow text to wrap
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_basicSubscriptionDetails.length > 5)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showAllBasic = !_showAllBasic;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/monthlyMoreIcon.svg',
                                    width: 16,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                      _showAllBasic ? 'Show Less' : 'Show More',
                                      style: GoogleFonts.barlow(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: isDark
                                            ? Colors.white
                                            : monthlySubsPlanOptions,
                                      )),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Stack(children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedValue = 'MorphZing Premium';
                          isCurrentPlan = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: _selectedValue == 'MorphZing Premium'
                              ? Border.all(
                                  color:
                                      Color(0xEACE7B00), // Color of the border
                                  width: 2,
                                )
                              : null,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFEDDBF),
                              Color(0xFFFDFFBE),
                              Color(0xFFBFFFC3),
                              Color(0xFFBFFAFE),
                              Color(0xFFC1BFFE),
                              Color(0xFFFFBFFB),
                              Color(0xFFFFBFBF),
                              // #FEDDBF
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isPremiumLite
                                          ? 'MorphZing Premium Lite'
                                          : 'MorphZing Premium',
                                      style: GoogleFonts.barlow(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : subsPlanHeading,
                                      ),
                                    ),
                                    Text(
                                      isPremiumLite
                                          ? '\$3.99/Monthly'
                                          : '\$7.99/Monthly',
                                      style: GoogleFonts.barlow(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : subsPlanHeading,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ),
                                Radio<String>(
                                  value: 'MorphZing Premium',
                                  groupValue: _selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedValue = value;
                                    });
                                  },
                                  activeColor: Color(0xFF0099FF),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Image(
                              width: 100,
                              fit: BoxFit.contain,
                              image: AssetImage(
                                "assets/icons/monthlySubs.png",
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              style: GoogleFonts.barlow(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : subsPlanHeading,
                              ),
                              'Subscription includes:',
                              softWrap: true,
                              overflow:
                                  TextOverflow.visible, // Allow text to wrap
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // Use ListView.builder to show checkmarks and text
                            ListView.builder(
                              physics:
                                  NeverScrollableScrollPhysics(), // Disable scrolling
                              shrinkWrap: true,
                              itemCount: premiumItemsToShow,
                              itemBuilder: (context, index) {
                                final detail =
                                    _premiumSubscriptionDetails[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0), // Add bottom padding here
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/checkMarkPremium.svg',
                                        width: 16,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          style: GoogleFonts.barlow(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.white
                                                : subsPlanHeading,
                                          ),
                                          detail['text']!,
                                          softWrap: true,
                                          overflow: TextOverflow
                                              .visible, // Allow text to wrap
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_premiumSubscriptionDetails.length > 5)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showAllPremium = !_showAllPremium;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/showIconBlack.svg',
                                      width: 16,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                        _showAllPremium
                                            ? 'Show Less'
                                            : 'Show More',
                                        style: GoogleFonts.barlow(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: isDark
                                              ? Colors.white
                                              : subsPlanHeading,
                                        )),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isFreeTrialSubscribed == true)
                      Positioned(
                        top: 80, // Position from the top
                        right: 16, // Position from the left
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              color: isDark ? darkBgColor : Colors.black),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Free Trial Subscribed',
                                style: GoogleFonts.barlow(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black,
                                )),
                          ),
                        ),
                      ),
                  ]),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: PrimaryButton(
                      buttonColor:
                          (_selectedValue == 'MorphZing Free' || isCurrentPlan)
                              ? blueColor
                              : isDark
                                  ? darkGreyButton
                                  : Colors.black,
                      onPressed: () async {
                        if (_selectedValue == 'MorphZing Free') {
                          freePackageRequest();
                          Navigator.pop(context);
                        } else if (_selectedValue == 'MorphZing Basic') {
                          LoadingOverlay.show(context);
                          await Get.find<SubscriptionController>()
                              .makePurchase(firstProduct);
                          Get.find<HomeController>().fetchUserInfo();
                          LoadingOverlay.hide();
                          Navigator.of(context).pop();
                        } else if (_selectedValue == 'MorphZing Premium') {
                          LoadingOverlay.show(context);
                          await Get.find<SubscriptionController>()
                              .makePurchase(thirdProduct);
                          Get.find<HomeController>().fetchUserInfo();
                          LoadingOverlay.hide();
                          Navigator.of(context).pop();
                        }
                      },
                      buttonText:
                          (!isCurrentPlan && _selectedValue == 'MorphZing Free')
                              ? "Free"
                              : (isCurrentPlan &&
                                      _selectedValue == 'MorphZing Free')
                                  ? currentPlan.tr
                                  : subscribeNow.tr,
                    ),
                  ),
                  SizedBox(height: 15)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
