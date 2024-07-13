import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:intellicook_mobile/theme.dart';

class ShadowConsts {
  static const highOffset = Offset(0.0, 8.0);
  static const highBlurRadius = 48.0;
  static const highSpreadRadius = -16.0;

  static const lowOffset = Offset(0.0, 2.0);
  static const lowBlurRadius = 6.0;
  static const lowSpreadRadius = -2.0;

  static List<BoxShadow> high({bool inset = false}) {
    return [
      BoxShadow(
        color: IntelliCookTheme.shadow,
        offset: highOffset,
        blurRadius: highBlurRadius,
        spreadRadius: highSpreadRadius,
        inset: inset,
      )
    ];
  }

  static List<BoxShadow> low({bool inset = false}) {
    return [
      BoxShadow(
        color: IntelliCookTheme.shadow,
        offset: lowOffset,
        blurRadius: lowBlurRadius,
        spreadRadius: lowSpreadRadius,
        inset: inset,
      )
    ];
  }
}
