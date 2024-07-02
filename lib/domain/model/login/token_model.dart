import 'package:base_bloc/core/utils/index.dart';

class TokenModel {
  String token;
  String refreshToken;
  bool passwordExpired;

  TokenModel({
    required this.token,
    required this.refreshToken,
    required this.passwordExpired,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'] ?? '';
    final refreshToken = json['refreshToken'] ?? '';
    final passwordExpired =
        json['passwordExpired']?.toString().toBoolValue() ?? false;
    return TokenModel(
      token: token,
      refreshToken: refreshToken,
      passwordExpired: passwordExpired,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "token": token,
      "refreshToken": refreshToken,
      "passwordExpired": passwordExpired,
    };
    return data;
  }
}
