// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventCWProxy {
  Event categoryId(int categoryId);

  Event date(String? date);

  Event endTime(DateTime? endTime);

  Event eventName(String eventName);

  Event eventPhotos(List<EventPhoto> eventPhotos);

  Event id(int? id);

  Event isEventDone(bool isEventDone);

  Event isParticipant(bool isParticipant);

  Event notes(String? notes);

  Event place(String? place);

  Event recurrences(String? recurrences);

  Event reminder(int? reminder);

  Event startTime(DateTime? startTime);

  Event url(String url);

  Event user(int? user);

  Event uuid(String uuid);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Event(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Event(...).copyWith(id: 12, name: "My name")
  /// ````
  Event call({
    int? categoryId,
    String? date,
    DateTime? endTime,
    String? eventName,
    List<EventPhoto>? eventPhotos,
    int? id,
    bool? isEventDone,
    bool? isParticipant,
    String? notes,
    String? place,
    String? recurrences,
    int? reminder,
    DateTime? startTime,
    String? url,
    int? user,
    String? uuid,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEvent.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEvent.copyWith.fieldName(...)`
class _$EventCWProxyImpl implements _$EventCWProxy {
  final Event _value;

  const _$EventCWProxyImpl(this._value);

  @override
  Event categoryId(int categoryId) => this(categoryId: categoryId);

  @override
  Event date(String? date) => this(date: date);

  @override
  Event endTime(DateTime? endTime) => this(endTime: endTime);

  @override
  Event eventName(String eventName) => this(eventName: eventName);

  @override
  Event eventPhotos(List<EventPhoto> eventPhotos) =>
      this(eventPhotos: eventPhotos);

  @override
  Event id(int? id) => this(id: id);

  @override
  Event isEventDone(bool isEventDone) => this(isEventDone: isEventDone);

  @override
  Event isParticipant(bool isParticipant) => this(isParticipant: isParticipant);

  @override
  Event notes(String? notes) => this(notes: notes);

  @override
  Event place(String? place) => this(place: place);

  @override
  Event recurrences(String? recurrences) => this(recurrences: recurrences);

  @override
  Event reminder(int? reminder) => this(reminder: reminder);

  @override
  Event startTime(DateTime? startTime) => this(startTime: startTime);

  @override
  Event url(String url) => this(url: url);

  @override
  Event user(int? user) => this(user: user);

  @override
  Event uuid(String uuid) => this(uuid: uuid);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Event(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Event(...).copyWith(id: 12, name: "My name")
  /// ````
  Event call({
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? date = const $CopyWithPlaceholder(),
    Object? endTime = const $CopyWithPlaceholder(),
    Object? eventName = const $CopyWithPlaceholder(),
    Object? eventPhotos = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? isEventDone = const $CopyWithPlaceholder(),
    Object? isParticipant = const $CopyWithPlaceholder(),
    Object? notes = const $CopyWithPlaceholder(),
    Object? place = const $CopyWithPlaceholder(),
    Object? recurrences = const $CopyWithPlaceholder(),
    Object? reminder = const $CopyWithPlaceholder(),
    Object? startTime = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? uuid = const $CopyWithPlaceholder(),
  }) {
    return Event(
      categoryId:
          categoryId == const $CopyWithPlaceholder() || categoryId == null
              ? _value.categoryId
              // ignore: cast_nullable_to_non_nullable
              : categoryId as int,
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as String?,
      endTime: endTime == const $CopyWithPlaceholder()
          ? _value.endTime
          // ignore: cast_nullable_to_non_nullable
          : endTime as DateTime?,
      eventName: eventName == const $CopyWithPlaceholder() || eventName == null
          ? _value.eventName
          // ignore: cast_nullable_to_non_nullable
          : eventName as String,
      eventPhotos:
          eventPhotos == const $CopyWithPlaceholder() || eventPhotos == null
              ? _value.eventPhotos
              // ignore: cast_nullable_to_non_nullable
              : eventPhotos as List<EventPhoto>,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      isEventDone:
          isEventDone == const $CopyWithPlaceholder() || isEventDone == null
              ? _value.isEventDone
              // ignore: cast_nullable_to_non_nullable
              : isEventDone as bool,
      isParticipant:
          isParticipant == const $CopyWithPlaceholder() || isParticipant == null
              ? _value.isParticipant
              // ignore: cast_nullable_to_non_nullable
              : isParticipant as bool,
      notes: notes == const $CopyWithPlaceholder()
          ? _value.notes
          // ignore: cast_nullable_to_non_nullable
          : notes as String?,
      place: place == const $CopyWithPlaceholder()
          ? _value.place
          // ignore: cast_nullable_to_non_nullable
          : place as String?,
      recurrences: recurrences == const $CopyWithPlaceholder()
          ? _value.recurrences
          // ignore: cast_nullable_to_non_nullable
          : recurrences as String?,
      reminder: reminder == const $CopyWithPlaceholder()
          ? _value.reminder
          // ignore: cast_nullable_to_non_nullable
          : reminder as int?,
      startTime: startTime == const $CopyWithPlaceholder()
          ? _value.startTime
          // ignore: cast_nullable_to_non_nullable
          : startTime as DateTime?,
      url: url == const $CopyWithPlaceholder() || url == null
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as int?,
      uuid: uuid == const $CopyWithPlaceholder() || uuid == null
          ? _value.uuid
          // ignore: cast_nullable_to_non_nullable
          : uuid as String,
    );
  }
}

extension $EventCopyWith on Event {
  /// Returns a callable class that can be used as follows: `instanceOfEvent.copyWith(...)` or like so:`instanceOfEvent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventCWProxy get copyWith => _$EventCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      eventName: json['event_name'] as String? ?? '',
      categoryId: json['category'] as int? ?? -1,
      eventPhotos: (json['event_photos'] as List<dynamic>?)
              ?.map((e) => EventPhoto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isParticipant: json['is_participant'] as bool? ?? false,
      id: json['id'] as int?,
      reminder: json['reminder'] as int?,
      place: json['place'] as String?,
      notes: json['notes'] as String?,
      user: json['user'] as int?,
      startTime: _dateFromJson(json['start_time']),
      endTime: _dateFromJson(json['end_time']),
      recurrences: _ignoreNoneWord(json['recurrences'] as String?),
      date: json['date'] as String?,
      isEventDone: json['status'] as bool? ?? false,
      url: json['url'] as String? ?? '',
      uuid: json['uuid'] as String? ?? '',
    );

Map<String, dynamic> _$EventToJson(Event instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['event_name'] = instance.eventName;
  val['start_time'] = _dateToJson(instance.startTime);
  val['end_time'] = _dateToJson(instance.endTime);
  writeNotNull('reminder', instance.reminder);
  val['url'] = instance.url;
  val['uuid'] = instance.uuid;
  writeNotNull('place', instance.place);
  writeNotNull('notes', instance.notes);
  writeNotNull('recurrences', instance.recurrences);
  writeNotNull('user', instance.user);
  val['category'] = instance.categoryId;
  val['status'] = instance.isEventDone;
  val['is_participant'] = instance.isParticipant;
  writeNotNull('date', instance.date);
  val['event_photos'] = instance.eventPhotos;
  return val;
}
