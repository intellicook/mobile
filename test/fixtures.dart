import 'package:flutter/material.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<BuildContext>()])
import 'fixtures.mocks.dart';

class TextFixture {
  static const text = 'Test Text';

  static Widget widget({text = text}) => Directionality(
        textDirection: TextDirection.ltr,
        child: Text(text),
      );
}

class MockMaterialApp extends StatelessWidget {
  const MockMaterialApp({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final context = MockBuildContext();
    final theme = IntelliCookTheme.theme(context, Brightness.light);

    return MaterialApp(
      theme: theme,
      home: child,
    );
  }
}
