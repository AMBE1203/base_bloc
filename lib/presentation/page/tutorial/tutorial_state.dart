import 'package:base_bloc/core/error/index.dart';
import 'index.dart';
import 'package:base_bloc/presentation/base/index.dart';

class TutorialState extends BaseState {
  TutorialState({
    LoadingStatus? loadingStatus,
    Failure? failure,
  }) : super(
      loadingStatus: loadingStatus ?? LoadingStatus.none,
      failure: failure);

  TutorialState copyWith({
    LoadingStatus? loadingStatus,
    Failure? failure,
  }) {
    return TutorialState(
      loadingStatus: loadingStatus,
      failure: failure,
    );
  }
}