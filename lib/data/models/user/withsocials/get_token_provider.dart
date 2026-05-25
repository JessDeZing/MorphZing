class GetTokenProvider {
  GetTokenProvider({
    required this.refresh,
    required this.access,
  });

  String? refresh;
  String access;

  factory GetTokenProvider.fromJson(Map<String, dynamic> json) =>
      GetTokenProvider(
        refresh: json["refresh"],
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
      };
}
