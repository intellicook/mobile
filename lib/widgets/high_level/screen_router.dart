import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/providers/screen_route.dart';
import 'package:intellicook_mobile/screens/main/dev_tools.dart';
import 'package:intellicook_mobile/screens/nested/placeholder_screen.dart';

class ScreenRouter extends ConsumerStatefulWidget {
  const ScreenRouter({super.key});

  static const screens = [
    PlaceholderScreen(title: 'Home', background: false),
    PlaceholderScreen(title: 'Account', background: false),
    PlaceholderScreen(title: 'Settings', background: false),
    DevTools(),
  ];

  @override
  ConsumerState createState() => _ScreenRouterState();
}

class _ScreenRouterState extends ConsumerState<ScreenRouter> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(screenRouteProvider, (previous, current) {
      pageController.jumpToPage(
        current.index,
      );
    });

    void onPageChanged(int index) {
      ref
          .read(screenRouteProvider.notifier)
          .set(ScreenRouteState.values[index]);
    }

    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: ScreenRouter.screens,
    );
  }
}
