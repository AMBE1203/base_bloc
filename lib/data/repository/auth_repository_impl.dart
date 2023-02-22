import 'package:lazi_chat/data/local/index.dart';
import 'package:lazi_chat/data/remote/base/index.dart';
import 'package:lazi_chat/domain/repository/index.dart';
import 'package:lazi_chat/presentation/utils/push_notification_handler.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;
  final TokenCache _tokenCache;
  final PushNotificationHandler _pushNotificationHandler;

  AuthRepositoryImpl(
    this._authApi,
    this._tokenCache,
    this._pushNotificationHandler,
  );

  @override
  Future<bool> isLogged() async {
    var tokenCached = await _tokenCache.getCachedToken();
    bool isLogged = (tokenCached?.token.isNotEmpty ?? false);
    return isLogged;
  }

  @override
  Future<bool> logout({bool remoteLogout = false}) async {
    if (remoteLogout) {
      bool result = false;
      try {
        result = await _authApi.logout();
      } finally {
        clearCached();
      }
      return result;
    }
    await clearCached();
    return true;
  }

  Future clearCached() async {
    await Future.wait([
      _tokenCache.removeCache(),
      _pushNotificationHandler.clear(),
    ]);
  }
}
