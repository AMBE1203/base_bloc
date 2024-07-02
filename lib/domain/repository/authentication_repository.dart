import 'package:base_bloc/domain/model/index.dart';

enum AuthenticationStatus {
  loggedIn,
  loggedOut,
  none,
}

abstract class AuthenticationStatusBroadcaster {
  Stream<AuthenticationStatus> get statusStream;

  AuthenticationStatus get currentStatus;
}

abstract class AuthenticationRepository {
  Future<bool> isLogged();

  Future<bool> logout({
    required LogoutParam param,
    bool remoteLogout = false,
  });

  Future<LoginResponse> login({
    required LoginParam params,
  });
}
