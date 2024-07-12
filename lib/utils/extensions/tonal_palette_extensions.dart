import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

extension ToColor on TonalPalette {
  Color getColor(int tone) => Color(get(tone));
}
