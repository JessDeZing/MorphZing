// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_template_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseTemplateRequest _$PurchaseTemplateRequestFromJson(
        Map<String, dynamic> json) =>
    PurchaseTemplateRequest(
      premiumTemplate: json['premium_template'] as int,
      isPurchased: json['is_purchased'] as bool? ?? true,
    );

Map<String, dynamic> _$PurchaseTemplateRequestToJson(
        PurchaseTemplateRequest instance) =>
    <String, dynamic>{
      'premium_template': instance.premiumTemplate,
      'is_purchased': instance.isPurchased,
    };
