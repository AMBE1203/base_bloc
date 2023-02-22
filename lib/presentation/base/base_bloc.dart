import 'package:flutter_bloc/flutter_bloc.dart';

import 'index.dart';

abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<BaseEvent, State> {
  BaseBloc({required State initState}) : super(initState);

  void dispose();

  void dispatchEvent(BaseEvent event) {
    super.add(event);
  }

  void onPageDidAppearEvent(PageDidAppearEvent event) {}

  void onPageDidChangeDependenciesEvent(PageDidChangeDependenciesEvent event) {}

  void onPageInitStateEvent(PageInitStateEvent event) {}

  void onPageDidDisappearEvent(PageDidDisappearEvent event) {}

  void onAppEnterBackgroundEvent(AppEnterBackgroundEvent event) {}

  void onAppGainForegroundEvent(AppGainForegroundEvent event) {}

  //route navigation result
  void onRouteNavigationResult(dynamic result) {}
}
