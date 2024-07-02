import 'index.dart';

abstract class SystemCache {
  Future<bool> get hasReadTutorial;

  Future<void> setReadTutorial({required bool isRead});

  Future<bool> get hasAcceptPolicy;

  Future<void> setAcceptPolicy({required bool isAccept});
}

class SystemCacheImpl extends SystemCache {
  final LocalDataStorage _storage;

  SystemCacheImpl(this._storage);

  @override
  Future<bool> get hasReadTutorial async {
    var hasRead = await _storage.getBool(readTutorialStatusKey) ?? false;
    return hasRead;
  }

  @override
  Future<void> setReadTutorial({required bool isRead}) async {
    await _storage.saveBool(readTutorialStatusKey, isRead);
  }

  @override
  Future<bool> get hasAcceptPolicy async {
    var hasRead = await _storage.getBool(acceptPolicyKey) ?? false;
    return hasRead;
  }

  @override
  Future<void> setAcceptPolicy({required bool isAccept}) async {
    await _storage.saveBool(acceptPolicyKey, isAccept);
  }
}
