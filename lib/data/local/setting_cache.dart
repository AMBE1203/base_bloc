import 'dart:convert';
import 'package:lazi_chat/core/utils/consts.dart';
import 'package:lazi_chat/domain/model/index.dart';

import 'index.dart';

abstract class SettingCache {
  Future<bool> saveSetting({required SettingModel setting});

  Future<SettingModel?> getCachedSetting();

  Future<bool> removeCache();

  SettingModel? getSyncCachedSetting();
}

class SettingCacheImpl extends SettingCache {
  final LocalDataStorage _storage;
  SettingModel? _setting;

  SettingCacheImpl(this._storage);

  @override
  Future<bool> removeCache() async {
    await _storage.remove(settingKey);
    _setting = null;
    return true;
  }

  @override
  Future<SettingModel?> getCachedSetting() async {
    var userString = await _storage.getString(settingKey);
    if (userString != null && userString.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(userString);
      _setting = SettingModel.fromJson(json);
      return SettingModel.fromJson(json);
    }
    return null;
  }

  @override
  Future<bool> saveSetting({required SettingModel setting}) async {
    await _storage.saveString(settingKey, jsonEncode(setting.toJson()));
    _setting = setting;
    return true;
  }

  @override
  SettingModel? getSyncCachedSetting() {
    return SettingModel(items: _setting?.items ?? []);
  }
}
