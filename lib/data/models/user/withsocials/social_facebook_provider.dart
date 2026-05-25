class SocialFacebookProvider {
  SocialFacebookProvider({
    required this.authToken,
    required this.email,
  });

  String? authToken;
  String? email;

  Map<String, dynamic> toJson() => {
        "auth_token": authToken,
        "email": email,
      };
}
