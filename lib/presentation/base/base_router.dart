import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazi_chat/domain/model/index.dart';
import 'package:lazi_chat/presentation/app/index.dart';
import 'package:lazi_chat/presentation/navigator/page_navigator.dart';

import 'index.dart';

abstract class BaseRouter {
  ApplicationBloc applicationBloc(BuildContext context) {
    final bloc = BlocProvider.of<ApplicationBloc>(context);
    return bloc;
  }

  dynamic onNavigateByState(
      {required BuildContext context, required BaseState state}) {}

  dynamic onNavigateByEvent(
      {required BuildContext context, required BaseEvent event}) {
    if (event is OnBackEvent) {
      return navigator.popBack(context: context);
    }
  }

  BasePage? getNotiDestinationPage(NotificationModel notification) {
    BasePage? page;
    // todo go to notification dé
    return page;
  }
}
