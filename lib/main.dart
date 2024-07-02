import 'dart:async';
import 'dart:io';

import 'package:base_bloc/core/constants/env_constants.dart';
import 'package:base_bloc/data/local/index.dart';
import 'package:base_bloc/data/net/index.dart';
import 'package:base_bloc/domain/enum/index.dart';
import 'package:base_bloc/domain/model/index.dart';
import 'package:base_bloc/domain/repository/index.dart';
import 'package:base_bloc/presentation/app/index.dart';
import 'package:base_bloc/presentation/base/index.dart';
import 'package:base_bloc/presentation/resource/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import 'app_injector.dart';
import 'core/constants/index.dart';
import 'domain/use_case/index.dart';
import 'presentation/navigator/index.dart';
import 'presentation/page/login/index.dart';
import 'presentation/page/main/index.dart';
import 'presentation/page/splash/index.dart';
import 'presentation/page/tutorial/index.dart';
import 'presentation/styles/index.dart';

late ApplicationBloc appBloc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConstants.init();
  await initInjector();

  await Future.wait([
    _setupAndroidInAppWebview(),
    injector.get<EndPointProvider>().load(),
    injector.get<UserDataCache>().loadCacheData(),
    _loadLocalSetting(injector.get<SettingsCache>()),
  ]);
  appBloc = ApplicationBloc(
    injector<AuthenticationRepository>(),
    injector<SystemCache>(),
    injector<LogoutUseCase>(),
    injector<SettingRepository>(),
  );
  runApp(MultiBlocProvider(
      providers: [
        Provider<AuthenticationStatusBroadcaster>(create: (_) => injector()),
        Provider<SettingsCache>(create: (_) => injector()),
        Provider<UserDataCache>(create: (_) => injector()),
        Provider<SystemCache>(create: (_) => injector()),
      ],
      child: BlocProvider<ApplicationBloc>(
        create: (BuildContext context) => appBloc,
        child: const MyApp(),
      )));
}

Future<void> _loadLocalSetting(SettingsCache cache) async {
  final String sysLocale = Platform.localeName;
  final LanguageCode appLanguageCode =
      (await cache.getCachedSetting())?.language ??
          (getLanguageCodeFromString(
              code: (sysLocale.length >= 5) ? sysLocale.substring(3, 5) : kVi));
  await AppLocalizations.shared
      .reloadLanguageBundle(languageCode: appLanguageCode.code);
  final cached = injector.get<SettingsCache>();
  var setting = await cached.getCachedSetting();
  if (setting == null) {
    setting = SettingModel(items: [
      SettingItem(name: kLanguage, value: appLanguageCode.code),
      SettingItem(name: kNotification, value: kOn),
    ]);
    cached.saveSetting(setting: setting, saveToLocal: false);
  }
}

Future<void> _setupAndroidInAppWebview() async {
  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
    var swAvailable = await WebViewFeature.isFeatureSupported(
        WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await WebViewFeature.isFeatureSupported(
        WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
    if (swAvailable && swInterceptAvailable) {
      ServiceWorkerController serviceWorkerController =
          ServiceWorkerController.instance();
      await serviceWorkerController.setServiceWorkerClient(ServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          return null;
        },
      ));
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    appBloc.dispatchEvent(AppLaunched());
    _streamSubscription?.cancel();
    _streamSubscription = appBloc.broadcastEventStream.listen((event) async {
      if (event is LanguageSettingChangedEvent) {
        await AppLocalizations.shared
            .reloadLanguageBundle(languageCode: event.newLanguageCode.code);
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return RefreshConfiguration(
        headerBuilder: () => const WaterDropMaterialHeader(
          backgroundColor: AppColors.primaryColor,
          color: Colors.white,
        ),
        headerTriggerDistance: 80.0,
        springDescription:
            const SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
        maxOverScrollExtent: 100,
        maxUnderScrollExtent: 0,
        enableScrollWhenRefreshCompleted: true,
        enableLoadingWhenFailed: true,
        hideFooterWhenNotFull: false,
        enableBallisticLoad: true,
        footerBuilder: () => const ClassicFooter(
          loadStyle: LoadStyle.HideAlways,
          textStyle: TextStyle(color: Colors.transparent),
          idleIcon: SizedBox(),
          canLoadingIcon: SizedBox(),
          failedIcon: SizedBox(),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textSelectionTheme: const TextSelectionThemeData(
                selectionHandleColor: Colors.transparent),
          ),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
          home: BlocBuilder<ApplicationBloc, BaseState>(
              bloc: appBloc,
              builder: (context, state) {
                const loadingView = SplashPage(pageTag: PageTag.splash);
                if (state is ApplicationState) {
                  switch (state.tag) {
                    case AppLaunchTag.tutorial:
                      return const TutorialPage(
                        pageTag: PageTag.tutorial,
                      );
                    case AppLaunchTag.login:
                      return const LoginPage(
                        pageTag: PageTag.login,
                      );
                    case AppLaunchTag.main:
                      return const MainPage(pageTag: PageTag.main);
                    default:
                      return loadingView;
                  }
                }
                // loading view
                return loadingView;
              }),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }
}
