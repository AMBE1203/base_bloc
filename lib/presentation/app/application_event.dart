import 'package:lunar_calendar/core/error/index.dart';
import 'package:lunar_calendar/presentation/base/index.dart';

abstract class ApplicationEvent extends BaseEvent {}

class LoadingEvent extends ApplicationEvent {}

class AppLaunched extends ApplicationEvent {}

class AccessTokenExpiredEvent extends ApplicationEvent {}

class RegisterSuccessEvent extends ApplicationEvent {
  final bool hasUserData;

  RegisterSuccessEvent({required this.hasUserData});
}

class LoginSuccessEvent extends ApplicationEvent {
  final bool isFirstTimeLogin;

  LoginSuccessEvent({required this.isFirstTimeLogin});
}

class ForceUserLoginEvent extends ApplicationEvent {}

class ErrorEvent extends ApplicationEvent {
  Failure failure;

  ErrorEvent({required this.failure});
}

class FinishedTutorialEvent extends ApplicationEvent {}

class LogoutSuccessEvent extends BaseEvent {}

class RequestOpenSearchPageEvent extends BaseEvent {}

class KolLoginSuccessEvent extends BaseEvent {}


class CopyEvent extends BaseEvent {
  String content;

  CopyEvent({required this.content});
}

class RefreshUserDataEvent extends BaseEvent {}


class ShareSnsEvent extends BaseEvent {
  int productId;
  String productImage;
  int? kolId;

  ShareSnsEvent({
    required this.productId,
    required this.productImage,
    this.kolId,
  });
}
