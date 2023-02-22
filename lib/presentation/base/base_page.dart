import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:lazi_chat/core/utils/consts.dart';
import 'package:lazi_chat/main/app_injector.dart';
import 'package:lazi_chat/presentation/app/index.dart';
import 'package:lazi_chat/presentation/resources/index.dart';
import 'package:lazi_chat/presentation/styles/index.dart';
import 'package:lazi_chat/presentation/utils/index.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'index.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({
    required this.tag,
    Key? key,
  }) : super(key: key);
  final PageTag tag;
}

abstract class BasePageState<
    T extends BaseBloc<BaseEvent, BaseState>,
    P extends BasePage,
    R extends BaseRouter> extends State<P> with BasePageMixin {
  late T bloc;
  late BuildContext subContext;
  late R router;
  late ApplicationBloc applicationBloc;

  bool get resizeToAvoidBottomInset => false;

  double get paddingBottomScreenInHome =>
      90 + MediaQuery.of(context).padding.bottom;

  double get getHeight =>
      MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.top -
      const Size.fromHeight(50).height -
      MediaQuery.of(context).padding.bottom;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc.onPageDidChangeDependenciesEvent(
        PageDidChangeDependenciesEvent(context: context));
  }

  void pageDidAppear(BuildContext context) {}

  void pageDidDisappear(BuildContext context) {}

  void pageGainForceground(BuildContext context) {}

  @override
  void initState() {
    bloc = injector.get<T>();
    router = injector.get<R>();
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    bloc.onPageInitStateEvent(PageInitStateEvent(context: context));
    super.initState();
  }

  navigateByEvent({required BaseEvent event}) async {
    final result =
        await router.onNavigateByEvent(context: context, event: event);
    bloc.onRouteNavigationResult(result);
  }

  Widget buildLayout(BuildContext context, BaseBloc bloc);

  void stateListenerHandler(BaseState state) async {
    if (state.failure != null) {
      if (state.failure!.httpStatusCode == accessTokenExpiredCode) {
        final result = await showAlert(
          primaryColor: AppColors.primaryColor,
          context: context,
          message: AppLocalizations.shared.sessionExpiredMessage,
        );
        if (result) {
          router.onNavigateByEvent(
              context: context, event: ForceUserLoginEvent());
          // navigator.popToRoot(context: context);
          // applicationBloc.dispatchEvent(AccessTokenExpiredEvent());
        }
        return;
      }
      if (state.failure!.errorCode == requireLoginErrorCode) {
        // openLoginPageIfNeeds();
        return;
      }
      String message = '';
      if (state.failure!.errorCode == socketErrorCode ||
          state.failure!.errorCode == timeoutErrorCode) {
        message = AppLocalizations.shared.commonMessageConnectionError;
      } else if (state.failure!.httpStatusCode ==
              httpStatusServerMaintainCode ||
          state.failure!.httpStatusCode == httpStatusServerBadGatewayCode) {
        message = AppLocalizations.shared.commonMessageServerMaintenance;
      } else {
        message = state.failure!.message ?? unknownErrorCode;
      }
      Logger().d('[Debug]: error $message');
      showAlert(
        context: context,
        message: message,
        primaryColor: AppColors.primaryColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        pageDidAppear(context);
        bloc.onPageDidAppearEvent(
            PageDidAppearEvent(tag: widget.tag, context: context));
      },
      onFocusLost: () {
        pageDidDisappear(context);
        bloc.onPageDidDisappearEvent(
            PageDidDisappearEvent(tag: widget.tag, context: context));
      },
      onForegroundLost: () {
        bloc.onAppEnterBackgroundEvent(
            AppEnterBackgroundEvent(context: context, tag: widget.tag));
      },
      onForegroundGained: () {
        pageGainForceground(context);
        bloc.onAppGainForegroundEvent(
            AppGainForegroundEvent(context: context, tag: widget.tag));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: Provider<R>(
          create: (context) => router,
          child: BlocProvider<T>(
            create: (context) => bloc,
            child: BlocListener<T, BaseState>(listener: (context, state) async {
              stateListenerHandler(state);
              final res = await router.onNavigateByState(
                  context: context, state: state);
              bloc.onRouteNavigationResult(res);
            }, child: LayoutBuilder(builder: (sub, _) {
              subContext = sub;
              return buildLayout(subContext, bloc);
            })),
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    bloc.dispose();
    bloc.close();
    super.dispose();
  }
}
