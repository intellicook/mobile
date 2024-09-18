import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/providers/screen_route.dart';
import 'package:intellicook_mobile/screens/main/dev_tools.dart';
import 'package:intellicook_mobile/screens/nested/placeholder_screen.dart';

class ScreenRouter extends ConsumerStatefulWidget {
  const ScreenRouter({super.key});

  static const screens = {
    ScreenRouteState.home: PlaceholderScreen(),
    ScreenRouteState.account: PlaceholderScreen(),
    ScreenRouteState.settings: PlaceholderScreen(),
    ScreenRouteState.devTools: DevTools(),
  };

  @override
  ConsumerState createState() => _ScreenRouterState();
}

class _ScreenRouterState extends ConsumerState<ScreenRouter> {
  @override
  Widget build(BuildContext context) {
    final screenRoute = ref.watch(screenRouteProvider);

    final screen = ScreenRouter.screens[screenRoute];

    if (screen == null) {
      ref.read(screenRouteProvider.notifier).set(ScreenRouteState.home);
    }

    return screen ?? const PlaceholderScreen();
  }
}
