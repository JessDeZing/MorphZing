import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/agenda/participant.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/contact_model.dart';
import 'package:permission_handler/permission_handler.dart';

class CommonFunctions {
  static String getCorrectEventQuantity(int length) {
    String result = '';
    if (length == 1) {
      result = '1';
    } else if (length > 1) {
      result = '$length ';
    }
    return result;
  }

  static String formatDateToString(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return DateFormat("EEEE,MMM d, hh:mm aaa", Get.locale?.languageCode)
        .format(dateTime);
  }

  static Future<List<ContactModel>> getContacts() async {
    if (await Permission.contacts.status !=
        PermissionStatus.permanentlyDenied) {
      final result = await Permission.contacts.request();
      if (result == PermissionStatus.granted) {
        final contacts =
            await FlutterContacts.getContacts(withProperties: true);
        return populateContactsToModel(contacts);
      } else if (result == PermissionStatus.permanentlyDenied) {
        await Get.defaultDialog(
          content: TextButton(
            child: Text(openSettings.tr),
            onPressed: () {
              openAppSettings();
            },
          ),
          title: permissionPermanentlyDenied.tr,
          middleText: contactPermissionManual.tr,
        );
      }
    } else {
      await Get.defaultDialog(
        content: TextButton(
          child: Text(openSettings.tr),
          onPressed: () {
            openAppSettings();
          },
        ),
        title: permissionPermanentlyDenied.tr,
        middleText: contactPermissionManual.tr,
      );
    }
    return [];
  }

  static List<ContactModel> populateContactsToModel(List<Contact> contacts) {
    List<ContactModel> result = [];
    for (var element in contacts) {
      if (element.phones.isNotEmpty) {
        for (var phone in element.phones) {
          if (phone.label == PhoneLabel.mobile) {
            final initials =
                '${element.name.first.isEmpty ? '' : element.name.first.substring(0, 1)}${element.name.last.isEmpty ? '' : element.name.last.substring(0, 1)}';
            result.add(
              ContactModel(
                contactId: element.id,
                fullName: element.displayName,
                initials: initials,
                phoneNumber: phone.number.replaceAll(RegExp(('[+\\s()-]')), ''),
                rawPhoneNumber: phone.number,
              ),
            );
          }
        }
      }
    }
    return result.toSet().toList();
  }

  static String getCorrectStartTimeOfEvent(DateTime dateTime) {
    return DateFormat('hh:mm aaa', Get.locale?.languageCode).format(dateTime);
  }

  ///function to change start time year month and day to another date
  static DateTime? getParsedTime(String? date, DateTime timeToOverwrite) {
    if (date == null) {
      return timeToOverwrite;
    }
    DateTime? result = DateTime.tryParse(date);
    if (result != null) {
      result = DateTime(
        result.year,
        result.month,
        result.day,
        timeToOverwrite.hour,
        timeToOverwrite.minute,
        timeToOverwrite.second,
      );
    }
    return result;
  }
}

extension ConvertContactToParticipant on ContactModel {
  Participant toParticipant(int eventId,
      {ParticipantStatus participantStatus = ParticipantStatus.pending}) {
    return Participant(
      eventId: eventId,
      phoneNumber: phoneNumber,
      contactId: contactId,
      status: participantStatus,
    );
  }
}
