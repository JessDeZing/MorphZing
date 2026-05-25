
import 'dart:convert';
class SocialAppleProvider {
  SocialAppleProvider({
    required this.authToken,
    required this.givenName,
  });

  String authToken;
  String givenName;

  Map<String, dynamic> toJson() => {
    "auth_token": authToken,
    "given_name": givenName,
  };
}
