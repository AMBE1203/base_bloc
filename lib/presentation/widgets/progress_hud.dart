import 'package:flutter/material.dart';
import 'package:lunar_calendar/presentation/styles/index.dart';


class ProgressHud extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget child;

  const ProgressHud({
    Key? key,
    this.inAsyncCall = false,
    this.opacity = 0.3,
    this.color = Colors.white,
    this.progressIndicator = const CircularProgressIndicator(
      valueColor:AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
    ),
    this.offset,
    this.dismissible = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    if (inAsyncCall) {
      Widget layOutProgressIndicator;
      if (offset == null) {
        layOutProgressIndicator = Center(child: progressIndicator);
      } else {
        layOutProgressIndicator = Positioned(
          left: offset?.dx ?? 0,
          top: offset?.dy ?? 0,
          child: progressIndicator,
        );
      }
      final modal = [
        Opacity(
          opacity: opacity,
          child: ModalBarrier(dismissible: dismissible, color: color),
        ),
        layOutProgressIndicator
      ];
      widgetList += modal;
    }
    return Stack(
      children: widgetList,
    );
  }
}
