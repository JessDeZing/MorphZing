import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:morphzing/data/api/auth_api.dart';
import 'package:morphzing/data/models/user/change_password_response.dart';
import 'package:morphzing/data/models/user/change_phone_provider.dart';
import 'package:morphzing/data/models/user/check_password_provider.dart';
import 'package:morphzing/data/models/user/login_provider.dart';
import 'package:morphzing/data/models/user/recovery_password_provider.dart';
import 'package:morphzing/data/models/user/reset_password_provider.dart';
import 'package:morphzing/data/models/user/sign_up_provider.dart';
import 'package:morphzing/data/models/user/social.dart';
import 'package:morphzing/data/models/user/user_verify_provider.dart';
import 'package:morphzing/data/models/user/withsocials/get_token_provider.dart';
import 'package:morphzing/data/models/user/withsocials/social_facebook_provider.dart';
import 'package:morphzing/data/models/verification/phone_verification_provider.dart';

@singleton
class AuthRepository {
  final AuthApi _authApi;

  AuthRepository(this._authApi);

  Future<void> auth(PhoneVerificationPost phoneVerificationPost) async {
    return await _authApi.auth(phoneVerificationPost: phoneVerificationPost);
  }

  Future<void> recoveryPassword(RecoveryPasswordProvider recoveryPasswordProvider) async {
    return await _authApi.recoveryPassword(recoveryPasswordProvider: recoveryPasswordProvider);
  }

  Future<UserVerifiedSuccess> verification(UserVerification userVerification) async {
    return await _authApi.verification(userVerification: userVerification);
  }

  Future<void> resetPassword(ResetPasswordProvider resetPasswordProvider) async {
    return await _authApi.resetPassword(resetPasswordProvider: resetPasswordProvider);
  }

  Future<ChangePasswordResponse> changePassword(CheckPasswordProvider checkPasswordProvider) async {
    return await _authApi.changePassword(checkPasswordProvider: checkPasswordProvider);
  }

  Future<GetTokenProvider> login(LoginProvider loginProvider) async {
    return await _authApi.login(loginProvider: loginProvider);
  }

  Future<GetTokenProvider> signUpPhone(
      {required String secret,
      required String fullName,
      required String bio,
      required String birthDate,
      required String sex,
      required String timeZone,
      String? email,
      String? phone,
      String? password,
      File? file}) async {
    return await _authApi.signUpPhone(
        secret: secret,
        fullName: fullName,
        bio: bio,
        birthDate: birthDate,
        sex: sex,
        timeZone: timeZone,
        email: email,
        phone: phone,
        password: password,
        file: file);
  }

  Future<GetTokenProvider> signUpSocial(
      {required String secret,
      required String fullName,
      required String bio,
      required String birthDate,
      required String sex,
      required String timeZone,
      String? email,
      String? phone,
      String? password,
      File? file}) async {
    return await _authApi.signUpSocial(
        secret: secret,
        fullName: fullName,
        bio: bio,
        birthDate: birthDate,
        sex: sex,
        timeZone: timeZone,
        email: email,
        phone: phone,
        password: password,
        file: file);
  }

  Future<Social> socialGoogle(SocialFacebookProvider provide) async {
    return await _authApi.socialGoogle(socialFacebookProvider: provide);
  }

  Future<Social> socialApple(SocialFacebookProvider provide) async {
    return await _authApi.socialApple(socialFacebookProvider: provide);
  }

  Future<Social> socialFacebook(SocialFacebookProvider provide) async {
    return await _authApi.socialFacebook(socialFacebookProvider: provide);
  }
}
