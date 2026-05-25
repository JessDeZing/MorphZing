import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/dashboard/single_agenda_name.dart';

part 'agenda_names.g.dart';

@JsonSerializable()
class AgendaNames {
  final List<SingleAgendaName> results;

  AgendaNames({required this.results});

  factory AgendaNames.fromJson(Map<String, dynamic> json) =>
      _$AgendaNamesFromJson(json);
}
