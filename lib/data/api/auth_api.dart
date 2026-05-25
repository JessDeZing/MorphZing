import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:morphzing/core/constants/urls.dart';
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
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@singleton
@RestApi()
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(@Named('UnauthorizedClient') Dio dio) = _AuthApi;

  @POST(USER_AUTH)
  Future<void> auth({@Body() required PhoneVerificationPost phoneVerificationPost});

  @POST(USER_FORGOT_PASSWORD)
  Future<void> recoveryPassword({@Body() required RecoveryPasswordProvider recoveryPasswordProvider});

  @POST(USER_VERIFY)
  Future<UserVerifiedSuccess> verification({@Body() required UserVerification userVerification});

  @POST(USER_RESET_PASSWORD)
  Future<void> resetPassword({@Body() required ResetPasswordProvider resetPasswordProvider});

  @POST(USER_CHECK_PASSWORD)
  Future<ChangePasswordResponse> changePassword({@Body() required CheckPasswordProvider checkPasswordProvider});

  @POST(USER_LOGIN)
  Future<GetTokenProvider> login({@Body() required LoginProvider loginProvider});

  @POST(USER_SIGNUP_SOCIALS)
  @MultiPart()
  Future<GetTokenProvider> signUpSocial({
    @Part(name: 'secret') required String secret,
    @Part(name: 'full_name') required String fullName,
    @Part(name: 'bio') required String bio,
    @Part(name: 'birth_date') required String birthDate,
    @Part(name: 'sex') required String sex,
    @Part(name: 'time_zone') required String timeZone,
    @Part(name: 'email') String? email,
    @Part(name: 'phone') String? phone,
    @Part(name: 'password') String? password,
    @Part(name: 'profile_image') File? file,
  });

  @POST(USER_SIGNUP)
  @MultiPart()
  Future<GetTokenProvider> signUpPhone({
    @Part(name: 'secret') required String secret,
    @Part(name: 'full_name') required String fullName,
    @Part(name: 'bio') required String bio,
    @Part(name: 'birth_date') required String birthDate,
    @Part(name: 'sex') required String sex,
    @Part(name: 'time_zone') required String timeZone,
    @Part(name: 'email') String? email,
    @Part(name: 'phone') String? phone,
    @Part(name: 'password') String? password,
    @Part(name: 'profile_image') File? file,
  });

  @POST(USER_LOGIN_GOOGLE)
  Future<Social> socialGoogle({@Body() required SocialFacebookProvider socialFacebookProvider});

  @POST(USER_LOGIN_APPLE)
  Future<Social> socialApple({@Body() required SocialFacebookProvider socialFacebookProvider});

  @POST(USER_LOGIN_FB)
  Future<Social> socialFacebook({@Body() required SocialFacebookProvider socialFacebookProvider});
}
