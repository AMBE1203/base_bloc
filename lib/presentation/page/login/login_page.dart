import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazi_chat/presentation/base/index.dart';
import 'package:lazi_chat/presentation/utils/index.dart';

import 'index.dart';

class LoginPage extends BasePage {
  const LoginPage({required PageTag pageTag, Key? key})
      : super(tag: pageTag, key: key);

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends BasePageState<LoginBloc, LoginPage, LoginRouter> {
  StreamSubscription? _subscription;

  @override
  void stateListenerHandler(BaseState state) async {
    super.stateListenerHandler(state);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  @override
  Widget buildLayout(BuildContext context, BaseBloc bloc) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<LoginBloc, LoginState>(builder: (ctx, state) {
        return const SafeArea(
          child: Scaffold(
            body: Center(
              child: Text("Login Page"),
            ),
          ),
        );
      }),
    );
  }
}
