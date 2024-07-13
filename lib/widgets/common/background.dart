import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/extensions/tonal_palette_extensions.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    this.child,
  });

  static const double blur = 64;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
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
    final primaryPaint = Paint()
      ..color = IntelliCookTheme.primaryPalette.getColor(80)
      ..style = PaintingStyle.fill;

    final secondaryPaint = Paint()
      ..color = IntelliCookTheme.secondaryPalette.getColor(70)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width, size.height * 0.2),
      size.width * 0.3,
      primaryPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.35),
      size.width * 0.15,
      secondaryPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.6),
      size.width * 0.4,
      secondaryPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.4),
      size.width * 0.2,
      primaryPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 1.05, size.height * 0.85),
      size.width * 0.25,
      primaryPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
