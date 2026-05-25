import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/widgets/uploaded_pictures.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/repeat_widget.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/invitations_by_category/widgets/time_container.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/invitations_by_category/widgets/title_rounded_container.dart';
import 'package:morphzing/utils/style/colors.dart';

class ParticipantEventDetails extends StatefulWidget {
  final Event event;
  final List<String>? travelPictures;

  const ParticipantEventDetails({
    Key? key,
    required this.event,
    this.travelPictures,
  }) : super(key: key);

  static Future show({
    required BuildContext context,
    required Event event,
    List<String>? travelPictures,
  }) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (_) => ParticipantEventDetails(
          event: event,
          travelPictures: travelPictures,
        ),
      );

  @override
  State<ParticipantEventDetails> createState() =>
      _ParticipantEventDetailsState();
}

class _ParticipantEventDetailsState extends State<ParticipantEventDetails> {
  String _reminder = noReminderSet.tr;

  String? localRepeat =
      repeatValues.reverse[RepeatRadioButtonOptions.doNotRepeat];

  void _setRepeatTextAccordingly(String recurrences) {
    if (recurrences.contains('FREQ=WEEKLY')) {
      localRepeat = repeatValues.reverse[RepeatRadioButtonOptions.everyWeek];
    } else if (recurrences.contains('FREQ=MONTHLY')) {
      localRepeat = repeatValues.reverse[RepeatRadioButtonOptions.everyMonth];
    } else if (recurrences.contains('FREQ=YEARLY')) {
      localRepeat = repeatValues.reverse[RepeatRadioButtonOptions.everyYear];
    } else if (recurrences.contains('FREQ=DAILY')) {
      localRepeat = repeatValues.reverse[RepeatRadioButtonOptions.everyday];
    }
  }

  String get _correctReminderDuration {
    final duration = widget.event.reminder;
    if (duration == null) {
      return _reminder;
    }
    if (duration ~/ 60 == 0) {
      _reminder = '$duration ${minutes.tr} ${beforeStart.tr}';
    } else if (duration % 60 == 0) {
      _reminder = '${duration ~/ 60} ${hours.tr} ${beforeStart.tr}';
    } else {
      _reminder =
          '${duration ~/ 60} ${hours.tr} ${duration % 60} ${minutes.tr} ${beforeStart.tr}';
    }
    return _reminder;
  }

  @override
  void initState() {
    super.initState();
    _setRepeatTextAccordingly(widget.event.recurrences ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? darkBgColor : whiteColor,
      padding: const EdgeInsets.all(10),
      constraints:
          BoxConstraints(maxHeight: (MediaQuery.of(context).size.height * 0.9)),
      child: Scaffold(
        backgroundColor: isDark ? darkBgColor : whiteColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: isDark ? darkBgColor : bgColor,
                      ),
                      child: Icon(
                        CupertinoIcons.clear,
                        color: isDark ? whiteColor : hintTextColor,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                event.eventName,
                style: customTextStyle(
                  fontSize: 34,
                  color: isDark ? whiteColor : blackTextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                height: 0,
                thickness: 1,
                color: isDark ? whiteColor : dividerColor,
              ),
              const SizedBox(height: 20),
              TimeContainer(
                start: CommonFunctions.formatDateToString(event.startTime),
                end: CommonFunctions.formatDateToString(event.endTime),
              ),
              const SizedBox(height: 20),
              if (widget.travelPictures != null &&
                  widget.travelPictures!.isNotEmpty) ...[
                UploadedPictures(travelPictures: widget.travelPictures!),
                const SizedBox(height: 20),
              ],
              TitleRoundedContainer(
                title: reminder.tr,
                body: _correctReminderDuration,
              ),
              const SizedBox(height: 20),
              TitleRoundedContainer(
                title: place.tr,
                body: event.place == null || event.place!.isEmpty
                    ? notSpecified.tr
                    : event.place!,
              ),
              const SizedBox(height: 20),
              TitleRoundedContainer(title: repeat.tr, body: '$localRepeat'),
              const SizedBox(height: 20),
              TitleRoundedContainer(
                title: description.tr,
                body: event.notes == null || event.notes!.isEmpty
                    ? notProvided.tr
                    : event.notes!,
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: isDark ? darkBgColor : bgColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Text(
                    inviteAccepted.tr,
                    style: customTextStyle(
                      fontSize: 16,
                      color: isDark ? whiteColor : blackTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 24),
            ],
          ),
        ),
      ),
    );
  }
}
