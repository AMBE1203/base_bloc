import 'package:base_bloc/core/error/index.dart';
import 'package:base_bloc/presentation/base/index.dart';
import 'package:base_bloc/presentation/navigator/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'index.dart';

class LoginPage extends BasePage {
  const LoginPage({
    Key? key,
    required PageTag pageTag,
  }) : super(key: key, pageTag: pageTag);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BasePageState<LoginBloc, LoginPage, LoginRouter> {
  @override
  Widget buildLayout(
      BuildContext context, BaseBloc<BaseEvent, BaseState> bloc) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      var page = SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: Center(
                child: Text(" Login page"),
              ),
            ),
          ));
      return page;
    });
  }
}
