import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class ShadowConsts {
  static const highBlurRadius = 16.0;
  static const lowBlurRadius = 4.0;
  static final highShadowColor = Colors.black.withOpacity(0.2);
  static final lowShadowColor = Colors.black.withOpacity(0.3);

  static List<BoxShadow> high({bool inset = false}) {
    return [
      BoxShadow(
        color: highShadowColor,
        blurRadius: highBlurRadius,
        blurStyle: BlurStyle.outer,
        inset: inset,
      ),
    ];
  }

  static List<BoxShadow> low({bool inset = false}) {
    return [
      BoxShadow(
        color: lowShadowColor,
        blurRadius: lowBlurRadius,
        blurStyle: BlurStyle.outer,
        inset: inset,
      ),
    ];
  }
}
