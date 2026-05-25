import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/invitations_by_category/widgets/invitation_bottom_sheet.dart';
import 'package:morphzing/utils/style/colors.dart';

class InvitationContainer extends StatelessWidget {
  final Event event;
  final Color? color;
  final List<String>? travelPictures;

  const InvitationContainer({
    Key? key,
    required this.event,
    this.color,
    this.travelPictures,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await InvitationBottomSheet.show(
          context: context,
          event: event,
          travelPictures: travelPictures,
          color: color,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          gradient: color == null ? specialOccasionGradient : null,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.eventName,
                    style: customTextStyle(
                      fontSize: 15,
                      color: _isBlackColor ? blackTextColor : whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  CommonFunctions.getCorrectStartTimeOfEvent(event.startTime!),
                  style: customTextStyle(
                    fontSize: 14,
                    color: _isBlackColor ? blackTextColor : whiteColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            if (travelPictures != null && travelPictures!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    event.notes ?? '',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: customTextStyle(
                      fontSize: 12,
                      color: whiteColor,
                      fontWeight: FontWeight.w400,
                    ).copyWith(height: 15.6 / 12),
                  )),
                  const SizedBox(width: 10),
                  Container(
                    height: 65,
                    width: 65,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: FadeInImage(
                      fadeInDuration: 100.milliseconds,
                      fadeOutDuration: 100.milliseconds,
                      fit: BoxFit.fill,
                      placeholderFit: BoxFit.cover,
                      placeholder: const AssetImage(
                          "assets/images/placeholder_photo.jpg"),
                      image: NetworkImage(travelPictures!.first),
                      //image: AssetImage('assets/images/25721.jpeg'),
                      imageErrorBuilder: (_, __, ___) => Image.asset(
                        "assets/images/placeholder_photo.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  bool get _isBlackColor => color == null || color!.value == workColor.value;
}
