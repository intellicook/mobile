import 'package:flutter/material.dart';

extension TextSpanExtensions on TextSpan {
  Size size(BuildContext context) {
    final textPainter = TextPainter(
      text: this,
      textScaler: MediaQuery.of(context).textScaler,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: MediaQuery.of(context).size.width);

    return textPainter.size;
  }
}
