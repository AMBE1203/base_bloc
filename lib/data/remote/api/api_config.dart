import 'package:base_bloc/core/constants/index.dart';

abstract class ApiConfig {
  late String baseUrl;
  late int connectTimeout;
  late int receiveTimeout;
}

class ApiConfigImpl extends ApiConfig {
  @override
  String get baseUrl => EnvConstants.baseUrl;

  @override
  int get connectTimeout => mConnectTimeOut;

  @override
  int get receiveTimeout => mReceiveTimeOut;
}
