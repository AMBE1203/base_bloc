import 'package:base_bloc/core/error/index.dart';
import 'package:base_bloc/presentation/base/index.dart';
import 'package:base_bloc/presentation/navigator/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'index.dart';

class TutorialPage extends BasePage {
  const TutorialPage({
    Key? key,
    required PageTag pageTag,
  }) : super(key: key, pageTag: pageTag);

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends BasePageState<TutorialBloc, TutorialPage, TutorialRouter> {
  @override
  Widget buildLayout(
      BuildContext context, BaseBloc<BaseEvent, BaseState> bloc) {
    return BlocBuilder<TutorialBloc, TutorialState>(builder: (context, state) {
      var page = SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: Center(
                child: Text(" Tutorial page"),
              ),
            ),
          ));
      return page;
    });
  }
}
