import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/widgets/uploaded_pictures.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/bottom_sheet_bottom_buttons.dart';
import 'package:morphzing/utils/style/colors.dart';

class EventInfoBottomSheet extends StatefulWidget {
  static Future show({
    required BuildContext context,
    required Event event,
  }) =>
      showModalBottomSheet(
        context: context,
        builder: (_) => EventInfoBottomSheet(event: event),
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
      );

  final Event event;

  const EventInfoBottomSheet({Key? key, required this.event}) : super(key: key);

  @override
  State<EventInfoBottomSheet> createState() => _EventInfoBottomSheetState();
}

class _EventInfoBottomSheetState extends State<EventInfoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10.w),
      constraints: BoxConstraints(
        maxHeight: (MediaQuery.of(context).size.height * 0.9).h - kToolbarHeight,
      ),
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40.w,
                      width: 40.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.w),
                        color: bgColor,
                      ),
                      child: const Icon(
                        CupertinoIcons.clear,
                        color: hintTextColor,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              TextFormField(
                initialValue: widget.event.eventName,
                obscureText: false,
                textCapitalization: TextCapitalization.sentences,
                readOnly: true,
                style: customTextStyle(
                  fontSize: 34.sp,
                  color: blackTextColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Task name',
                  hintStyle: customTextStyle(
                    fontSize: 34.sp,
                    color: hintTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              if (widget.event.startTime != null && widget.event.endTime != null) ...[
                Text(
                  'Date',
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: blackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  CommonFunctions.formatDateToString(widget.event.startTime),
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  CommonFunctions.formatDateToString(widget.event.endTime),
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20.h),
              ],
              if (widget.event.eventPhotos.isNotEmpty && widget.event.eventPhotos[0].images.isNotEmpty) ...[
                SizedBox(height: 10.h),
                UploadedPictures(
                  travelPictures: widget.event.eventPhotos[0].images.map((e) {
                    return e.imageUrl ?? '';
                  }).toList(),
                ),
                SizedBox(height: 20.h),
              ],
              if (widget.event.reminder != null) ...[
                Text(
                  'Reminder',
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: blackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  '${widget.event.reminder} minutes before start',
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20.h),
              ],
              if (widget.event.place != null && widget.event.place!.isNotEmpty) ...[
                Text(
                  'Place',
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: blackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  '${widget.event.place}',
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20.h),
              ],
              if (widget.event.recurrences != null && widget.event.recurrences!.isNotEmpty) ...[
                Text(
                  'Repeat',
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: blackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  getRecurrences(),
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20.h),
              ],
              if (widget.event.notes != null && widget.event.notes!.isNotEmpty) ...[
                Text(
                  'Note',
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: blackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  '${widget.event.notes}',
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20.h),
              ]
            ],
          ),
        ),
      ),
    );
  }

  String getRecurrences() {
    if (widget.event.recurrences!.contains('DAILY')) return 'DAILY';
    if (widget.event.recurrences!.contains('MONTHLY')) return 'MONTHLY';
    if (widget.event.recurrences!.contains('YEARLY')) return 'YEARLY';
    return '';
  }
}
