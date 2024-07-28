import 'package:flutter/material.dart';

class OpacityConsts {
  static const highLight = 0.5;
  static const lowLight = 0.75;
  static const highDark = 0.65;
  static const lowDark = 0.9;

  static double high(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? highLight : highDark;
  }

  static double low(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? lowLight : lowDark;
  }
}
