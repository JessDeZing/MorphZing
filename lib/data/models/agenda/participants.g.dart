// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participants.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ParticipantsCWProxy {
  Participants results(List<Participant> results);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Participants(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Participants(...).copyWith(id: 12, name: "My name")
  /// ````
  Participants call({
    List<Participant>? results,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfParticipants.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfParticipants.copyWith.fieldName(...)`
class _$ParticipantsCWProxyImpl implements _$ParticipantsCWProxy {
  final Participants _value;

  const _$ParticipantsCWProxyImpl(this._value);

  @override
  Participants results(List<Participant> results) => this(results: results);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Participants(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Participants(...).copyWith(id: 12, name: "My name")
  /// ````
  Participants call({
    Object? results = const $CopyWithPlaceholder(),
  }) {
    return Participants(
      results: results == const $CopyWithPlaceholder() || results == null
          ? _value.results
          // ignore: cast_nullable_to_non_nullable
          : results as List<Participant>,
    );
  }
}

extension $ParticipantsCopyWith on Participants {
  /// Returns a callable class that can be used as follows: `instanceOfParticipants.copyWith(...)` or like so:`instanceOfParticipants.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ParticipantsCWProxy get copyWith => _$ParticipantsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participants _$ParticipantsFromJson(Map<String, dynamic> json) => Participants(
      results: (json['results'] as List<dynamic>)
          .map((e) => Participant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ParticipantsToJson(Participants instance) =>
    <String, dynamic>{
      'results': instance.results,
    };
