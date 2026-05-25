import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/participant.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/widgets/add_photo_from_gallery.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/widgets/uploaded_pictures.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/choose_place.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/contact_model.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/model/event_with_participants.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/notes_widget.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/participants/participants_widget.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/reminder/reminder_widget.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/arguments.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/repeat_widget.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/start_and_finish_date/start_and_finish_date_widget.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/bottom_sheet_bottom_buttons.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:photo_gallery/photo_gallery.dart';

class CreateOrEditBottomSheet extends StatefulWidget {
  final Color? color;
  final EventWithParticipants? eventWithParticipants;
  final bool isTravel;
  final int categoryId;
  final List<String> travelPictures;
  final DateTime chosenTime;

  const CreateOrEditBottomSheet({
    Key? key,
    required this.color,
    required this.isTravel,
    required this.categoryId,
    required this.chosenTime,
    this.eventWithParticipants,
    this.travelPictures = const [],
  }) : super(key: key);

  @override
  State<CreateOrEditBottomSheet> createState() =>
      _CreateOrEditBottomSheetState();

  static Future createEvent({
    required BuildContext context,
    required Color? color,
    required int categoryId,
    required DateTime chosenTime,
    bool isTravel = false,
  }) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
        builder: (_) => CreateOrEditBottomSheet(
          color: color,
          isTravel: isTravel,
          categoryId: categoryId,
          chosenTime: chosenTime,
        ),
      );

  static Future editEvent({
    required BuildContext context,
    required EventWithParticipants eventWithParticipants,
    required Color? color,
    required int categoryId,
    required DateTime chosenTime,
    bool isTravel = false,
    List<String> travelPictures = const [],
  }) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
        builder: (_) => CreateOrEditBottomSheet(
          eventWithParticipants: eventWithParticipants,
          color: color,
          isTravel: isTravel,
          categoryId: categoryId,
          travelPictures: travelPictures,
          chosenTime: chosenTime,
        ),
      );
}

class _CreateOrEditBottomSheetState extends State<CreateOrEditBottomSheet> {
  final _agendaController = Get.find<AgendaController>();
  final eventNameController = TextEditingController();
  final notesController = TextEditingController();
  final placeController = TextEditingController();
  bool _inviteesWidgetLoading = true;
  String _startDate = '';
  String _endDate = '';
  DateTime _eventStartDate = DateTime.now();
  DateTime _eventEndDate = DateTime.now();
  List<ContactModel> chosenContacts = [];
  String? repeat = repeatValues.reverse[RepeatRadioButtonOptions.doNotRepeat];
  List<int> _chosenWeekDays = [];
  int _numberOfWeeks = 0;
  Duration? reminder = const Duration(minutes: 0);
  List<Medium> _photos = [];
  Map<int, String> byDays = {
    1: 'MO',
    2: 'TU',
    3: 'WE',
    4: 'TH',
    5: 'FR',
    6: 'SA',
    7: 'SU',
  };

  DateTime? until;
  DurationRadioButtonOptions durationOption =
      DurationRadioButtonOptions.forever;

  bool absorb = false;

  bool disableEverything = false;

  @override
  void initState() {
    super.initState();
    if (widget.eventWithParticipants != null) {
      eventNameController.text = widget.eventWithParticipants!.event.eventName;
      notesController.text =
          widget.eventWithParticipants!.event.notes ?? 'No description';
      placeController.text =
          widget.eventWithParticipants!.event.place ?? 'No address';
      absorb = true;
      _eventStartDate = CommonFunctions.getParsedTime(
              widget.eventWithParticipants!.event.date,
              widget.eventWithParticipants!.event.startTime!) ??
          widget.eventWithParticipants!.event.startTime ??
          DateTime.now();
      _eventEndDate = CommonFunctions.getParsedTime(
              widget.eventWithParticipants!.event.date,
              widget.eventWithParticipants!.event.endTime!) ??
          widget.eventWithParticipants!.event.endTime ??
          DateTime.now();
      if (_eventEndDate.isBefore(DateTime.now()) ||
          widget.eventWithParticipants!.event.isEventDone) {
        disableEverything = true;
        absorb = false;
      }
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        setState(() {
          _startDate = CommonFunctions.formatDateToString(_eventStartDate);
          _endDate = CommonFunctions.formatDateToString(_eventEndDate);
          reminder = widget.eventWithParticipants!.event.reminder?.minutes;
        });
        if (widget.eventWithParticipants!.participants.isNotEmpty) {
          setState(() {
            _inviteesWidgetLoading = true;
          });
          final contacts = await CommonFunctions.getContacts();
          final _chosenContacts = <ContactModel>[];
          for (var element in contacts) {
            for (var participant
                in widget.eventWithParticipants!.participants) {
              if (participant.contactId == element.contactId &&
                  participant.phoneNumber!.contains(element.phoneNumber)) {
                log('contact is ${element.toString()}');
                _chosenContacts.add(element);
                break;
              }
            }
          }
          setState(() {
            chosenContacts = _chosenContacts;
          });
        }
        setState(() {
          _inviteesWidgetLoading = false;
        });
      });
    } else {
      setState(() {
        _inviteesWidgetLoading = false;
      });
    }
  }

  void _getRepeatArguments(RepeatArguments chosenRepeatOptions) {
    repeat = repeatValues.reverse[chosenRepeatOptions.repeat];
    _numberOfWeeks = chosenRepeatOptions.numberOfWeeks;
    chosenRepeatOptions.chosenWeekDays.sort();
    _chosenWeekDays = chosenRepeatOptions.chosenWeekDays;
    until = chosenRepeatOptions.until;
    durationOption = chosenRepeatOptions.durationOption;
    debugPrint('here is final string $_finalRepeatFormat');
  }

  void _setReminder(Duration duration) {
    reminder = duration;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? darkBgColor : bgColor,
      padding: EdgeInsets.all(10.w),
      constraints:
          BoxConstraints(maxHeight: (MediaQuery.of(context).size.height * 0.9)),
      child: Scaffold(
        backgroundColor: isDark ? darkBgColor : whiteColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              AbsorbPointer(
                absorbing: disableEverything,
                child: Opacity(
                  opacity: disableEverything ? 0.5 : 1,
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
                      SizedBox(height: 10.h),
                      TextField(
                        controller: eventNameController,
                        obscureText: false,
                        textCapitalization: TextCapitalization.sentences,
                        style: customTextStyle(
                          fontSize: 34.sp,
                          color: isDark ? whiteColor : blackTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: eventName.tr,
                          hintStyle: customTextStyle(
                            fontSize: 34.sp,
                            color: isDark ? whiteColor : hintTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      StartAndFinishDateWidget(
                        start: _startDate,
                        end: _endDate,
                        changeStartDate: _changeStartDate,
                        changeEndDate: _changeEndDate,
                        color: widget.color,
                        chosenTime: widget.chosenTime,
                      ),
                      SizedBox(height: 20.h),
                      _inviteesWidgetLoading
                          ? const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : ParticipantsWidget(
                              color: widget.color,
                              onContactsChosen: _setChosenContacts,
                              participants: widget.eventWithParticipants == null
                                  ? null
                                  : chosenContacts,
                            ),
                      SizedBox(height: 20.h),
                      if (widget.isTravel) ...[
                        if (widget.eventWithParticipants != null)
                          UploadedPictures(
                              travelPictures: widget.travelPictures)
                        else
                          AddPhotoFromGallery(
                            color: widget.color!,
                            setPhotos: (newMedia) => _photos = newMedia,
                          ),
                      ],
                      SizedBox(height: 20.h),
                      ReminderWidget(
                        event: widget.eventWithParticipants?.event,
                        setReminder: _setReminder,
                      ),
                      SizedBox(height: 20.h),
                      ChoosePlace(
                        placeController: placeController,
                        absorb: false,
                      ),
                      SizedBox(height: 20.h),
                      AbsorbPointer(
                        absorbing: absorb,
                        child: Opacity(
                          opacity:
                              widget.eventWithParticipants == null ? 1 : 0.5,
                          child: RepeatWidget(
                            event: widget.eventWithParticipants?.event,
                            color: widget.color,
                            onRepeatChanged: _getRepeatArguments,
                            chosenDay: widget.chosenTime,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      NotesWidget(
                        notesController: notesController,
                        absorb: false,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
              BottomSheetBottomButtons(
                text: deleteEvent.tr,
                showDeleteButton: widget.eventWithParticipants != null,
                onPressSave: () async {
                  LoadingOverlay.show(context);
                  await _createOrEditEventAddParticipant();
                  LoadingOverlay.hide();
                },
                onPressDelete: () async {
                  LoadingOverlay.show(context);
                  if (widget.eventWithParticipants == null) {
                  } else {
                    await _agendaController
                        .deleteEvent(widget.eventWithParticipants!.event.id!);
                  }
                  LoadingOverlay.hide();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
                buttonColor: widget.color,
                showSaveButton: !disableEverything,
              ),
              SizedBox(
                height: MediaQuery.of(context).viewPadding.bottom + 48.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createOrEditEventAddParticipant() async {
    if (eventNameController.text.isEmpty ||
        _startDate.isEmpty ||
        _endDate.isEmpty) {
      showAttentionSnackBar(message: eventNameDateRequired.tr);
      return;
    }
    if (widget.isTravel) {
      await _createEditTravelEvent();
      return;
    }
    if (widget.eventWithParticipants != null) {
      final event = Event(
        eventName: eventNameController.text,
        categoryId: widget.categoryId,
        startTime: widget.eventWithParticipants!.event.recurrences == null
            ? _eventStartDate
            : widget.eventWithParticipants!.event.startTime,
        endTime: widget.eventWithParticipants!.event.recurrences == null
            ? _eventEndDate
            : widget.eventWithParticipants!.event.endTime,
        notes: notesController.text,
        place: placeController.text,
        user: _agendaController.user?.id,
        eventPhotos: [],
        reminder: reminder?.inMinutes,
        url: widget.eventWithParticipants!.event.url,
        uuid: widget.eventWithParticipants!.event.uuid,
      );
      final editedEvent = await Get.find<AgendaController>().editEvent(
        event,
        widget.eventWithParticipants!.event.id!,
      );
      if (editedEvent != null) {
        List<Participant> participants = [];
        for (var contact in chosenContacts) {
          participants.add(contact.toParticipant(editedEvent.id!));
        }
        await _agendaController.editParticipantsOfEvent(participants,
            eventId: editedEvent.id!);
        Navigator.of(context).pop(true);
      }
    } else {
      final event = Event(
        eventName: eventNameController.text,
        categoryId: widget.categoryId,
        startTime: _eventStartDate,
        endTime: _eventEndDate,
        notes: notesController.text,
        place: placeController.text,
        reminder: reminder?.inMinutes,
        recurrences: _finalRepeatFormat.isEmpty ? null : _finalRepeatFormat,
        user: _agendaController.user?.id,
        eventPhotos: [],
      );
      final createdEvent = await _agendaController.createEvent(event);

      if (createdEvent != null) {
        List<Participant> participants = [];
        for (var contact in chosenContacts) {
          participants.add(contact.toParticipant(createdEvent.id!));
        }
        await _agendaController.addParticipantsToEvent(participants);
        Navigator.of(context).pop(true);
      }
    }
  }

  String get _finalRepeatFormat {
    String result = '';
    if (repeat == repeatValues.reverse[RepeatRadioButtonOptions.doNotRepeat]) {
      return result;
    }
    if (repeat == repeatValues.reverse[RepeatRadioButtonOptions.everyday]) {
      result = "RRULE:FREQ=DAILY";
      if (until != null) {
        result = result + _calculateUntil(until!);
      }
    } else if (repeat ==
        repeatValues.reverse[RepeatRadioButtonOptions.everyWeek]) {
      result = 'RRULE:FREQ=WEEKLY;INTERVAL=$_numberOfWeeks';
      if (until != null) {
        result = result + _calculateUntil(until!);
      }
      result = result + ';BYDAY=';
      for (int i = 0; i < _chosenWeekDays.length; i++) {
        result = result + '${byDays[_chosenWeekDays[i]]},';
      }
      result = result.substring(0, result.length - 1);
    } else if (repeat ==
        repeatValues.reverse[RepeatRadioButtonOptions.everyMonth]) {
      result = 'RRULE:FREQ=MONTHLY';
      if (until != null) {
        result = result + _calculateUntil(until!);
      }
      result = result + ';BYMONTHDAY=${_eventStartDate.day}';
    } else if (repeat ==
        repeatValues.reverse[RepeatRadioButtonOptions.everyYear]) {
      result = 'RRULE:FREQ=YEARLY';
      if (until != null) {
        result = result + _calculateUntil(until!);
      }
    }

    return result;
  }

  void _changeStartDate(DateTime startDate) {
    setState(() {
      _startDate = CommonFunctions.formatDateToString(startDate);
      _eventStartDate = startDate;
    });
  }

  void _changeEndDate(DateTime endDate) {
    setState(() {
      _endDate = CommonFunctions.formatDateToString(endDate);
      _eventEndDate = endDate;
    });
  }

  void _setChosenContacts(List<ContactModel> contacts) {
    setState(() {
      chosenContacts = contacts;
    });
  }

  String _calculateUntil(DateTime dateTime) {
    if (dateTime.month < 10) {
      if (dateTime.day < 10) {
        return ';UNTIL=${dateTime.year}0${dateTime.month}0${dateTime.day}T235959Z';
      }
      return ';UNTIL=${dateTime.year}0${dateTime.month}${dateTime.day}T235959Z';
    } else {
      if (dateTime.day < 10) {
        return ';UNTIL=${dateTime.year}${dateTime.month}0${dateTime.day}T235959Z';
      }
      return ';UNTIL=${dateTime.year}${dateTime.month}${dateTime.day}T235959Z';
    }
  }

  Future<void> _createEditTravelEvent() async {
    if (widget.eventWithParticipants != null) {
      final event = Event(
        eventName: eventNameController.text,
        categoryId: widget.categoryId,
        startTime: widget.eventWithParticipants!.event.recurrences == null
            ? _eventStartDate
            : widget.eventWithParticipants!.event.startTime,
        endTime: widget.eventWithParticipants!.event.recurrences == null
            ? _eventEndDate
            : widget.eventWithParticipants!.event.endTime,
        notes: notesController.text,
        place: placeController.text,
        user: _agendaController.user?.id,
        eventPhotos: [],
        reminder: reminder?.inMinutes,
        url: widget.eventWithParticipants!.event.url,
        uuid: widget.eventWithParticipants!.event.uuid,
      );
      final editedEvent = await Get.find<AgendaController>().editEvent(
        event,
        widget.eventWithParticipants!.event.id!,
      );
      if (editedEvent != null) {
        List<Participant> participants = [];
        for (var contact in chosenContacts) {
          participants.add(contact.toParticipant(editedEvent.id!));
        }
        await _agendaController.editParticipantsOfEvent(participants,
            eventId: editedEvent.id!);
        Navigator.of(context).pop(true);
      }
    } else {
      final event = Event(
        eventName: eventNameController.text,
        categoryId: widget.categoryId,
        startTime: _eventStartDate,
        endTime: _eventEndDate,
        notes: notesController.text,
        place: placeController.text,
        reminder: reminder?.inMinutes,
        recurrences: _finalRepeatFormat.isEmpty ? null : _finalRepeatFormat,
        user: _agendaController.user?.id,
        eventPhotos: [],
      );
      final createdEvent = await _agendaController.createEvent(event);

      if (createdEvent != null) {
        List<Participant> participants = [];
        for (var contact in chosenContacts) {
          participants.add(contact.toParticipant(createdEvent.id!));
        }
        await _agendaController.addParticipantsToEvent(participants);
        List<File> _files = [];
        for (var element in _photos) {
          _files.add(await element.getFile());
        }
        await _agendaController.uploadTravelPhotos(
            _files, createdEvent.id!, _agendaController.user!.id);
        Navigator.of(context).pop(true);
      }
    }
  }
}
