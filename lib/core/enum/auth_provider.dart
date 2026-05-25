import 'package:json_annotation/json_annotation.dart';

enum AuthProvider {
  @JsonValue('phone')
  phone,
  @JsonValue('social')
  social,
  @JsonValue('email')
  email,
}
