import 'package:base_bloc/domain/enum/index.dart';
import 'package:base_bloc/presentation/base/index.dart';

abstract class ApplicationEvent extends BaseEvent {}

class AppLaunched extends ApplicationEvent {}

class AccessTokenExpiredEvent extends ApplicationEvent {}

class ForceUserLoginEvent extends ApplicationEvent {}

class LogoutSuccessEvent extends ApplicationEvent {}

class LanguageSettingChangedEvent extends BaseEvent {
  LanguageCode newLanguageCode;

  LanguageSettingChangedEvent({
    required this.newLanguageCode,
  });
}
