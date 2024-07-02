import 'dart:convert';

import 'package:base_bloc/domain/model/index.dart';

import 'index.dart';

abstract class UserDataCache {
  Future<bool> saveUserData({required UserDataModel user});

  Future<UserDataModel?> getCacheUser();

  UserDataModel? getSyncCacheUser();

  Future<bool> removeCache();

  Future<void> loadCacheData();

  Future<bool> hasFirstLogin();

  Future<void> setFirstLogin({required bool firstLogin});
}

class UserDataCacheImpl implements UserDataCache {
  final LocalDataStorage _storage;
  UserDataModel? _cachedUser;

  UserDataCacheImpl(this._storage);

  @override
  Future<UserDataModel?> getCacheUser() async {
    var userString = await _storage.getString(userDataKey);
    if (userString != null && userString.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(userString);
      final data = UserDataModel.fromJson(json);
      return data;
    }
    return null;
  }

  @override
  UserDataModel? getSyncCacheUser() {
    return _cachedUser;
  }

  @override
  Future<bool> hasFirstLogin() async {
    return (await _storage.getBool(isFirstLoginKey)) ?? false;
  }

  @override
  Future<void> loadCacheData() async {
    _cachedUser = await getCacheUser();
  }

  @override
  Future<bool> removeCache() async {
    await Future.wait([
      _storage.remove(userDataKey),
      _storage.remove(isFirstLoginKey),
    ]);

    _cachedUser = null;
    return true;
  }

  @override
  Future<bool> saveUserData({required UserDataModel user}) async {
    await _storage.saveString(userDataKey, jsonEncode(user.toJson()));
    _cachedUser = user;
    return true;
  }

  @override
  Future<void> setFirstLogin({required bool firstLogin}) async {
    await _storage.saveBool(isFirstLoginKey, firstLogin);
  }
}
