import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/app.dart';
import 'package:intellicook_mobile/globals/camera.dart';
import 'package:intellicook_mobile/providers/theme.dart';
import 'package:intellicook_mobile/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initCameras();

  runApp(const ProviderScope(
    child: IntelliCookApp(),
  ));
}

class IntelliCookApp extends ConsumerWidget {
  const IntelliCookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'IntelliCook',
      theme: IntelliCookTheme.theme(context, Brightness.light),
      darkTheme: IntelliCookTheme.theme(context, Brightness.dark),
      themeMode: theme.mode,
      home: const App(),
    );
  }
}
