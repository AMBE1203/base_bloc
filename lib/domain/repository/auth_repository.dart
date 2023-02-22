abstract class AuthRepository {
  Future<bool> isLogged();

  Future<bool> logout({bool remoteLogout = false});
}
