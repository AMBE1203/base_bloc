import 'package:base_bloc/app_injector.dart';
import 'package:base_bloc/core/constants/index.dart';
import 'package:base_bloc/domain/repository/index.dart';
import 'package:base_bloc/presentation/app/index.dart';
import 'package:base_bloc/presentation/base/index.dart';
import 'package:base_bloc/presentation/navigator/index.dart';
import 'package:base_bloc/presentation/resource/index.dart';
import 'package:base_bloc/presentation/styles/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({
    super.key,
    required this.pageTag,
  });

  final PageTag pageTag;
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc.onPageDidChangeDependenciesEvent(
        PageDidChangeDependenciesEvent(context: context));
  }

  void pageDidAppear(BuildContext context) {}

  void pageDidDisappear(BuildContext context) {}

  void pageGainForceGround(BuildContext context) {}

  void pageLostForceGround(BuildContext context) {}

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

  static final List<String> _showingMessages = [];

  static bool _sameMessageIsShowing(String checkMsg) {
    final index = _showingMessages.indexWhere((element) => checkMsg == element);
    return index >= 0;
  }

  static _onMessageShow(String msg) {
    _showingMessages.add(msg);
  }

  static _onMessageHide(String msg) {
    final index = _showingMessages.indexWhere((element) => msg == element);
    if (index >= 0) {
      _showingMessages.removeAt(index);
    }
  }

  void stateListenerHandler(BaseState state) async {
    if (state.failure != null) {
      if (state.failure!.httpStatusCode == accessTokenExpiredCode) {
        final result = await showAlert(
          primaryColor: AppColors.primaryColor,
          context: context,
          message: AppLocalizations.shared.sessionExpiredMessage,
        );
        if (result) {
          if (mounted) {
            applicationBloc.postBroadcastEvent(LogoutSuccessEvent());
            applicationBloc.dispatchEvent(AccessTokenExpiredEvent());
            navigateByEvent(event: ForceUserLoginEvent());
          }
        }
        return;
      }
      if (state.failure!.errorCode == requireLoginErrorCode) {
        openLoginPageIfNeeds();
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
      Logger().d('[Debug]: error$state $message');

      if (message.isNotEmpty == true) {
        if (_sameMessageIsShowing(message)) {
          return;
        } else {
          _onMessageShow(message);
          showSnackBarMessage(message, context, () {
            _onMessageHide(message);
          });
        }
      }
    }
  }

  openLoginPageIfNeeds() {
    final status =
        context.read<AuthenticationStatusBroadcaster>().currentStatus;
    if (status != AuthenticationStatus.loggedIn) {
      router.onNavigateByEvent(context: context, event: ForceUserLoginEvent());
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        pageDidAppear(context);
        bloc.onPageDidAppearEvent(
            PageDidAppearEvent(tag: widget.pageTag, context: context));
      },
      onFocusLost: () {
        pageDidDisappear(context);
        bloc.onPageDidDisappearEvent(
            PageDidDisappearEvent(tag: widget.pageTag, context: context));
      },
      onForegroundLost: () {
        pageLostForceGround(context);
        bloc.onAppEnterBackgroundEvent(
            AppEnterBackgroundEvent(context: context, tag: widget.pageTag));
      },
      onForegroundGained: () {
        pageGainForceGround(context);
        bloc.onAppGainForegroundEvent(
            AppGainForegroundEvent(context: context, tag: widget.pageTag));
      },
      child: Scaffold(
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
