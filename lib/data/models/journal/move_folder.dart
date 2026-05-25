import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move_folder.g.dart';

@CopyWith()
@JsonSerializable()
class MoveFolder {
  MoveFolder({
    required this.noteIds,
    this.folderId,
  });

  @JsonKey(name: 'note_ids')
  final List<int> noteIds;
  @JsonKey(name: 'folder_id')
  final int? folderId;

  factory MoveFolder.fromJson(Map<String, dynamic> json) => _$MoveFolderFromJson(json);

  Map<String, dynamic> toJson() => _$MoveFolderToJson(this);
}
