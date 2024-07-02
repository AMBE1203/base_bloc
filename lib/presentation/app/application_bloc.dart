import 'dart:async';

import 'package:base_bloc/core/constants/index.dart';
import 'package:base_bloc/core/error/index.dart';
import 'package:base_bloc/data/local/index.dart';
import 'package:base_bloc/domain/repository/index.dart';
import 'package:base_bloc/domain/use_case/index.dart';
import 'package:base_bloc/presentation/app/index.dart';
import 'package:base_bloc/presentation/base/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc extends BaseBloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc(
    this._authenticationRepository,
    this._systemCache,
    this._logoutUseCase,
    this._settingRepository,
  ) : super(initState: ApplicationState(tag: AppLaunchTag.splash)) {
    on<AppLaunched>(_onAppLaunchHandler);
  }

  final AuthenticationRepository _authenticationRepository;
  final SystemCache _systemCache;
  final LogoutUseCase _logoutUseCase;
  final SettingRepository _settingRepository;

  final PublishSubject<BaseEvent> _broadcastEventManager =
      PublishSubject<BaseEvent>();

  FutureOr<void> _onAppLaunchHandler(
      AppLaunched event, Emitter<ApplicationState> emit) async {
    AppLaunchTag tag = AppLaunchTag.splash;
    emit(state.copyWith(
      status: LoadingStatus.loading,
      tag: tag,
    ));
    try {
      // todo fetch config
      final isLogged = await _authenticationRepository.isLogged();
      if (isLogged) {
        _settingRepository.fetchCustomerSetting();
      }
      final hasReadTutorial = await _systemCache.hasReadTutorial;
      tag = hasReadTutorial ? AppLaunchTag.main : AppLaunchTag.tutorial;
      emit(state.copyWith(tag: tag));
    } on RemoteException catch (ex) {
      if ((ex.httpStatusCode ?? 0) == accessTokenExpiredCode) {
        try {
          await _logoutUseCase.logout(isRemoteLogout: false);
        } catch (_) {
          emit(state.copyWith(
              failure: PlatformFailure(msg: unknownErrorMessage),
              tag: AppLaunchTag.main));
        }
      }
      emit(state.copyWith(
          failure: PlatformFailure(msg: ex.errorMessage),
          tag: AppLaunchTag.main));
    } catch (ex) {
      try {
        await _logoutUseCase.logout(isRemoteLogout: false);
      } catch (_) {
        Logger().d('_onAppLaunchHandler exception ');
      } finally {
        emit(state.copyWith(
            failure: PlatformFailure(msg: unknownErrorMessage),
            tag: AppLaunchTag.main));
      }
    }
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
