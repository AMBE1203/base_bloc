import 'package:lunar_calendar/core/error/index.dart';
import 'package:lunar_calendar/presentation/base/index.dart';

class LoginState extends BaseState {
  LoginState({
    LoadingStatus? loadingStatus,
    Failure? failure,
  }) : super(
            loadingStatus: loadingStatus ?? LoadingStatus.none,
            failure: failure);

  LoginState copyWith({LoadingStatus? loadingStatus, Failure? failure}) {
    return LoginState(loadingStatus: loadingStatus, failure: failure);
  }
}
