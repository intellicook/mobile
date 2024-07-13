import 'package:figma_squircle/figma_squircle.dart';

class SmoothBorderRadiusConsts {
  static const sCornerRadius = 12.0;
  static const lCornerRadius = 24.0;
  static const cornerSmoothing = 0.6;

  static final s = SmoothBorderRadius(
    cornerRadius: sCornerRadius,
    cornerSmoothing: cornerSmoothing,
  );
  static final l = SmoothBorderRadius(
    cornerRadius: lCornerRadius,
    cornerSmoothing: cornerSmoothing,
  );
}
