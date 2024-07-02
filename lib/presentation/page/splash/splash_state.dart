import 'package:base_bloc/core/error/index.dart';
import 'index.dart';
import 'package:base_bloc/presentation/base/index.dart';

class SplashState extends BaseState {
  SplashState({
    LoadingStatus? loadingStatus,
    Failure? failure,
  }) : super(
      loadingStatus: loadingStatus ?? LoadingStatus.none,
      failure: failure);

  SplashState copyWith({
    LoadingStatus? loadingStatus,
    Failure? failure,
  }) {
    return SplashState(
      loadingStatus: loadingStatus,
      failure: failure,
    );
  }
}