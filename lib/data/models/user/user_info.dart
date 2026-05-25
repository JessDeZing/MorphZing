/*
{"id":4,"last_login":null,"is_superuser":false,"created_at":"2022-11-26T18:45:46.816235Z","updated_at":"2022-11-26T18:45:46.816262Z","time_zone":null,"email":"sdffds@fds.dfs","phone":"11111222222","full_name":"fsddsfsd","bio":"fsdfdsf","profile_image":null,"birth_date":"2022-11-09","sex":"M","auth_provider":"phone","type":"user","status":"active","payment_status":"free","is_staff":false,"is_active":true,"date_joined":"2022-11-26T18:45:46.618904Z","groups":[],"user_permissions":[]}
*/

// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  UserInfo({
    this.id,
    this.lastLogin,
    this.isSuperuser,
    this.createdAt,
    this.updatedAt,
    this.timeZone,
    this.email,
    this.phone,
    this.fullName,
    this.bio,
    this.profileImage,
    this.imageUrl,
    this.birthDate,
    this.sex,
    this.authProvider,
    this.type,
    this.status,
    this.paymentStatus,
    this.isStaff,
    this.isActive,
    this.dateJoined,
    this.groups,
    this.userPermissions,
    this.image,
  });

  int? id;
  String? lastLogin;
  bool? isSuperuser;
  File? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic timeZone;
  String? email;
  String? phone;
  String? fullName;
  String? bio;
  String? imageUrl;
  String? profileImage;
  DateTime? birthDate;
  String? sex;
  String? authProvider;
  String? type;
  String? status;
  String? paymentStatus;
  bool? isStaff;
  bool? isActive;
  DateTime? dateJoined;
  List? groups;
  List<dynamic>? userPermissions;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        lastLogin: json["last_login"],
        isSuperuser: json["is_superuser"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        timeZone: json["time_zone"],
        email: json["email"],
        phone: json["phone"],
        fullName: json["full_name"],
        bio: json["bio"],
        profileImage: json["profile_image"],
        imageUrl: json["image_url"],
        birthDate: DateTime.parse(json["birth_date"]),
        sex: json["sex"],
        authProvider: json["auth_provider"],
        type: json["type"],
        status: json["status"],
        paymentStatus: json["payment_status"],
        isStaff: json["is_staff"],
        isActive: json["is_active"],
        dateJoined: DateTime.parse(json["date_joined"]),
        groups: List<dynamic>.from(json["groups"].map((x) => x)),
        userPermissions: List<dynamic>.from(json["user_permissions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "last_login": lastLogin,
        "is_superuser": isSuperuser,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "time_zone": timeZone,
        "email": email,
        "phone": phone,
        "full_name": fullName,
        "bio": bio,
        "profile_image": profileImage,
        "birth_date":
            "${birthDate?.year.toString().padLeft(4, '0')}-${birthDate?.month.toString().padLeft(2, '0')}-${birthDate?.day.toString().padLeft(2, '0')}",
        "sex": sex,
        "auth_provider": authProvider,
        "type": type,
        "status": status,
        "payment_status": paymentStatus,
        "is_staff": isStaff,
        "is_active": isActive,
        "date_joined": dateJoined?.toIso8601String(),
        "groups": List<dynamic>.from(groups!.map((x) => x)),
        "user_permissions": List<dynamic>.from(userPermissions!.map((x) => x)),
      };
}

UserInfoSaveModel userInfoSaveModelFromJson(String str) => UserInfoSaveModel.fromJson(json.decode(str));

String userInfoSaveModelToJson(UserInfoSaveModel data) => json.encode(data.toJson());

class UserInfoSaveModel {
  UserInfoSaveModel({
    this.id,
    this.timeZone,
    this.email,
    this.phone,
    this.fullName,
    this.bio,
    this.birthDate,
    this.sex,
    this.profileImage,
  });

  int? id;
  File? profileImage;
  dynamic timeZone;
  String? email;
  String? phone;
  String? fullName;
  String? bio;
  DateTime? birthDate;
  String? sex;

  factory UserInfoSaveModel.fromJson(Map<String, dynamic> json) => UserInfoSaveModel(
        id: json["id"],
        timeZone: json["time_zone"],
        email: json["email"],
        phone: json["phone"],
        fullName: json["full_name"],
        bio: json["bio"],
        profileImage: json["profile_image"],
        birthDate: DateTime.parse(json["birth_date"]),
        sex: json["sex"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "full_name": fullName,
        "time_zone": timeZone,
        "bio": bio,
        "profile_image": profileImage,
        "birth_date":
            "${birthDate?.year.toString().padLeft(4, '0')}-${birthDate?.month.toString().padLeft(2, '0')}-${birthDate?.day.toString().padLeft(2, '0')}",
        "sex": sex,
      };
}
