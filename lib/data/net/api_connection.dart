import 'dart:io';

import 'package:base_bloc/core/constants/index.dart';
import 'package:base_bloc/core/network/index.dart';
import 'package:base_bloc/data/remote/api/index.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logger/logger.dart';
import 'dart:convert' as convert;

import 'index.dart';

class ApiConnection {
  final ApiConfig _apiConfig;
  NetworkStatus? networkStatus;
  Map<String, dynamic> header;

  ApiConnection(this._apiConfig, this.header, {this.networkStatus});

  Future<dynamic> execute(ApiInput input, {bool getRedirectUrl = false}) async {
    Logger().d(
        '[Debug]: url ${_apiConfig.baseUrl}${input.endPoint.path} header: $header');
    Logger().d('[Debug]: body: ${input.body}');
    Logger().d('[Debug]: param: ${input.params}');

    Future<Response> future;
    switch (input.endPoint.method) {
      case ApiMethod.get:
        future = _get(input);
        break;
      case ApiMethod.post:
        future = _post(input);
        break;
      case ApiMethod.delete:
        future = _delete(input);
        break;
      case ApiMethod.put:
        future = _put(input);
        break;
    }
    return future
        .then(getRedirectUrl ? _getRedirectUrl : _parseResponse)
        .catchError((ex) {
      _handleError(ex);
    });
  }

  Future<dynamic> download(
    String downloadUrl,
    String storePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    Options? options,
  }) {
    final future = _httpClient(
      receiveTimeout: 0,
    ).download(
      downloadUrl,
      storePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      lengthHeader: lengthHeader,
      options: options,
    );
    return future.then(_parseResponse).catchError((ex) {
      _handleError(ex);
    });
  }

  Future<dynamic> upload(
    String filePath,
    ApiInput input, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    Options? options,
    ContentType? contentType,
  }) {
    var file = File(filePath);
    if (!file.existsSync()) {
      throw ApiError(
        errorCode: fileNotFoundErrorCode,
        httpStatusCode: 0,
      );
    }
    header[HttpHeaders.contentLengthHeader] = file.lengthSync();
    header[HttpHeaders.contentTypeHeader] = contentType ?? ContentType.binary;
    final future = _httpClient(
      receiveTimeout: 0,
    ).post(
      input.endPoint.path,
      data: input.body,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return future.then(_parseResponse).catchError((ex) {
      _handleError(ex);
    });
  }

  Future<dynamic> uploadMultiPart(
    FormData formData,
    ApiInput input, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    Options? options,
    ContentType? contentType,
  }) {
    final client = _httpClient(
      receiveTimeout: 0,
    );
    Future<Response> future;
    if (input.endPoint.method == ApiMethod.post) {
      future = client.post(
        input.endPoint.path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } else {
      future = client.put(
        input.endPoint.path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    }
    return future.then(_parseResponse).catchError((ex) {
      _handleError(ex);
    });
  }

  _handleError(error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.badResponse:
          final httpStatusCode = error.response?.statusCode ?? 0;
          if (httpStatusCode == httpStatusServerMaintainCode ||
              httpStatusCode == httpStatusServerBadGatewayCode) {
            throw ApiError(
                httpStatusCode: httpStatusCode,
                errorMessage: serverErrorMessage);
          } else {
            throw ApiError.initCombine(
              httpStatusCode,
              _convertToJsonIfNeeds(error.response?.data),
              statusMessage:
                  error.response?.statusMessage ?? unknownErrorMessage,
            );
          }
        case DioExceptionType.sendTimeout:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          throw ApiError(
            httpStatusCode: 0,
            errorCode: timeoutErrorCode,
          );
        case DioExceptionType.cancel:
        default:
          if (error.error is SocketException) {
            throw ApiError(
              httpStatusCode: 0,
              errorCode: socketErrorCode,
            );
          } else {
            throw ApiError(
              httpStatusCode: 0,
              errorCode: unknownErrorCode,
            );
          }
      }
    } else {
      throw error;
    }
  }

  Future<String> _getRedirectUrl(Response response) async {
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      final uri = response.realUri;
      final url = "${uri.origin}${uri.path}?${uri.query}";

      Logger().d('[Debug]: _getRedirectUrl $url}');
      return url;
    } else {
      throw ApiError.initCombine(response.statusCode, response.data,
          statusMessage: response.statusMessage);
    }
  }

  Future<dynamic> _parseResponse(Response response) async {
    final path = response.realUri.origin;
    Logger().d('[Debug]: Response ${response.data.toString()}');
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      return response.data;
    } else {
      throw ApiError.initCombine(response.statusCode, response.data,
          statusMessage: response.statusMessage);
    }
  }

  Future<Response> _get(ApiInput input) async {
    bool hasBaseUrl = input.endPoint.path.startsWith('http');
    return _httpClient(baseUrl: hasBaseUrl ? '' : null).get(
      input.endPoint.path,
      queryParameters: input.params,
    );
  }

  Future<Response> _post(ApiInput input) async {
    return _httpClient().post(
      input.endPoint.path,
      data: input.data ?? input.body,
      queryParameters: input.params,
    );
  }

  Future<Response> _put(ApiInput input) async {
    return _httpClient().put(
      input.endPoint.path,
      data: input.data ?? input.body,
      queryParameters: input.params,
    );
  }

  Future<Response> _delete(ApiInput input) async {
    return _httpClient().delete(
      input.endPoint.path,
      data: input.data ?? input.body,
      queryParameters: input.params,
    );
  }

  Dio _httpClient(
      {String? baseUrl,
      int? connectTimeout,
      int? receiveTimeout,
      Map<String, dynamic>? requestHeader}) {
    var options = BaseOptions(
        baseUrl: baseUrl ?? _apiConfig.baseUrl,
        connectTimeout:
            Duration(microseconds: connectTimeout ?? _apiConfig.connectTimeout),
        receiveTimeout:
            Duration(milliseconds: receiveTimeout ?? _apiConfig.receiveTimeout),
        headers: requestHeader ?? header);
    Dio dio = Dio(options);

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient client =
            HttpClient(context: SecurityContext(withTrustedRoots: false));
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        return client;
      },
    );

    return dio;
  }

  Map<String, dynamic> _convertToJsonIfNeeds(dynamic data) {
    if (data is String) {
      try {
        return convert.json.decode(data);
      } catch (ex) {
        return <String, dynamic>{};
      }
    }
    return data;
  }
}
