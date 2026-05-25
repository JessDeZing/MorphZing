// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NoteCWProxy {
  Note drawUrl(String? drawUrl);

  Note folderId(int? folderId);

  Note id(int? id);

  Note isChecked(bool isChecked);

  Note noteDescription(String? noteDescription);

  Note noteName(String? noteName);

  Note updatedTime(DateTime? updatedTime);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Note(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Note(...).copyWith(id: 12, name: "My name")
  /// ````
  Note call({
    String? drawUrl,
    int? folderId,
    int? id,
    bool? isChecked,
    String? noteDescription,
    String? noteName,
    DateTime? updatedTime,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNote.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNote.copyWith.fieldName(...)`
class _$NoteCWProxyImpl implements _$NoteCWProxy {
  final Note _value;

  const _$NoteCWProxyImpl(this._value);

  @override
  Note drawUrl(String? drawUrl) => this(drawUrl: drawUrl);

  @override
  Note folderId(int? folderId) => this(folderId: folderId);

  @override
  Note id(int? id) => this(id: id);

  @override
  Note isChecked(bool isChecked) => this(isChecked: isChecked);

  @override
  Note noteDescription(String? noteDescription) =>
      this(noteDescription: noteDescription);

  @override
  Note noteName(String? noteName) => this(noteName: noteName);

  @override
  Note updatedTime(DateTime? updatedTime) => this(updatedTime: updatedTime);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Note(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Note(...).copyWith(id: 12, name: "My name")
  /// ````
  Note call({
    Object? drawUrl = const $CopyWithPlaceholder(),
    Object? folderId = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? isChecked = const $CopyWithPlaceholder(),
    Object? noteDescription = const $CopyWithPlaceholder(),
    Object? noteName = const $CopyWithPlaceholder(),
    Object? updatedTime = const $CopyWithPlaceholder(),
  }) {
    return Note(
      drawUrl: drawUrl == const $CopyWithPlaceholder()
          ? _value.drawUrl
          // ignore: cast_nullable_to_non_nullable
          : drawUrl as String?,
      folderId: folderId == const $CopyWithPlaceholder()
          ? _value.folderId
          // ignore: cast_nullable_to_non_nullable
          : folderId as int?,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      isChecked: isChecked == const $CopyWithPlaceholder() || isChecked == null
          ? _value.isChecked
          // ignore: cast_nullable_to_non_nullable
          : isChecked as bool,
      noteDescription: noteDescription == const $CopyWithPlaceholder()
          ? _value.noteDescription
          // ignore: cast_nullable_to_non_nullable
          : noteDescription as String?,
      noteName: noteName == const $CopyWithPlaceholder()
          ? _value.noteName
          // ignore: cast_nullable_to_non_nullable
          : noteName as String?,
      updatedTime: updatedTime == const $CopyWithPlaceholder()
          ? _value.updatedTime
          // ignore: cast_nullable_to_non_nullable
          : updatedTime as DateTime?,
    );
  }
}

extension $NoteCopyWith on Note {
  /// Returns a callable class that can be used as follows: `instanceOfNote.copyWith(...)` or like so:`instanceOfNote.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NoteCWProxy get copyWith => _$NoteCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      id: json['id'] as int?,
      folderId: json['folder'] as int?,
      noteName: json['note_name'] as String?,
      noteDescription: json['description'] as String?,
      updatedTime: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      drawUrl: json['draw_url'] as String?,
      isChecked: json['checked'] as bool? ?? false,
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'folder': instance.folderId,
      'note_name': instance.noteName,
      'description': instance.noteDescription,
      'draw_url': instance.drawUrl,
      'updated_at': instance.updatedTime?.toIso8601String(),
      'checked': instance.isChecked,
    };
