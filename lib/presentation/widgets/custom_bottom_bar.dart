import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/presentation/pages/screens/journal/journal_calendar.dart';
import 'package:morphzing/presentation/pages/screens/search/search_screen.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_dialog.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

import '../../utils/style/colors.dart';

class CustomBottomBar {
  static customFloatingActionButton(VoidCallback onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: blueColor,
      child: const Icon(
        Icons.add,
        size: 40,
      ),
    );
  }

  static journalFloatingActionButton(VoidCallback onPressed, {Color? color}) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          gradient: color == null
              ? const LinearGradient(colors: [
                  Color(0xFFD9271D),
                  Color(0xFFE67817),
                  Color(0xFFFFF701),
                  Color(0xFF84C428),
                  Color(0xFF76C5F0),
                  Color(0xFF8F1E78),
                ])
              : null,
        ),
        child: const Icon(
          Icons.add,
          size: 26,
          color: Colors.white,
        ),
      ),
    );
  }

  static agendaFloatingActionButton({
    required BuildContext context,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color,
      child: const Icon(
        Icons.add,
        size: 40,
      ),
    );
  }

  static customBottomBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: -8,
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 16,
              ),
              child: GestureDetector(
                onTap: () {
                  SubscriptionDialog.show(context: context);
                },
                child: SizedBox(
                  height: 36,
                  width: 36,
                  child: SvgPicture.asset(
                    'assets/icons/premium.svg',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 16,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.offAllNamed(homeRoute);
                },
                child: SizedBox(
                  height: 36,
                  width: 36,
                  child: SvgPicture.asset(
                    'assets/icons/leading_icon.svg',
                    color: hintTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static customJournalBottomBar({
    required VoidCallback onPressedCalendar,
    required BuildContext context,
  }) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: -8,
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      SubscriptionDialog.show(context: context);
                    },
                    child: SizedBox(
                      height: 36,
                      width: 36,
                      child: SvgPicture.asset(
                        'assets/icons/premium.svg',
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     vertical: 10.0,
                //     horizontal: 16,
                //   ),
                //   child: GestureDetector(
                //     onTap: () {
                //       Get.toNamed(allNoteRoute);
                //     },
                //     child: const SizedBox(
                //       height: 36,
                //       width: 36,
                //       child: Icon(
                //         Icons.sticky_note_2_rounded,
                //         size: 30,
                //         color: hintTextColor,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16,
                  ),
                  child: GestureDetector(
                    onTap: () => onPressedCalendar(),
                    child: const SizedBox(
                      height: 36,
                      width: 36,
                      child: Icon(
                        Icons.event_note,
                        size: 30,
                        color: hintTextColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.offAllNamed(homeRoute);
                    },
                    child: SizedBox(
                      height: 36,
                      width: 36,
                      child: SvgPicture.asset(
                        'assets/icons/leading_icon.svg',
                        color: hintTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static customNoteBottomBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: -8,
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 16,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.offAllNamed(homeRoute);
                },
                child: SizedBox(
                  height: 36,
                  width: 36,
                  child: SvgPicture.asset(
                    'assets/icons/leading_icon.svg',
                    color: hintTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
