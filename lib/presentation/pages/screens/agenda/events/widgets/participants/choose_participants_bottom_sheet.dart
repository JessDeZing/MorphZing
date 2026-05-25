import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/contact_model.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/participants/single_participant.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';

class ChooseParticipants extends StatefulWidget {
  final List<ContactModel> contacts;
  final List<ContactModel> listOfChosenContacts;
  final Color? color;

  const ChooseParticipants({
    Key? key,
    required this.contacts,
    required this.color,
    required this.listOfChosenContacts,
  }) : super(key: key);

  static Future show({
    required BuildContext context,
    required List<ContactModel> contacts,
    required List<ContactModel> listOfChosenContacts,
    required Color? color,
  }) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.r))),
        clipBehavior: Clip.antiAlias,
        builder: (_) => ChooseParticipants(
          contacts: contacts,
          color: color,
          listOfChosenContacts: listOfChosenContacts,
        ),
      );

  @override
  State<ChooseParticipants> createState() => _ChooseParticipantsState();
}

class _ChooseParticipantsState extends State<ChooseParticipants> {
  final _scrollController = ScrollController();
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.r)),
    borderSide: BorderSide(
      color: dividerColor,
      width: 1.sp,
    ),
  );
  final _nameController = TextEditingController();
  bool _showClearTextFieldButton = false;
  late final List<ContactModel> _originalList = widget.contacts;
  late List<ContactModel> _listShowsOnTheScreen = widget.contacts;
  List<ContactModel> _chosenContacts = [];

  void _searchByName(String enteredText) {
    _listShowsOnTheScreen = [];
    for (var e in _originalList) {
      if (e.fullName.toLowerCase().startsWith(enteredText.toLowerCase())) {
        _listShowsOnTheScreen.add(e);
      }
    }
    setState(() {
      if (enteredText != '') {
        _showClearTextFieldButton = true;
      } else {
        _showClearTextFieldButton = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _chosenContacts = widget.listOfChosenContacts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Container(
          color: isDark ? darkBgColor : whiteColor,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
            minHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Text(
                '${inviteUpTo.tr} 10 ${participants.tr}',
                style: customTextStyle(
                  fontSize: 17.sp,
                  color: isDark ? whiteColor : blackTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 51,
                child: TextField(
                  controller: _nameController,
                  onChanged: _searchByName,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    enabledBorder: border,
                    focusedBorder: border,
                    border: border,
                    hintText: searchByName.tr,
                    hintStyle: customTextStyle(
                      fontSize: 16.sp,
                      color: isDark ? whiteColor : greyTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                    suffixIcon: _showClearTextFieldButton
                        ? GestureDetector(
                            onTap: () {
                              _searchByName('');
                              _nameController.clear();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              color: Colors.transparent,
                              child: SvgPicture.asset(
                                  'assets/icons/clear_field.svg'),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isDark ? darkBgColor : bgColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  child: Scrollbar(
                    controller: _scrollController,
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: 10.w),
                      separatorBuilder: (_, __) => SizedBox(height: 20.h),
                      itemBuilder: (_, index) {
                        final contact = _listShowsOnTheScreen[index];
                        //stateful builder updates only widgets below it
                        return StatefulBuilder(
                          builder: (_, setState) {
                            return GestureDetector(
                              onTap: () {
                                if (_chosenContacts.length > 9 &&
                                    !_chosenContacts.contains(contact)) {
                                  showAttentionSnackBar(
                                      message:
                                          '${onlyUpTo.tr} 10 ${inviteesAreAllowed.tr}');
                                  return;
                                }
                                if (_chosenContacts.contains(contact)) {
                                  _chosenContacts.remove(contact);
                                } else {
                                  _chosenContacts.add(contact);
                                }
                                setState(() {});
                              },
                              child: SingleParticipant(
                                initials: contact.initials,
                                name: contact.fullName,
                                phone: contact.rawPhoneNumber,
                                isChosen: _chosenContacts.contains(contact),
                                color: widget.color,
                              ),
                            );
                          },
                        );
                      },
                      itemCount: _listShowsOnTheScreen.length,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewPadding.bottom + 70.h,
              ),
            ],
          ),
        ),
        Positioned(
          right: 10.w,
          top: 10.h,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.w),
                color: isDark ? darkBgColor : bgColor,
              ),
              child: Icon(
                CupertinoIcons.clear,
                color: isDark ? whiteColor : hintTextColor,
                size: 16,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.h,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: PrimaryButton(
              buttonColor: widget.color,
              onPressed: () {
                Navigator.of(context).pop(_chosenContacts);
              },
              buttonText: submit.tr,
            ),
          ),
        ),
      ],
    );
  }
}
