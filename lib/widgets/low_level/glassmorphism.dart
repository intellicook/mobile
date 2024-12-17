import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Glassmorphism extends StatelessWidget {
  const Glassmorphism({super.key, this.blur = defaultBlur, this.child});

  static const defaultBlur = 16.0;

  final double blur;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ui.ImageFilter.blur(
        sigmaX: blur,
        sigmaY: blur,
      ),
      child: child,
    );
  }
}
