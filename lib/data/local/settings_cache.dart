import 'dart:convert';

import 'package:base_bloc/domain/model/setting/index.dart';

import 'index.dart';

abstract class SettingsCache {
  Future<bool> saveSetting(
      {required SettingModel setting, bool saveToLocal = true});
  Future<SettingModel?> getCachedSetting();
  Future<bool> removeCache();
  SettingModel? getSyncCachedSetting();
}

class SettingsCacheImpl extends SettingsCache {
  final LocalDataStorage _storage;
  SettingModel? _setting;

  SettingsCacheImpl(this._storage);


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
    return _setting;
  }

  @override
  Future<bool> saveSetting(
      {required SettingModel setting, bool saveToLocal = true}) async {
    if (saveToLocal) {
      await _storage.saveString(settingKey, jsonEncode(setting.toJson()));
    }
    _setting = setting;
    return true;
  }

  @override
  SettingModel? getSyncCachedSetting() {
    return SettingModel(items: _setting?.items ?? []);
  }
}