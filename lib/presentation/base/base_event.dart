import 'package:flutter/material.dart';
import 'package:lazi_chat/presentation/utils/index.dart';

abstract class BaseEvent {}

class PageInitStateEvent extends BaseEvent {
  BuildContext? context;

  PageInitStateEvent({
    this.context,
  });
}

class PageDidChangeDependenciesEvent extends BaseEvent {
  BuildContext? context;

  PageDidChangeDependenciesEvent({this.context});
}

class PageBuildEvent extends BaseEvent {
  BuildContext? context;

  PageBuildEvent({this.context});
}

class PageDidAppearEvent extends BaseEvent {
  BuildContext? context;
  PageTag tag;

  PageDidAppearEvent({this.context, required this.tag});
}

class PageDidDisappearEvent extends BaseEvent {
  BuildContext? context;
  PageTag tag;

  PageDidDisappearEvent({@required this.context, required this.tag});
}

class AppEnterBackgroundEvent extends BaseEvent {
  BuildContext? context;
  PageTag tag;

  AppEnterBackgroundEvent({this.context, required this.tag});
}

class AppGainForegroundEvent extends BaseEvent {
  BuildContext? context;
  PageTag tag;

  AppGainForegroundEvent({this.context, required this.tag});
}

class OnResultEvent extends BaseEvent {
  dynamic result;

  OnResultEvent({this.result});
}

class ApplicationInactiveEvent extends BaseEvent {}

class ApplicationResumeEvent extends BaseEvent {}

class LoadMoreEvent extends BaseEvent {}

class NewNotificationEvent extends BaseEvent {}

class OnBackEvent extends BaseEvent {}

class RequestLoadMoreEvent extends BaseEvent {}


