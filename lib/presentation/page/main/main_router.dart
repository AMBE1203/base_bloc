import 'package:base_bloc/presentation/base/index.dart';
import 'package:flutter/material.dart';

import 'index.dart';

class MainRouter extends BaseRouter {
  @override
  onNavigateByState({required BuildContext context, required BaseState state}) {
    super.onNavigateByState(context: context, state: state);
  }

  @override
  onNavigateByEvent({required BuildContext context, required BaseEvent event}) {
    super.onNavigateByEvent(context: context, event: event);
  }
}
