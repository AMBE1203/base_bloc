import 'package:base_bloc/core/constants/index.dart';
import 'package:base_bloc/data/local/index.dart';
import 'package:base_bloc/data/remote/api/index.dart';
import 'package:logger/logger.dart';

class RequestHeaderBuilder {
  final TokenCache _tokenCache;
  final ApiConfig _apiConfig;

  RequestHeaderBuilder(
    this._apiConfig,
    this._tokenCache,
  );

  Map<String, String> _defaultHeader({
    String? token,
    String contentType = 'application/json',
  }) {
    Logger().d("token: $token");
    var header = {
      'content-type': contentType,
      'X-RSA-TOKEN': EnvConstants.apiKey,
    };
    if (token?.isNotEmpty ?? false) {
      header['Authorization'] = 'Bearer $token';
    }
    return header;
  }

  Future<Map<String, String>> buildHeader() async {
    String accessToken = (await _tokenCache.getTokenCache())?.token ?? '';
    var header = _defaultHeader(token: accessToken);
    return header;
  }
}
