import 'dart:io';

class SignUpAfterSocialsProvider {
  SignUpAfterSocialsProvider({
    required this.secret,
    required this.fullName,
    required this.bio,
    required this.birthDate,
    required this.sex,
    required this.timeZone,
    required this.phone,
    required this.profileImage,
  });

  String secret;
  String fullName;
  String bio;
  String birthDate;
  String sex;
  String timeZone;
  String phone;
  File? profileImage;

  Map<String, dynamic> toJson() => {
        "secret": secret,
        "full_name": fullName,
        "bio": bio,
        "birth_date": birthDate,
        "sex": sex,
        "time_zone": timeZone,
        "phone": phone,
        "profile_image": profileImage,
      };
}
