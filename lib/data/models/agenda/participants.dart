import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/agenda/participant.dart';

part 'participants.g.dart';

@CopyWith()
@JsonSerializable()
class Participants {
  final List<Participant> results;

  Participants({required this.results});

  factory Participants.fromJson(Map<String, dynamic> json) => _$ParticipantsFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantsToJson(this);
}
