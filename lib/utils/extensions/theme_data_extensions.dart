import 'package:flutter/material.dart';

extension ThemeDataExtensions on ThemeData {
  Color get onMain => switch (brightness) {
        Brightness.light => colorScheme.onSurface,
        Brightness.dark => colorScheme.onInverseSurface,
      };
}
