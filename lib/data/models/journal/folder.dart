import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/journal/note.dart';

part 'folder.g.dart';

@CopyWith()
@JsonSerializable()
class Folder {
  Folder({
    this.id,
    this.name,
    this.noteCount,
    this.updatedTime,
    required this.isChecked,
    this.noteList,
  });

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'note_count')
  final int? noteCount;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedTime;
  @JsonKey(defaultValue: false, name: 'checked')
  final bool isChecked;
  @JsonKey(name: 'notes')
  final List<Note>? noteList;

  factory Folder.fromJson(Map<String, dynamic> json) => _$FolderFromJson(json);

  Map<String, dynamic> toJson() => _$FolderToJson(this);

  String getNoteCountLabel() {
    if (noteCount == null) {
      return '';
    }

    if (noteCount! <= 1) {
      return '$noteCount note';
    }

    return "$noteCount note";
  }
}
