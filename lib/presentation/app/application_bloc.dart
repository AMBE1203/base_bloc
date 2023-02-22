import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazi_chat/core/error/index.dart';
import 'package:lazi_chat/core/utils/consts.dart';
import 'package:lazi_chat/domain/repository/index.dart';
import 'package:lazi_chat/domain/usecase/index.dart';
import 'package:lazi_chat/presentation/base/index.dart';
import 'package:rxdart/rxdart.dart';

import 'index.dart';

class ApplicationBloc extends BaseBloc<ApplicationEvent, ApplicationState> {
  final AuthRepository _authRepository;
  final LogoutUseCase _logoutUseCase;

  final PublishSubject<BaseEvent> _broadcastEventManager =
      PublishSubject<BaseEvent>();

  ApplicationBloc(
    this._authRepository,
    this._logoutUseCase,
  ) : super(initState: ApplicationState(tag: AppLaunchTag.splash)) {
    on<AppLaunched>(_onAppLaunchHandler);
    on<AccessTokenExpiredEvent>(_onAccessTokenExpiredHandler);
    on<FinishedTutorialEvent>(_onFinishTutorialHandler);
  }

  _onAccessTokenExpiredHandler(
      AccessTokenExpiredEvent event, Emitter<ApplicationState> emitter) async {
    final logoutResult = await _logoutUseCase.logout(isRemoteLogout: false);
    emitter(logoutResult.fold(
        (l) => ApplicationState(tag: AppLaunchTag.login, failure: l),
        (r) => ApplicationState(
              tag: AppLaunchTag.login,
            )));
  }

  _onAppLaunchHandler(
      AppLaunched event, Emitter<ApplicationState> emitter) async {
    AppLaunchTag tag = AppLaunchTag.splash;
    emitter(state.copyWith(
      status: LoadingStatus.loading,
      tag: tag,
    ));
    try {
      var isLogged = await _authRepository.isLogged();
      await Future.delayed(const Duration(seconds: 1));
      if (isLogged) {
        // todo fetch setting
      }
      emitter(state.copyWith(tag: AppLaunchTag.main));
    } on RemoteException catch (ex) {
      if ((ex.httpStatusCode ?? 0) == accessTokenExpiredCode) {
        await _logoutUseCase.logout(isRemoteLogout: false);
      }
      emitter(state.copyWith(
          failure: PlatformFailure(msg: ex.errorMessage),
          tag: AppLaunchTag.main));
    } catch (ex) {
      emitter(state.copyWith(
          failure: PlatformFailure(msg: unknownErrorMessage), tag: tag));
    }
  }

  _onFinishTutorialHandler(
      FinishedTutorialEvent event, Emitter<ApplicationState> emitter) async {
    emitter(ApplicationState(tag: AppLaunchTag.main));
  }

  @override
  void dispose() {
    _broadcastEventManager.close();
  }
}

//broadcast event
extension AppEventCenter on ApplicationBloc {
  Stream<BaseEvent> get broadcastEventStream => _broadcastEventManager.stream;

  void postBroadcastEvent(BaseEvent event) {
    _broadcastEventManager.add(event);
  }
}
