import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/participant.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/contact_model.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/participants/choose_participants_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/participants/stacked_images.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class ParticipantsWidget extends StatefulWidget {
  final Function(List<ContactModel>) onContactsChosen;
  final Color? color;
  final List<ContactModel>? participants;

  const ParticipantsWidget({
    Key? key,
    required this.color,
    required this.onContactsChosen,
    this.participants,
  }) : super(key: key);

  @override
  State<ParticipantsWidget> createState() => _ParticipantsWidgetState();
}

class _ParticipantsWidgetState extends State<ParticipantsWidget> {
  bool _isLoading = false;
  List<ContactModel> _listOfChosenContacts = [];

  @override
  void initState() {
    super.initState();
    if (widget.participants != null && widget.participants!.isNotEmpty) {
      _listOfChosenContacts = widget.participants!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        if (await Permission.contacts.status == PermissionStatus.denied) {
          await CustomDialogs.show(
            context: context,
            rightButton: continueKey.tr,
            title: morphzingWouldAccessContacts.tr,
            subtitle: chooseWhomToInvite.tr,
            onPressLeftButton: () {
              Navigator.pop(context);
            },
            onPressRightButton: () async {
              Navigator.pop(context);
              setState(() {
                _isLoading = true;
              });
              final result = await CommonFunctions.getContacts();
              setState(() {
                _isLoading = false;
              });
              final chosenContacts = await ChooseParticipants.show(
                context: context,
                contacts: result,
                color: widget.color,
                listOfChosenContacts: _listOfChosenContacts,
              );
              if (chosenContacts != null) {
                setState(() {
                  _listOfChosenContacts = chosenContacts;
                });
                widget.onContactsChosen(chosenContacts);
              }
              return;
            },
          );
          return;
        }
        setState(() {
          _isLoading = true;
        });
        final result = await CommonFunctions.getContacts();
        setState(() {
          _isLoading = false;
        });
        final chosenContacts = await ChooseParticipants.show(
          context: context,
          contacts: result,
          color: widget.color,
          listOfChosenContacts: _listOfChosenContacts,
        );
        if (chosenContacts != null) {
          setState(() {
            _listOfChosenContacts = chosenContacts;
          });
          widget.onContactsChosen(chosenContacts);
        }
      },
      child: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invite.tr,
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: isDark ? whiteColor : blackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? darkBgColor : bgColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: StackedImages(
                          inEditMode: widget.participants != null &&
                              widget.participants!.isEmpty,
                          listOfInviteeImages: List.generate(
                            _listOfChosenContacts.length,
                            (index) =>
                                _stackedImage(_listOfChosenContacts[index]),
                          ),
                          color: widget.color,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: isDark ? whiteColor : blackTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _stackedImage(ContactModel contactModel) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 39.w,
      width: 39.w,
      decoration: BoxDecoration(
        color: widget.color,
        shape: BoxShape.circle,
        gradient: widget.color == null ? specialOccasionGradient : null,
      ),
      child: Center(
        child: Text(
          contactModel.initials,
          style: customTextStyle(
            fontSize: 13.sp,
            color: isDark ? blackTextColor : whiteColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
