import 'package:base_bloc/core/error/index.dart';

enum LoadingStatus {
  none,
  loading,
  finish,
}

abstract class BaseState {
  LoadingStatus loadingStatus = LoadingStatus.none;
  Failure? failure;

  BaseState({
    this.loadingStatus = LoadingStatus.none,
    this.failure,
  });
}
