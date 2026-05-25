import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@CopyWith()
@JsonSerializable()
class Note {
  Note({
    this.id,
    this.folderId,
    this.noteName,
    this.noteDescription,
    this.updatedTime,
    this.drawUrl,
    required this.isChecked,
  });

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'folder')
  final int? folderId;
  @JsonKey(name: 'note_name')
  final String? noteName;
  @JsonKey(name: 'description')
  final String? noteDescription;
  @JsonKey(name: 'draw_url')
  final String? drawUrl;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedTime;
  @JsonKey(defaultValue: false, name: 'checked')
  final bool isChecked;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
