import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/screen_route.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';
import 'package:rive/rive.dart';

class NavBar extends ConsumerStatefulWidget {
  const NavBar({super.key});

  @override
  ConsumerState createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  late Map<ScreenRouteState, _NavBarIcon> icons;

  @override
  void initState() {
    super.initState();
    icons = {
      for (var state in ScreenRouteState.values) state: _NavBarIcon(state)
    };
  }

  @override
  void dispose() {
    for (final icon in icons.values) {
      icon.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;
    final textTheme = theme.textTheme;

    final screenRoute = ref.watch(screenRouteProvider);

    final iconColor = textTheme.titleLarge?.color ??
        appBarTheme.foregroundColor ??
        (theme.brightness == Brightness.light ? Colors.black : Colors.white);
    for (final icon in icons.values) {
      icon.setColor(iconColor);
    }

    const states = [
      ScreenRouteState.home,
      ScreenRouteState.profile,
      ScreenRouteState.settings,
      ScreenRouteState.devTools,
    ];

    void onIconClicked(ScreenRouteState state) {
      icons[state]!.activate();
      ref.read(screenRouteProvider.notifier).set(state);
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: SpacingConsts.m,
        bottom: SpacingConsts.m,
        right: SpacingConsts.m,
      ),
      child: Panel(
        padding: const EdgeInsets.all(SpacingConsts.s),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: states.map(
            (state) {
              final isActive = screenRoute == state;
              return Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isActive ? 24 : 0,
                        height: 4,
                        decoration: BoxDecoration(
                          color: IntelliCookTheme.primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: Opacity(
                          opacity: isActive ? 1 : 0.5,
                          child: icons[state]!.animation,
                        ),
                      ),
                    ],
                  ),
                  Positioned.fill(
                    child: Clickable(
                      onClicked: () => onIconClicked(state),
                      child: const ColoredBox(color: Colors.transparent),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

class _NavBarIcon {
  _NavBarIcon(ScreenRouteState state) {
    final model = navBarIconRiveModels[state]!;
    animation = RiveAnimation.asset(
      model.src,
      artboard: model.artboard,
      fit: BoxFit.fill,
      alignment: Alignment.center,
      onInit: (artboard) {
        _artboard = artboard;
        _controller = StateMachineController.fromArtboard(
          artboard,
          model.stateMachine,
        );

        if (_controller == null) {
          throw Exception('State machine controller not found');
        }
        artboard.addController(_controller!);

        _trigger = _controller!.getTriggerInput('activate');

        if (_trigger == null) {
          throw Exception('Trigger not found');
        }
      },
    );
  }

  void dispose() {
    _controller?.dispose();
  }

  late RiveAnimation animation;
  Artboard? _artboard;
  StateMachineController? _controller;
  SMITrigger? _trigger;

  void activate() {
    _trigger?.fire();
  }

  void setColor(Color color) {
    _artboard?.forEachComponent((child) {
      if (child is Shape) {
        for (var stroke in child.strokes) {
          stroke.paint.color = color;
        }
      }
    });
  }
}

class _RiveModel {
  const _RiveModel({
    required this.src,
    required this.artboard,
    required this.stateMachine,
  });

  final String src;
  final String artboard;
  final String stateMachine;
}

const navBarIconRiveModels = {
  ScreenRouteState.home: _RiveModel(
    src: 'assets/nav_bar_icons.riv',
    artboard: 'home',
    stateMachine: 'home_state_machine',
  ),
  ScreenRouteState.profile: _RiveModel(
    src: 'assets/nav_bar_icons.riv',
    artboard: 'profile',
    stateMachine: 'profile_state_machine',
  ),
  ScreenRouteState.settings: _RiveModel(
    src: 'assets/nav_bar_icons.riv',
    artboard: 'settings',
    stateMachine: 'settings_state_machine',
  ),
  ScreenRouteState.devTools: _RiveModel(
    src: 'assets/nav_bar_icons.riv',
    artboard: 'dev_tools',
    stateMachine: 'dev_tools_state_machine',
  ),
};
