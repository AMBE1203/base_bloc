import 'package:flutter/material.dart';

class RoundContainer extends StatelessWidget {
  final Widget child;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final double? allRadius;
  final Color? color;
  final List<BoxShadow>? shadow;
  final double? height;
  final double? width;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const RoundContainer(
      {required this.child,
      this.topLeftRadius = 0,
      this.topRightRadius = 0,
      this.bottomLeftRadius = 0,
      this.bottomRightRadius = 0,
      this.margin,
      this.padding,
      this.color,
      this.shadow,
      this.allRadius,
      this.height,
      this.width,
      this.borderColor = Colors.transparent,
      this.borderWidth = 1,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
        topLeft: Radius.circular(allRadius ?? topLeftRadius),
        topRight: Radius.circular(allRadius ?? topRightRadius),
        bottomLeft: Radius.circular(allRadius ?? bottomLeftRadius),
        bottomRight: Radius.circular(allRadius ?? bottomRightRadius));
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          boxShadow: shadow,
          color: color ?? Colors.white,
          borderRadius: radius,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: borderWidth ?? 1)
              : null),
      child: ClipRRect(
        borderRadius: radius,
        child: child,
      ),
    );
  }
}
