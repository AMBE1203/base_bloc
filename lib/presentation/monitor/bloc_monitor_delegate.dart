import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

BlocMonitorDelegate blocMonitorDelegate = BlocMonitorDelegate();

class BlocMonitorDelegate extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    Logger().d('[BlocMonitorDelegate]: onCreate');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    Logger().d('[BlocMonitorDelegate]: onClose');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    Logger().d('[BlocMonitorDelegate]: onTransition');
  }
}
