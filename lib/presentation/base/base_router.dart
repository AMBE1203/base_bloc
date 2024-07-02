import 'package:base_bloc/presentation/app/index.dart';
import 'package:base_bloc/presentation/navigator/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'index.dart';

abstract class BaseRouter {
  ApplicationBloc applicationBloc(BuildContext context) {
    final bloc = BlocProvider.of<ApplicationBloc>(context);
    return bloc;
  }

  dynamic onNavigateByState(
      {required BuildContext context, required BaseState state}) {}

  dynamic onNavigateByEvent(
      {required BuildContext context, required BaseEvent event}) async {
    if (event is OnBackEvent) {
      return navigator.popBack(context: context);
    }
  }
}
