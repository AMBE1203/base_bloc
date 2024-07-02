import 'package:base_bloc/presentation/page/main/index.dart';
import 'package:base_bloc/presentation/page/splash/index.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import 'core/network/index.dart';
import 'data/local/index.dart';
import 'data/net/index.dart';
import 'data/remote/api/index.dart';
import 'data/remote/base/index.dart';
import 'data/repository/index.dart';
import 'domain/provider/index.dart';
import 'domain/repository/index.dart';
import 'domain/use_case/index.dart';
import 'presentation/page/login/index.dart';
import 'presentation/page/tutorial/index.dart';

GetIt injector = GetIt.asNewInstance();

initInjector() {
  // Utils
  injector.registerLazySingleton<Connectivity>(() => Connectivity());
  injector.registerLazySingleton<EndPointProvider>(() => EndPointProvider());
  injector.registerSingletonAsync<ObjectBox>(() => ObjectBox.create());
  injector
      .registerLazySingleton<DeviceIdProvider>(() => DeviceIdProviderImpl());

  //API
  injector.registerLazySingleton<ApiConfig>(() => ApiConfigImpl());

  injector.registerLazySingleton<NetworkStatus>(() => NetworkStatusImpl(
        injector(),
      ));

  injector.registerFactory<RequestHeaderBuilder>(() => RequestHeaderBuilder(
        injector(),
        injector(),
      ));
  injector.registerFactory<AuthenticationApi>(() => AuthenticationApiImpl());
  injector.registerFactory<SettingApi>(() => SettingApiImpl());

  //Cache
  injector
      .registerFactory<LocalDataStorage>(() => SharePreferenceStorageImpl());
  injector.registerLazySingleton<TokenCache>(() => TokenCacheImpl(
        injector(),
      ));
  injector.registerLazySingleton<UserDataCache>(() => UserDataCacheImpl(
        injector(),
      ));
  injector.registerLazySingleton<SettingsCache>(
      () => SettingsCacheImpl(injector()));
  injector
      .registerLazySingleton<SystemCache>(() => SystemCacheImpl(injector()));
  injector.registerLazySingleton<ObjectBoxDataSource>(
      () => ObjectBoxDataSourceImpl(injector()));

  // Repository
  injector.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
            injector(),
            injector(),
            injector(),
            injector(),
            injector(),
            injector(),
          ));
  injector.registerLazySingleton<SettingRepository>(() => SettingRepositoryImpl(
        injector(),
        injector(),
      ));

  //Bloc
  injector.registerFactory<LoginBloc>(() => LoginBloc());
  injector.registerFactory<TutorialBloc>(() => TutorialBloc());
  injector.registerFactory<SplashBloc>(() => SplashBloc());
  injector.registerFactory<MainBloc>(() => MainBloc());

  // Router
  injector.registerFactory<LoginRouter>(() => LoginRouter());
  injector.registerFactory<TutorialRouter>(() => TutorialRouter());
  injector.registerFactory<SplashRouter>(() => SplashRouter());
  injector.registerFactory<MainRouter>(() => MainRouter());

  // Use case
  injector.registerFactory<LogoutUseCase>(
      () => LogoutUseCaseImpl(injector(), injector()));
}
