import 'package:json_annotation/json_annotation.dart';

part 'purchase_template_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PurchaseTemplateRequest {
  const PurchaseTemplateRequest({
    required this.premiumTemplate,
    this.isPurchased = true,
  });

  final int premiumTemplate;
  final bool isPurchased;

  factory PurchaseTemplateRequest.fromJson(Map<String, dynamic> json) =>
      _$PurchaseTemplateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseTemplateRequestToJson(this);
}
