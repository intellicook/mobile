import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intellicook_mobile/utils/extensions/tonal_palette.dart';
import 'package:intellicook_mobile/utils/indication.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class IntelliCookTheme {
  static ThemeData theme(BuildContext context, Brightness brightness) {
    var textTheme = createTextTheme(context, bodyFont, displayFont);
    var colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColorSeed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
    );
  }

  static const displayFont = 'Figtree';
  static const bodyFont = 'Roboto';
  static const primaryColorSeed = Color(0xffffa07a);
  static const secondaryColorSeed = Color(0xff7b68ee);
  static const colorDarkTone = 70;
  static const colorTone = 80;
  static const colorLightTone = 90;

  static final indicationColors = BrightnessDependent(
    light: {
      Indication.error: Colors.red.shade500,
      Indication.warning: Colors.orange.shade500,
      Indication.info: Colors.blue.shade500,
      Indication.debug: Colors.green.shade500,
      Indication.success: Colors.green.shade500,
      Indication.unknown: Colors.grey.shade500,
    },
    dark: {
      Indication.error: Colors.red.shade500,
      Indication.warning: Colors.orange.shade500,
      Indication.info: Colors.blue.shade500,
      Indication.debug: Colors.green.shade500,
      Indication.success: Colors.green.shade500,
      Indication.unknown: Colors.grey.shade500,
    },
  );

  static final primaryPalette = createTonalPalette(primaryColorSeed.value);
  static final primaryColorDark = primaryPalette.getColor(colorDarkTone);
  static final primaryColor = primaryPalette.getColor(colorTone);
  static final primaryColorLight = primaryPalette.getColor(colorLightTone);

  static final secondaryPalette = createTonalPalette(secondaryColorSeed.value);
  static final secondaryColorDark = secondaryPalette.getColor(colorDarkTone);
  static final secondaryColor = secondaryPalette.getColor(colorTone);
  static final secondaryColorLight = secondaryPalette.getColor(colorLightTone);
}

class BrightnessDependent<T> {
  const BrightnessDependent({
    required this.light,
    required this.dark,
  });

  final T light;
  final T dark;

  T of(Brightness brightness) {
    return brightness == Brightness.light ? light : dark;
  }
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

TonalPalette createTonalPalette(int value) {
  final color = Hct.fromInt(value);
  return TonalPalette.of(color.hue, color.chroma);
}
