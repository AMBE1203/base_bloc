import 'package:base_bloc/core/error/index.dart';
import 'package:base_bloc/presentation/base/index.dart';

enum AppLaunchTag { splash, login, main, tutorial }

class ApplicationState extends BaseState {
  AppLaunchTag tag;

  ApplicationState({
    required this.tag,
    Failure? failure,
    LoadingStatus? status,
  }) : super(
          failure: failure,
          loadingStatus: status ?? LoadingStatus.none,
        );

  ApplicationState copyWith({
    AppLaunchTag? tag,
    Failure? failure,
    LoadingStatus? status,
  }) {
    return ApplicationState(
      tag: tag ?? this.tag,
      failure: failure,
      status: status,
    );
  }
}
