import 'dart:convert';

UserVerification userVerificationFromJson(String str) => UserVerification.fromJson(json.decode(str));

String userVerificationToJson(UserVerification data) => json.encode(data.toJson());

class UserVerification {
  UserVerification({
    required this.phone,
    required this.code,
  });

  String phone;
  String code;

  factory UserVerification.fromJson(Map<String, dynamic> json) => UserVerification(
    phone: json["phone"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "code": code,
  };
}


UserVerifiedSuccess userVerifiedSuccessFromJson(String str) => UserVerifiedSuccess.fromJson(json.decode(str));

String userVerifiedSuccessToJson(UserVerifiedSuccess data) => json.encode(data.toJson());

class UserVerifiedSuccess {
  UserVerifiedSuccess({
    required this.success,
    required this.secret,
    required this.message,
  });

  bool success;
  String secret;
  String message;

  factory UserVerifiedSuccess.fromJson(Map<String, dynamic> json) => UserVerifiedSuccess(
    success: json["success"],
    secret: json["secret"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "secret": secret,
    "message": message,
  };
}
