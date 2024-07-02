import 'package:base_bloc/presentation/base/index.dart';
import 'index.dart';

class MainBloc extends BaseBloc<BaseEvent, MainState> {
  MainBloc() : super(initState: MainState()) {}

  @override
  void dispose() {}
}
