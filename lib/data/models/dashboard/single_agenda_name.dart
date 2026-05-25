import 'package:json_annotation/json_annotation.dart';

part 'single_agenda_name.g.dart';

@JsonSerializable()
class SingleAgendaName {
  final int id;
  final String name;

  SingleAgendaName({
    required this.id,
    required this.name,
  });

  factory SingleAgendaName.fromJson(Map<String, dynamic> json) =>
      _$SingleAgendaNameFromJson(json);
}
