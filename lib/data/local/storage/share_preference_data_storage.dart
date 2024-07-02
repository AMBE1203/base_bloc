import 'package:shared_preferences/shared_preferences.dart';
import 'local_data_storage.dart';

class SharePreferenceStorageImpl extends LocalDataStorage {
  SharePreferenceStorageImpl();

  /// save method

  @override
  Future<bool> saveInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (await preferences.setInt(key, value));
  }

  @override
  Future<bool> saveString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (await preferences.setString(key, value));
  }

  @override
  Future<bool> saveDouble(String key, double value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (await preferences.setDouble(key, value));
  }

  @override
  Future<bool> saveBool(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (await preferences.setBool(key, value));
  }

  @override
  Future<bool> saveListString(String key, List<String> value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (await preferences.setStringList(key, value));
  }

  /// get method
  @override
  Future<int?> getInt(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getInt(key));
  }

  @override
  Future<String?> getString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  @override
  Future<double?> getDouble(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getDouble(key));
  }

  @override
  Future<bool> getBool(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final res = preferences.getBool(key);
    return res ?? false;
  }

  /// remove method
  @override
  Future<bool> remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(key);
  }

  @override
  Future<bool> removeAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.clear();
  }
}
