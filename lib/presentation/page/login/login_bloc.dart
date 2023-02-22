import 'package:lazi_chat/core/utils/index.dart';
import 'package:lazi_chat/presentation/base/index.dart';

import 'index.dart';

class LoginBloc extends BaseBloc<BaseEvent, LoginState> with Validators {
  LoginBloc() : super(initState: LoginState());

  @override
  dispose() {}
}
