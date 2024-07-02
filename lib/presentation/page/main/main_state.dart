import 'package:base_bloc/core/error/index.dart';
import 'index.dart';
import 'package:base_bloc/presentation/base/index.dart';

class MainState extends BaseState {
  MainState({
    LoadingStatus? loadingStatus,
    Failure? failure,
  }) : super(
      loadingStatus: loadingStatus ?? LoadingStatus.none,
      failure: failure);

  MainState copyWith({
    LoadingStatus? loadingStatus,
    Failure? failure,
  }) {
    return MainState(
      loadingStatus: loadingStatus,
      failure: failure,
    );
  }
}