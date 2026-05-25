import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/arguments.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/style/colors.dart';

class AgendaTypeContainer extends StatelessWidget {
  final String name;
  final String quantity;
  final List<Event> events;
  final TextStyle? nameStyle;
  final TextStyle? quantityStyle;
  final Color? color;
  final List<String>? travelPictures;

  const AgendaTypeContainer({
    Key? key,
    required this.name,
    required this.quantity,
    required this.events,
    this.nameStyle,
    this.quantityStyle,
    this.color,
    this.travelPictures,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.toNamed(
          invitationsByCategoryRoute,
          arguments: InvitationArguments(
            categoryName: name,
            eventList: events,
            color: color,
            travelPictures: travelPictures,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: color,
          gradient: color == null ? specialOccasionGradient : null,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: nameStyle ??
                  customTextStyle(
                    fontSize: 20,
                    color: whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            // Text(
            //   // quantity.isEmpty ? 'No events' : quantity,
            //   quantity,
            //   style: quantityStyle ??
            //       customTextStyle(
            //         fontSize: 14,
            //         color: whiteColor,
            //         fontWeight: FontWeight.w400,
            //       ),
            // ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white, // Background color for the badge
                shape: BoxShape.circle, // Circular shape
              ),
              padding: EdgeInsets.all(6), // Padding for the badge content
              child: Text(
                // quantity.isEmpty ? 'No events' : quantity,
                quantity.isEmpty ? '0' : quantity,
                style: quantityStyle ??
                    customTextStyle(
                      fontSize: 12,
                      color: isDark ? whiteColor : Colors.black, // Text color
                      fontWeight: FontWeight.w400,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
