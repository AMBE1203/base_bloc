abstract class LocalDataStorage {
  ///  save method
  Future<bool> saveInt(String key, int value);

  Future<bool> saveString(String key, String value);

  Future<bool> saveDouble(String key, double value);

  Future<bool> saveBool(String key, bool value);

  Future<bool> saveListString(String key, List<String> value);

  /// get method
  Future<int?> getInt(String key);

  Future<String?> getString(String key);

  Future<double?> getDouble(String key);

  Future<bool?> getBool(String key);

  /// remove method
  Future<bool> remove(String key);

  Future<bool> removeAll();
}
