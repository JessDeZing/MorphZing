// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FolderCWProxy {
  Folder id(int? id);

  Folder isChecked(bool isChecked);

  Folder name(String? name);

  Folder noteCount(int? noteCount);

  Folder noteList(List<Note>? noteList);

  Folder updatedTime(DateTime? updatedTime);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Folder(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Folder(...).copyWith(id: 12, name: "My name")
  /// ````
  Folder call({
    int? id,
    bool? isChecked,
    String? name,
    int? noteCount,
    List<Note>? noteList,
    DateTime? updatedTime,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFolder.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFolder.copyWith.fieldName(...)`
class _$FolderCWProxyImpl implements _$FolderCWProxy {
  final Folder _value;

  const _$FolderCWProxyImpl(this._value);

  @override
  Folder id(int? id) => this(id: id);

  @override
  Folder isChecked(bool isChecked) => this(isChecked: isChecked);

  @override
  Folder name(String? name) => this(name: name);

  @override
  Folder noteCount(int? noteCount) => this(noteCount: noteCount);

  @override
  Folder noteList(List<Note>? noteList) => this(noteList: noteList);

  @override
  Folder updatedTime(DateTime? updatedTime) => this(updatedTime: updatedTime);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Folder(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Folder(...).copyWith(id: 12, name: "My name")
  /// ````
  Folder call({
    Object? id = const $CopyWithPlaceholder(),
    Object? isChecked = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? noteCount = const $CopyWithPlaceholder(),
    Object? noteList = const $CopyWithPlaceholder(),
    Object? updatedTime = const $CopyWithPlaceholder(),
  }) {
    return Folder(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      isChecked: isChecked == const $CopyWithPlaceholder() || isChecked == null
          ? _value.isChecked
          // ignore: cast_nullable_to_non_nullable
          : isChecked as bool,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      noteCount: noteCount == const $CopyWithPlaceholder()
          ? _value.noteCount
          // ignore: cast_nullable_to_non_nullable
          : noteCount as int?,
      noteList: noteList == const $CopyWithPlaceholder()
          ? _value.noteList
          // ignore: cast_nullable_to_non_nullable
          : noteList as List<Note>?,
      updatedTime: updatedTime == const $CopyWithPlaceholder()
          ? _value.updatedTime
          // ignore: cast_nullable_to_non_nullable
          : updatedTime as DateTime?,
    );
  }
}

extension $FolderCopyWith on Folder {
  /// Returns a callable class that can be used as follows: `instanceOfFolder.copyWith(...)` or like so:`instanceOfFolder.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FolderCWProxy get copyWith => _$FolderCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Folder _$FolderFromJson(Map<String, dynamic> json) => Folder(
      id: json['id'] as int?,
      name: json['name'] as String?,
      noteCount: json['note_count'] as int?,
      updatedTime: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isChecked: json['checked'] as bool? ?? false,
      noteList: (json['notes'] as List<dynamic>?)
          ?.map((e) => Note.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FolderToJson(Folder instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'note_count': instance.noteCount,
      'updated_at': instance.updatedTime?.toIso8601String(),
      'checked': instance.isChecked,
      'notes': instance.noteList,
    };
