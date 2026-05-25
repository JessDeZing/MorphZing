import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/dashboard/advice.dart';

part 'advice_list.g.dart';

@JsonSerializable()
class AdviceList {
  final List<Advice> results;

  AdviceList(this.results);

  factory AdviceList.fromJson(Map<String, dynamic> json) =>
      _$AdviceListFromJson(json);
}
