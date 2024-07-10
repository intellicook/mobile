import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class IntelliCookTheme {
  static ThemeData theme(BuildContext context, Brightness brightness) {
    var textTheme = createTextTheme(context, bodyFont, displayFont);
    var colorScheme = createColorScheme(colorSchemeSeed, brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
    );
  }

  static const displayFont = "Figtree";
  static const bodyFont = "Roboto";
  static const colorSchemeSeed = Color(0xffffa07a);

  /// Contrast Color
  static const contrastColor = ExtendedColor(
    seed: Color(0xff7b68ee),
    value: Color(0xff7b68ee),
    light: ColorFamily(
      color: Color(0xff5e5791),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffe5deff),
      onColorContainer: Color(0xff1b1249),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff5e5791),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffe5deff),
      onColorContainer: Color(0xff1b1249),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff5e5791),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffe5deff),
      onColorContainer: Color(0xff1b1249),
    ),
    dark: ColorFamily(
      color: Color(0xffc8bfff),
      onColor: Color(0xff30285f),
      colorContainer: Color(0xff473f77),
      onColorContainer: Color(0xffe5deff),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffc8bfff),
      onColor: Color(0xff30285f),
      colorContainer: Color(0xff473f77),
      onColorContainer: Color(0xffe5deff),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffc8bfff),
      onColor: Color(0xff30285f),
      colorContainer: Color(0xff473f77),
      onColorContainer: Color(0xffe5deff),
    ),
  );
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

ColorScheme createColorScheme(
  Color seedColor,
  Brightness brightness,
) {
  return ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  );
}

TextTheme createTextTheme(
  BuildContext context,
  String bodyFontString,
  String displayFontString,
) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme =
      GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
  TextTheme displayTextTheme =
      GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}
