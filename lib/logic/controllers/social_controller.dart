import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/user/social.dart';
import 'package:morphzing/data/models/user/withsocials/social_facebook_provider.dart';
import 'package:morphzing/data/repositories/auth/auth_repository.dart';
import 'package:morphzing/data/repositories/auth/token_repository.dart';
import 'package:morphzing/data/repositories/user/user_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/pages/screens/auth/phone/phone_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialController extends GetxController {
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final TokenRepository _tokenRepository = getIt<TokenRepository>();
  final UserRepository _userRepository = getIt<UserRepository>();
  final AppController _appController = Get.find<AppController>();

  Future<void> socialGoogle() async {
    print('sasas');
    GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    print(googleSignInAccount.toString());
    if (googleSignInAccount == null) return;

    UserCredential? userCredential;
    await googleSignInAccount.authentication
        .then((googleSignInAuthentication) {
          return GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
        })
        .then((oAuthCredential) =>
            FirebaseAuth.instance.signInWithCredential(oAuthCredential))
        .then((userCredentialValue) {
          userCredential = userCredentialValue;
          if (userCredentialValue.user == null) {
            return Future.error(_getSocialUserNotFoundMessage());
          }

          return userCredentialValue.user!.getIdToken();
        })
        .then((token) {
          User? user = userCredential!.user;
          AdditionalUserInfo? info = userCredential!.additionalUserInfo;
          String? email = googleSignInAccount.email;

          if (user != null && user.email != null) {
            email = user.email;
          } else if (info != null) {
            email = info.profile?['email'];
          }
          return _authRepository.socialGoogle(
              SocialFacebookProvider(authToken: token, email: email));
        })
        .then((response) => _navigateScreen(social: response))
        .onError((error, stackTrace) {
          print(error.toString());
          return Future.error(error.toString());
        });
  }

  Future<void> socialApple() async {
    UserCredential? userCredential;
    AuthorizationCredentialAppleID? appleCredential;
    await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.fullName,
      AppleIDAuthorizationScopes.email,
    ])
        .then((value) {
          appleCredential = value;
          return OAuthProvider("apple.com")
              .credential(idToken: value.identityToken);
        })
        .then((oAuthCredential) =>
            FirebaseAuth.instance.signInWithCredential(oAuthCredential))
        .then((userCredentialValue) {
          userCredential = userCredentialValue;
          if (userCredentialValue.user == null)
            return Future.error(_getSocialUserNotFoundMessage());
          return userCredentialValue.user!.getIdToken();
        })
        .then((token) {
          AdditionalUserInfo? info = userCredential!.additionalUserInfo;
          String? email = appleCredential!.email;
          User? user = userCredential!.user;

          if (user != null && user.email != null) {
            email = user.email;
          } else if (info != null) {
            email = info.profile?['email'];
          }

          return _authRepository.socialApple(
              SocialFacebookProvider(authToken: token, email: email));
        })
        .then((response) => _navigateScreen(social: response))
        .onError((error, stackTrace) {
          if (error is SignInWithAppleAuthorizationException) {
            if ((error).code == AuthorizationErrorCode.canceled)
              return Future.value(null);
          }
          return Future.error(error.toString());
        });
  }

  Future<void> socialFacebook() async {
    await FacebookAuth.instance.logOut();
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    User? user = userCredential.user;
    if (user == null) {
      if (userCredential.user == null)
        return Future.error(_getSocialUserNotFoundMessage());
    }

    String? token = await userCredential.user?.getIdToken();
    AdditionalUserInfo? info = userCredential.additionalUserInfo;
    String? email;

    if (user != null && user.email != null) {
      email = user.email;
    } else if (info != null) {
      email = info.profile?['email'];
    }

    _authRepository
        .socialFacebook(SocialFacebookProvider(authToken: token, email: email))
        .then((response) {
      _navigateScreen(social: response);
    }).onError((error, stackTrace) {
      return Future.error(error.toString());
    });
  }

  Future<void> _navigateScreen({required Social social}) async {
    if (social.secretKey != null) {
      Get.toNamed(
        phoneRoute,
        arguments: PhoneScreenParam(
          secretKey: social.secretKey!,
          email: social.email,
        ),
      );
    } else {
      await _tokenRepository
          .saveToken(social.accessToken!, social.refreshToken!)
          .then((value) => _userRepository.getUserInfo())
          .then((value) {
        _appController.user = value;
      }).then((value) {
        Get.toNamed(homeRoute);
      }).onError((error, stackTrace) {
        return Future.error(error.toString());
      });
    }
  }

  String _getSocialUserNotFoundMessage() => 'Social User not found';
}
