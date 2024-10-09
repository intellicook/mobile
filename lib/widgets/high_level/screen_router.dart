import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/providers/screen_route.dart';
import 'package:intellicook_mobile/screens/main/dev_tools.dart';
import 'package:intellicook_mobile/screens/main/home_screen.dart';
import 'package:intellicook_mobile/screens/nested/placeholder_screen.dart';

class ScreenRouter extends ConsumerStatefulWidget {
  const ScreenRouter({
    super.key,
    this.screens = ScreenRouter.defaultScreens,
  });

  static const defaultScreens = [
    HomeScreen(),
    PlaceholderScreen(title: 'Profile', background: false),
    PlaceholderScreen(title: 'Settings', background: false),
    DevTools(),
  ];

  final List<Widget> screens;

  @override
  ConsumerState createState() => _ScreenRouterState();
}

class _ScreenRouterState extends ConsumerState<ScreenRouter> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    final screenRoute = ref.read(screenRouteProvider);
    pageController = PageController(initialPage: screenRoute.index);
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
      children: widget.screens,
    );
  }
}
