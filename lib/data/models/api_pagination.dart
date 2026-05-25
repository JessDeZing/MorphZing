import 'package:json_annotation/json_annotation.dart';

part 'api_pagination.g.dart';

@JsonSerializable(
  explicitToJson: true,
  genericArgumentFactories: true,
)
class ApiPagination<T> {
  @JsonKey(name: 'count')
  final int total;
  @JsonKey(name: 'results')
  final List<T> data;

  ApiPagination({
    required this.total,
    required this.data,
  });

  factory ApiPagination.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiPaginationFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
    ApiPagination<T> instance,
    Object? Function(T value) toJsonT,
  ) =>
      _$ApiPaginationToJson(this, toJsonT);

  bool isLastPage() {
    return this.total == this.data.length;
  }
}
