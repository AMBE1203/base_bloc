class LoginParam {
  String? loginId;
  String? passwords;

  LoginParam({
    this.loginId,
    this.passwords,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "passwords": passwords,
      "loginId": loginId
    };
    return data;
  }
}
