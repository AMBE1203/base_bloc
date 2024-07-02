import 'package:base_bloc/data/local/index.dart';
import 'package:base_bloc/data/remote/base/index.dart';
import 'package:base_bloc/domain/model/setting/setting_model.dart';
import 'package:base_bloc/domain/repository/index.dart';

class SettingRepositoryImpl implements SettingRepository {
  SettingRepositoryImpl(
    this._settingApi,
    this._settingCache,
  );

  final SettingApi _settingApi;
  final SettingsCache _settingCache;

  @override
  Future<SettingModel> fetchCustomerSetting() async {
    final setting = await _settingApi.fetchCustomerSetting();
    await _settingCache.saveSetting(setting: setting);
    return setting;
  }
}
