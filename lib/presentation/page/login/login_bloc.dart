import 'package:lunar_calendar/core/utils/index.dart';
import 'package:lunar_calendar/presentation/base/index.dart';

import 'index.dart';

class LoginBloc extends BaseBloc<BaseEvent, LoginState> with Validators {
  LoginBloc() : super(initState: LoginState());

  @override
  dispose() {}
}
