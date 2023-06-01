import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lunar_calendar/data/local/index.dart';
import 'package:lunar_calendar/data/net/index.dart';
import 'package:lunar_calendar/domain/provider/index.dart';
import 'package:lunar_calendar/domain/repository/index.dart';
import 'package:lunar_calendar/domain/use_case/index.dart';
import 'package:lunar_calendar/presentation/app/index.dart';
import 'package:lunar_calendar/presentation/base/index.dart';
import 'package:lunar_calendar/presentation/page/login/index.dart';
import 'package:lunar_calendar/presentation/styles/index.dart';
import 'package:lunar_calendar/presentation/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'app_injector.dart';

late ApplicationBloc appBloc;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    appBloc.dispatchEvent(AppLaunched());
    _streamSubscription?.cancel();
    _streamSubscription = appBloc.broadcastEventStream.listen((event) async {
      // if (event is LanguageSettingChangedEvent) {
      //   await AppLocalizations.shared
      //       .reloadLanguageBundle(languageCode: event.newLanguaCode.code);
      //   setState(() {});
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        home: BlocBuilder<ApplicationBloc, BaseState>(
            bloc: appBloc,
            builder: (context, state) {
              const loadingView = LoginPage(pageTag: PageTag.login);
              if (state is ApplicationState) {
                switch (state.tag) {
                  case AppLaunchTag.tutorial:
                    return loadingView;
                  case AppLaunchTag.login:
                    return loadingView;
                  case AppLaunchTag.main:
                    return loadingView;
                  default:
                    return loadingView;
                }
              }
              // loading view
              return loadingView;
            }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }
}

class AppEntry {
  runWithFlavor({required EnvironmentFlavor flavor}) async {
    WidgetsFlutterBinding.ensureInitialized();
    _setupBackgroundNotification();

    // await Firebase.initializeApp();
    await initInjector();
    injector.get<EnvironmentProvider>().setFlavor(flavor: flavor);
    await Future.wait([
      injector.get<EndPointProvider>().load(),
      // injector.get<UserDataCache>().loadCacheData(),
      // _loadLocalSetting(injector.get<SettingCache>()),
    ]);

    appBloc =
        ApplicationBloc(injector<AuthRepository>(), injector<LogoutUseCase>());

    runApp(
      MultiProvider(
        providers: [
          // Provider<NotifyCountProvider>(create: (_) => injector()),
          //
          Provider<SettingCache>(create: (_) => injector()),
          // Provider<UserDataCache>(create: (_) => injector()),
        ],
        child: BlocProvider<ApplicationBloc>(
          create: (BuildContext context) => appBloc,
          child: const MyApp(),
        ),
      ),
    );
  }

  // Future<void> _loadLocalSetting(SettingCache cache) async {
  //   final String sysLocale = Platform.localeName;
  //   final LanguageCode appLanguageCode =
  //       (await cache.getCachedSetting())?.language ??
  //           (getLanguageCodeFromString(
  //               code: (sysLocale.length > 2)
  //                   ? sysLocale.substring(0, 2)
  //                   : vietnameLanguageCode));
  //   await AppLocalizations.shared
  //       .reloadLanguageBundle(languageCode: appLanguageCode.code);
  //   final cached = injector.get<SettingCache>();
  //   var setting = await cached.getCachedSetting();
  //   if (setting == null) {
  //     setting = SettingModel(items: [
  //       SettingItem(name: kLanguage, value: appLanguageCode.code),
  //       SettingItem(name: kNotification, value: kOn),
  //     ]);
  //     cached.saveSetting(setting: setting);
  //   }
  // }

  _setupBackgroundNotification() {
    // push-notification handler when app in background
    IsolateNameServer.registerPortWithName(
      backgroundMessagePort.sendPort,
      backgroundMessageIsolateName,
    );

    backgroundMessagePort.listen(backgroundMessagePortHandler);
  }
}
