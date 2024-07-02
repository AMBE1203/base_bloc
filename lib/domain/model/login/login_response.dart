import 'package:base_bloc/domain/model/index.dart';

class LoginResponse {
  UserDataModel user;
  TokenModel token;

  LoginResponse({
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final token = TokenModel.fromJson(json);
    final userData = UserDataModel.fromJson(json['customerAccount'] ?? {});

    return LoginResponse(
      user: userData,
      token: token,
    );
  }
}
