import 'package:base_bloc/core/error/index.dart';
import 'index.dart';
import 'package:base_bloc/presentation/base/index.dart';

class LoginState extends BaseState {
  LoginState({
    LoadingStatus? loadingStatus,
    Failure? failure,
  }) : super(
      loadingStatus: loadingStatus ?? LoadingStatus.none,
      failure: failure);

  LoginState copyWith({
    LoadingStatus? loadingStatus,
    Failure? failure,
  }) {
    return LoginState(
      loadingStatus: loadingStatus,
      failure: failure,
    );
  }
}