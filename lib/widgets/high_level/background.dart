import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/extensions/tonal_palette_extensions.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    const blur = 64.0;

    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: CustomPaint(
        painter: _BackgroundPainter(),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: child,
        ),
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final unit = size.width;
    final heightUnit = unit * 2;

    final primaryPaint = Paint()
      ..color = IntelliCookTheme.primaryPalette.getColor(80)
      ..style = PaintingStyle.fill;

    final secondaryPaint = Paint()
      ..color = IntelliCookTheme.secondaryPalette.getColor(70)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(unit, heightUnit * 0.2),
      unit * 0.3,
      primaryPaint,
    );
    canvas.drawCircle(
      Offset(unit * 0.8, heightUnit * 0.35),
      unit * 0.15,
      secondaryPaint,
    );
    canvas.drawCircle(
      Offset(unit * 0.15, heightUnit * 0.6),
      unit * 0.4,
      secondaryPaint,
    );
    canvas.drawCircle(
      Offset(unit * 0.1, heightUnit * 0.4),
      unit * 0.2,
      primaryPaint,
    );
    canvas.drawCircle(
      Offset(unit * 1.05, heightUnit * 0.85),
      unit * 0.25,
      primaryPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
