import 'package:base_bloc/app_injector.dart';
import 'package:base_bloc/core/network/index.dart';
import 'package:base_bloc/data/net/index.dart';
import 'package:base_bloc/data/remote/api/index.dart';

import 'index.dart';

abstract class BaseApi {
  NetworkStatus? networkStatus;
  EndPointProvider? endPointProvider;
  RequestHeaderBuilder? headerBuilder;
  ApiConfig? apiConfig;

  BaseApi({
    ApiConfig? config,
    EndPointProvider? provider,
    NetworkStatus? status,
    RequestHeaderBuilder? builder,
  }) {
    networkStatus = status ?? injector.get<NetworkStatus>();
    headerBuilder = builder ?? injector.get<RequestHeaderBuilder>();
    endPointProvider = provider ?? injector.get<EndPointProvider>();
    apiConfig = config ?? injector.get<ApiConfig>();
  }

  Future<ApiConnection> initConnection() async {
    final header = await headerBuilder?.buildHeader();
    return ApiConnection(
      apiConfig!,
      header ?? {},
      networkStatus: networkStatus,
    );
  }
}
