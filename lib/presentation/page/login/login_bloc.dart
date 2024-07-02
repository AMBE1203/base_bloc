import 'package:base_bloc/presentation/base/index.dart';
import 'index.dart';

class LoginBloc extends BaseBloc<BaseEvent, LoginState> {
  LoginBloc() : super(initState: LoginState()) {}

  @override
  void dispose() {}
}
