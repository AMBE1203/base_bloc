import 'package:flutter/material.dart';

import 'index.dart';

UnderlineInputBorder underlineBorder(
    {double size = 0.2, Color color = Colors.green}) {
  return UnderlineInputBorder(
      borderSide: BorderSide(width: size, color: color));
}

OutlineInputBorder get outlineInputBorder => const OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.greyE1, width: 0.5),
    borderRadius: BorderRadius.all(Radius.circular(3)));

OutlineInputBorder get outlineInputBorderTransparent =>
    const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 0.5),
    );
