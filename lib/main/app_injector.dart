import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:lazi_chat/core/network/index.dart';
import 'package:lazi_chat/data/local/index.dart';
import 'package:lazi_chat/data/net/index.dart';
import 'package:lazi_chat/data/remote/api/index.dart';
import 'package:lazi_chat/data/remote/base/index.dart';
import 'package:lazi_chat/data/repository/index.dart';
import 'package:lazi_chat/domain/provider/index.dart';
import 'package:lazi_chat/domain/repository/index.dart';
import 'package:lazi_chat/domain/usecase/index.dart';
import 'package:lazi_chat/presentation/page/login/index.dart';
import 'package:lazi_chat/presentation/utils/index.dart';

GetIt injector = GetIt.asNewInstance();

initInjector() {
  // Utils
  injector.registerLazySingleton<Connectivity>(() => Connectivity());
  injector.registerLazySingleton<EndPointProvider>(() => EndPointProvider());
  injector.registerLazySingleton<EnvironmentProvider>(
      () => EnvironmentProviderImpl());
  injector.registerLazySingleton<PushNotificationHandler>(
      () => PushNotificationHandler.shared);
  injector
      .registerLazySingleton<DeviceIdProvider>(() => DeviceIdProviderImpl());

  // Api
  injector.registerLazySingleton<ApiConfig>(() => ApiConfigImpl(
        injector(),
      ));
  injector.registerLazySingleton<NetworkStatus>(() => NetworkStatusImpl(
        injector(),
      ));
  injector.registerFactory<RequestHeaderBuilder>(
      () => RequestHeaderBuilder(injector(), injector()));
  injector.registerFactory<AuthApi>(() => AuthApiImpl());

  // Cache
  injector
      .registerFactory<LocalDataStorage>(() => SharePreferenceStorageImpl());
  injector.registerLazySingleton<TokenCache>(() => AuthCacheImpl(injector()));
  injector
      .registerLazySingleton<SettingCache>(() => SettingCacheImpl(injector()));
  // Repository
  injector.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        injector(),
        injector(),
        injector(),
      ));

  // Bloc
  injector.registerFactory<LoginBloc>(() => LoginBloc());

  // Router
  injector.registerFactory<LoginRouter>(() => LoginRouter());

  // Use case
  injector.registerFactory<LogoutUseCase>(() => LogoutUseCaseImpl(injector()));
}
