import 'package:dio/dio.dart';

enum ApiMethod { get, post, put, delete }

abstract class IApiInput {
  EndPoint endPoint;
  dynamic body;
  FormData? data;
  Map<String, dynamic>? params;

  IApiInput(
    this.endPoint,
    this.data,
    this.body,
    this.params,
  );
}

class ApiInput extends IApiInput {
  ApiInput(
    EndPoint endPoint, {
    FormData? data,
    Map<String, dynamic>? body,
    Map<String, dynamic>? param,
  }) : super(
          endPoint,
          data,
          // header,
          body,
          param,
        );
}

class EndPoint {
  String path;
  ApiMethod method;

  EndPoint({
    required this.path,
    required this.method,
  });

  factory EndPoint.fromJson(Map<String, dynamic> json) {
    var method = json['method'] ?? 'get';
    switch (method) {
      case 'post':
        method = ApiMethod.post;
        break;
      case 'get':
        method = ApiMethod.get;
        break;
      case 'delete':
        method = ApiMethod.delete;
        break;
      case 'put':
        method = ApiMethod.put;
        break;
      default:
        break;
    }
    return EndPoint(
      path: json['endpoint'],
      method: method,
    );
  }

  EndPoint appendPath(String subPath) {
    String newPath = path + subPath;
    return EndPoint(path: newPath, method: method);
  }
}
