import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/providers/theme.dart';
import 'package:intellicook_mobile/screens/app_controller_health.dart';
import 'package:intellicook_mobile/theme.dart';

void main() {
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
      themeMode: theme.value?.mode ?? ThemeMode.system,
      home: const AppControllerHealth(),
    );
  }
}
