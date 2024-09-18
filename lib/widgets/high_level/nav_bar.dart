import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/screen_route.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';

class NavBar extends ConsumerStatefulWidget {
  const NavBar({super.key});

  static const buttons = [
    ('Home', ScreenRouteState.home),
    ('Account', ScreenRouteState.account),
    ('Settings', ScreenRouteState.settings),
    ('Dev Tools', ScreenRouteState.devTools),
  ];

  @override
  ConsumerState createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SpacingConsts.m,
        0,
        SpacingConsts.m,
        SpacingConsts.m,
      ),
      child: Panel(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: NavBar.buttons
              .map(
                (button) => Clickable(
                  onClicked: () {
                    ref.read(screenRouteProvider.notifier).set(button.$2);
                  },
                  child: Text(button.$1),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
