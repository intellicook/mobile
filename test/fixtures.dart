import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<NavigatorObserver>(), MockSpec<BuildContext>()])
import 'fixtures.mocks.dart';

class TextFixture {
  static const text = 'Test Text';

  static Widget widget({text = text}) => Directionality(
        textDirection: TextDirection.ltr,
        child: Text(text),
      );
}

class MockMaterialApp extends StatelessWidget {
  /// For providing a MaterialApp with the IntelliCook theme.
  const MockMaterialApp({
    super.key,
    this.brightness = defaultBrightness,
    this.navigatorObservers = defaultNavigatorObservers,
    this.providerOverrides = defaultProviderOverrides,
    required this.child,
  });

  static const defaultBrightness = Brightness.light;
  static const defaultNavigatorObservers = <NavigatorObserver>[];
  static const defaultProviderOverrides = <Override>[];

  final Brightness brightness;
  final List<NavigatorObserver> navigatorObservers;
  final List<Override> providerOverrides;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final context = MockBuildContext();
    final theme = IntelliCookTheme.theme(context, brightness);

    return ProviderScope(
      overrides: providerOverrides,
      child: MaterialApp(
        navigatorObservers: navigatorObservers,
        theme: theme,
        home: child,
      ),
    );
  }
}
