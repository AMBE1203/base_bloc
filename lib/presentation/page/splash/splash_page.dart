import 'package:base_bloc/core/error/index.dart';
import 'package:base_bloc/presentation/base/index.dart';
import 'package:base_bloc/presentation/navigator/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'index.dart';

class SplashPage extends BasePage {
  const SplashPage({
    Key? key,
    required PageTag pageTag,
  }) : super(key: key, pageTag: pageTag);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends BasePageState<SplashBloc, SplashPage, SplashRouter> {
  @override
  Widget buildLayout(
      BuildContext context, BaseBloc<BaseEvent, BaseState> bloc) {
    return BlocBuilder<SplashBloc, SplashState>(builder: (context, state) {
      var page = SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: Center(
                child: Text(" Splash page"),
              ),
            ),
          ));
      return page;
    });
  }
}
