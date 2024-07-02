import 'package:base_bloc/data/local/index.dart';
import 'package:base_bloc/data/remote/base/index.dart';
import 'package:base_bloc/domain/model/login/login_param.dart';
import 'package:base_bloc/domain/model/login/login_response.dart';
import 'package:base_bloc/domain/model/login/logout_param.dart';
import 'package:base_bloc/domain/repository/index.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationRepositoryImpl
    implements AuthenticationRepository, AuthenticationStatusBroadcaster {
  AuthenticationRepositoryImpl(
    this._tokenCache,
    this._authenticationApi,
    this._userDataCache,
    this._settingsCache,
    this._objectBoxDataSource,
    this._settingApi,
  );

  final TokenCache _tokenCache;
  final AuthenticationApi _authenticationApi;
  final UserDataCache _userDataCache;
  final SettingsCache _settingsCache;
  final ObjectBoxDataSource _objectBoxDataSource;
  final SettingApi _settingApi;

  @override
  Future<bool> isLogged() async {
    var tokenCached = await _tokenCache.getTokenCache();
    bool isLogged = (tokenCached?.token.isNotEmpty ?? false);

    _userStatusSubject.add(isLogged
        ? AuthenticationStatus.loggedIn
        : AuthenticationStatus.loggedOut);
    return isLogged;
  }

  @override
  Future<bool> logout(
      {required LogoutParam param, bool remoteLogout = false}) async {
    if (remoteLogout) {
      bool result = false;
      try {
        result = await _authenticationApi.logout(param: param);
      } finally {
        await clearCached();
      }
      return result;
    }
    await clearCached();
    return true;
  }

  @override
  Future<LoginResponse> login({required LoginParam params}) async {
    final response = await _authenticationApi.login(param: params);
    await _tokenCache.saveTokenCache(response.token);
    final setting = await _settingApi.fetchCustomerSetting();
    await _userDataCache.saveUserData(user: response.user);
    await _settingsCache.saveSetting(setting: setting);
    _userStatusSubject.add(AuthenticationStatus.loggedIn);
    return response;
  }

  Future clearCached() async {
    try {
      await Future.wait([
        _tokenCache.removeTokenCache(),
        _userDataCache.removeCache(),
        _settingsCache.removeCache(),
        _objectBoxDataSource.clearAllProduct(),
      ]);
    } catch (ex) {
      Logger().d('Error clearCached exception ${ex.toString()}');
    }
    _userStatusSubject.add(AuthenticationStatus.loggedOut);
  }

  final BehaviorSubject<AuthenticationStatus> _userStatusSubject =
      BehaviorSubject<AuthenticationStatus>();

  @override
  Stream<AuthenticationStatus> get statusStream =>
      _userStatusSubject.stream.distinct();

  @override
  AuthenticationStatus get currentStatus => _userStatusSubject.hasValue
      ? _userStatusSubject.value
      : AuthenticationStatus.none;
}
