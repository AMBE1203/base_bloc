import 'package:base_bloc/presentation/base/index.dart';
import 'index.dart';

class SplashBloc extends BaseBloc<BaseEvent, SplashState> {
  SplashBloc() : super(initState: SplashState()) {}

  @override
  void dispose() {}
}
