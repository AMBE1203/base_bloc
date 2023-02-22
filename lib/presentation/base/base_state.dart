import 'package:lazi_chat/core/error/index.dart';

enum LoadingStatus {
  none,
  loading,
  finish,
}

abstract class BaseState {
  LoadingStatus loadingStatus = LoadingStatus.none;
  Failure? failure;

  BaseState({this.loadingStatus = LoadingStatus.none, this.failure});
}

class IdlState extends BaseState {}

// class ErrorState extends BaseState {
//   String? messageError;
//   String? code;
//   ErrorState({this.messageError, this.code});
// }

// class ValidatedState extends BaseState {}

// class LoadingState extends BaseState {}
