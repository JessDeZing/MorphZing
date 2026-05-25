// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_folder.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MoveFolderCWProxy {
  MoveFolder folderId(int? folderId);

  MoveFolder noteIds(List<int> noteIds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MoveFolder(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MoveFolder(...).copyWith(id: 12, name: "My name")
  /// ````
  MoveFolder call({
    int? folderId,
    List<int>? noteIds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMoveFolder.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMoveFolder.copyWith.fieldName(...)`
class _$MoveFolderCWProxyImpl implements _$MoveFolderCWProxy {
  final MoveFolder _value;

  const _$MoveFolderCWProxyImpl(this._value);

  @override
  MoveFolder folderId(int? folderId) => this(folderId: folderId);

  @override
  MoveFolder noteIds(List<int> noteIds) => this(noteIds: noteIds);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MoveFolder(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MoveFolder(...).copyWith(id: 12, name: "My name")
  /// ````
  MoveFolder call({
    Object? folderId = const $CopyWithPlaceholder(),
    Object? noteIds = const $CopyWithPlaceholder(),
  }) {
    return MoveFolder(
      folderId: folderId == const $CopyWithPlaceholder()
          ? _value.folderId
          // ignore: cast_nullable_to_non_nullable
          : folderId as int?,
      noteIds: noteIds == const $CopyWithPlaceholder() || noteIds == null
          ? _value.noteIds
          // ignore: cast_nullable_to_non_nullable
          : noteIds as List<int>,
    );
  }
}

extension $MoveFolderCopyWith on MoveFolder {
  /// Returns a callable class that can be used as follows: `instanceOfMoveFolder.copyWith(...)` or like so:`instanceOfMoveFolder.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MoveFolderCWProxy get copyWith => _$MoveFolderCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoveFolder _$MoveFolderFromJson(Map<String, dynamic> json) => MoveFolder(
      noteIds:
          (json['note_ids'] as List<dynamic>).map((e) => e as int).toList(),
      folderId: json['folder_id'] as int?,
    );

Map<String, dynamic> _$MoveFolderToJson(MoveFolder instance) =>
    <String, dynamic>{
      'note_ids': instance.noteIds,
      'folder_id': instance.folderId,
    };
