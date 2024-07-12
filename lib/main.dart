import 'package:flutter/material.dart';
import 'package:intellicook_mobile/screens/component_gallery.dart';
import 'package:intellicook_mobile/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
