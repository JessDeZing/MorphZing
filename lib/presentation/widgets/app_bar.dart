import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';

import 'package:morphzing/presentation/pages/screens/profile/profile_screen.dart';
import 'package:morphzing/presentation/pages/screens/search/search_screen.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_dialog.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

import '../../utils/style/colors.dart';
import '../pages/screens/home/home_screen.dart';

class StaticAppBar {
  static AppBar customAppBar(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color:
              Theme.of(context).appBarTheme.iconTheme?.color ?? blackTextColor,
        ),
      ),
      backgroundColor:
          isDark ? Theme.of(context).appBarTheme.backgroundColor : bgColor,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: isDark
              ? Theme.of(context).appBarTheme.titleTextStyle?.color
              : blackTextColor,
          fontFamily: 'SF Pro Display',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static AppBar homeAppBar(
      BuildContext context, String title, bool isHome, String image,
      {Color? color, VoidCallback? onPressedBack}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logic = Get.find<AppController>();
    return AppBar(
      elevation: 5,
      shadowColor: isDark
          ? Theme.of(context).shadowColor.withOpacity(0.26)
          : Colors.black26,
      leading: (isHome)
          ? IconButton(
              onPressed: () {
                HomeScreen.homeKey.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: color ??
                    Theme.of(context).appBarTheme.iconTheme?.color ??
                    blackTextColor,
              ),
            )
          : IconButton(
              onPressed: () {
                onPressedBack == null
                    ? Navigator.pop(context)
                    : onPressedBack();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: color ??
                    Theme.of(context).appBarTheme.iconTheme?.color ??
                    blackTextColor,
              ),
            ),
      backgroundColor:
          isDark ? Theme.of(context).appBarTheme.backgroundColor : bgColor,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: isDark
              ? Theme.of(context).appBarTheme.titleTextStyle?.color
              : blackTextColor,
          fontFamily: 'SF Pro Display',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (logic.user?.userSubscription.paymentStatus ==
            SubscriptionType.free) ...[
          GestureDetector(
            onTap: () {
              SubscriptionDialog.show(context: context);
            },
            child: Center(
                child: SizedBox(
              height: 30,
              width: 30,
              child: SvgPicture.asset('assets/icons/premium.svg'),
            )),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        GetBuilder<AppController>(
          builder: (logic) {
            var profileImage = logic.user?.imageUrl ?? "";
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                  onTap: () => Get.toNamed(profileRoute),
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: blueColor),
                      child: (profileImage.isEmpty || profileImage == "null")
                          ? const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 26,
                              ),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(profileImage),
                            ),
                    ),
                  )),
            );
          },
        ),
      ],
    );
  }

  static AppBar searchAppBar(
      BuildContext context, String title, bool isHome, String image,
      {Color? color, VoidCallback? onPressedBack}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logic = Get.find<AppController>();
    var profileImage = logic.user?.imageUrl ?? "";
    return AppBar(
      elevation: 5,
      shadowColor: isDark
          ? Theme.of(context).shadowColor.withOpacity(0.26)
          : Colors.black26,
      leading: (isHome)
          ? IconButton(
              onPressed: () {
                HomeScreen.homeKey.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: color ??
                    Theme.of(context).appBarTheme.iconTheme?.color ??
                    blackTextColor,
              ),
            )
          : IconButton(
              onPressed: () {
                onPressedBack == null
                    ? Navigator.pop(context)
                    : onPressedBack();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: color ??
                    Theme.of(context).appBarTheme.iconTheme?.color ??
                    blackTextColor,
              ),
            ),
      backgroundColor:
          isDark ? Theme.of(context).appBarTheme.backgroundColor : bgColor,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: isDark
              ? Theme.of(context).appBarTheme.titleTextStyle?.color
              : blackTextColor,
          fontFamily: 'SF Pro Display',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Get.toNamed(searchRoute, arguments: SearchScreenParam()),
          child: Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: Icon(
                Icons.search,
                size: 30,
                color:
                    isDark ? Theme.of(context).iconTheme.color : hintTextColor,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
              onTap: () => Get.to(const ProfileScreen()),
              child: Center(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: blueColor),
                  child: (profileImage.isEmpty || profileImage == "null")
                      ? const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 26,
                          ),
                        )
                      : CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(profileImage),
                        ),
                ),
              )),
        ),
      ],
    );
  }

  static AppBar subHomeAppBar(
    BuildContext context,
    String title,
    bool isHome,
    String image,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logic = Get.find<AppController>();
    var profileImage = logic.user?.imageUrl ?? "";
    return AppBar(
      elevation: 5,
      shadowColor: isDark
          ? Theme.of(context).shadowColor.withOpacity(0.26)
          : Colors.transparent,
      leading: (isHome)
          ? IconButton(
              onPressed: () {
                HomeScreen.homeKey.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).appBarTheme.iconTheme?.color ??
                    blackTextColor,
              ),
            )
          : IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).appBarTheme.iconTheme?.color ??
                    blackTextColor,
              ),
            ),
      backgroundColor:
          isDark ? Theme.of(context).appBarTheme.backgroundColor : bgColor,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: isDark
              ? Theme.of(context).appBarTheme.titleTextStyle?.color
              : blackTextColor,
          fontFamily: 'SF Pro Display',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (logic.user?.userSubscription.paymentStatus ==
            SubscriptionType.free) ...[
          GestureDetector(
            onTap: () {
              SubscriptionDialog.show(context: context);
            },
            child: Center(
                child: SizedBox(
              height: 30,
              width: 30,
              child: SvgPicture.asset('assets/icons/premium.svg'),
            )),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
              onTap: () => Get.to(const ProfileScreen()),
              child: Center(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: blueColor),
                  child: (profileImage == '')
                      ? const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 26,
                          ),
                        )
                      : CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(profileImage),
                        ),
                ),
              )),
        ),
      ],
    );
  }

  static AppBar noSubButtonBar({
    required BuildContext context,
    required String title,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logic = Get.find<AppController>();
    var profileImage = logic.user?.imageUrl ?? "";
    return AppBar(
      elevation: 5,
      shadowColor: isDark
          ? Theme.of(context).shadowColor.withOpacity(0.26)
          : Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color:
              Theme.of(context).appBarTheme.iconTheme?.color ?? blackTextColor,
        ),
      ),
      backgroundColor:
          isDark ? Theme.of(context).appBarTheme.backgroundColor : bgColor,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: isDark
              ? Theme.of(context).appBarTheme.titleTextStyle?.color
              : blackTextColor,
          fontFamily: 'SF Pro Display',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
              onTap: () {},
              child: Center(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: blueColor),
                  child: (profileImage.isEmpty || profileImage == "null")
                      ? const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 26,
                          ),
                        )
                      : CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(profileImage),
                        ),
                ),
              )),
        ),
      ],
    );
  }
}
