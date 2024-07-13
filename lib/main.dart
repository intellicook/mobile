import 'package:flutter/material.dart';
import 'package:intellicook_mobile/screens/component_gallery.dart';
import 'package:intellicook_mobile/theme.dart';

void main() {
  runApp(const IntelliCookApp());
}

class IntelliCookApp extends StatelessWidget {
  const IntelliCookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: IntelliCookTheme.theme(context, brightness),
      home: const ComponentGallery(),
    );
  }
}
