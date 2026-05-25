import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/logic/controllers/profile_menu/about_the_app_controller.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_basic.dart';
import 'package:morphzing/presentation/pages/screens/subscription/subscription_controller.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_free.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/page_indicator.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_premium.dart';
import 'package:morphzing/utils/style/colors.dart';

class SubscriptionBottomSheet extends StatefulWidget {
  const SubscriptionBottomSheet({Key? key}) : super(key: key);

  static Future show({required BuildContext context}) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SubscriptionBottomSheet(),
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height -
              (MediaQuery.of(context).viewPadding.top + 8)),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ));

  @override
  State<SubscriptionBottomSheet> createState() =>
      _SubscriptionBottomSheetState();
}

class _SubscriptionBottomSheetState extends State<SubscriptionBottomSheet> {
  final PageController pageController = PageController(initialPage: 1);
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(1);
  final controller = Get.find<SubscriptionController>();
  final appController = Get.find<AppController>();
  final logic = Get.put(AboutTheAppController());

  @override
  void dispose() {
    pageController.dispose();
    currentPageNotifier.dispose();
    logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? darkBgColor : whiteColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: isDark ? darkBgColor : bgColor,
                  ),
                  child: Icon(
                    CupertinoIcons.clear,
                    color: isDark ? Colors.white : hintTextColor,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          PageIndicator(
            currentPageNotifier: currentPageNotifier,
            itemCount: 3,
          ),
          Obx(() {
            return Expanded(
              child: controller.pageLoading.value
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : controller.products.isEmpty
                      ? Center(child: Text(noSubProducts.tr))
                      : PageView(
                          controller: pageController,
                          onPageChanged: (index) {
                            currentPageNotifier.value = index;
                          },
                          children: [
                            SubscriptionFree(
                                isCurrentPlan:
                                    appController.user?.paymentStatus ==
                                        SubscriptionType.free),
                            SubscriptionBasic(
                                isCurrentPlan:
                                    appController.user?.paymentStatus ==
                                        SubscriptionType.basic),
                            SubscriptionPremium(
                              isCurrentPlan:
                                  appController.user?.paymentStatus ==
                                          SubscriptionType.premium ||
                                      appController.user?.paymentStatus ==
                                          SubscriptionType.familyShare,
                            ),
                          ],
                        ),
            );
          }),
        ],
      ),
    );
  }
}
