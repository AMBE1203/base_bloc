import 'dart:convert';

import 'package:base_bloc/domain/model/index.dart';

import 'index.dart';

abstract class TokenCache {
  Future<TokenModel?> getTokenCache();

  Future<bool> saveTokenCache(TokenModel token);

  Future<bool> removeTokenCache();
}

class TokenCacheImpl implements TokenCache {
  final LocalDataStorage _storage;

  TokenCacheImpl(this._storage);

  @override
  Future<TokenModel?> getTokenCache() async {
    var jsonString = await _storage.getString(tokenKey) ?? '';
    if (jsonString.isNotEmpty) {
      final json = jsonDecode(jsonString);
      return TokenModel.fromJson(json);
    }
    return null;
  }

  @override
  Future<bool> removeTokenCache() async {
    await _storage.remove(tokenKey);
    return true;
  }

  @override
  Future<bool> saveTokenCache(TokenModel token) async {
    await _storage.saveString(tokenKey, jsonEncode(token.toJson()));
    return true;
  }
}
