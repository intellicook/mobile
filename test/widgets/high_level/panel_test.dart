import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

import '../../fixtures.dart';
import '../low_level/button_test.mocks.dart';

void main() {
  testWidgets(
    'Panel shows child',
    (WidgetTester tester) async {
      await tester.pumpWidget(Panel(
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);
    },
  );

  testWidgets(
    'Panel shows child with arguments',
    (WidgetTester tester) async {
      const padding = EdgeInsets.all(10);
      const color = Colors.red;
      const constraints = BoxConstraints.tightFor(width: 100, height: 100);

      await tester.pumpWidget(Panel(
        padding: padding,
        color: color,
        constraints: constraints,
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, color);

      expect(container.constraints, constraints);
      expect(container.padding, padding);
    },
  );

  testWidgets(
    'Panel shows child with arguments and defaults',
    (WidgetTester tester) async {
      final context = MockBuildContext();
      final theme = IntelliCookTheme.theme(context, Brightness.light);
      const padding = EdgeInsets.all(10);
      const constraints = BoxConstraints.tightFor(width: 100, height: 100);

      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Panel(
          padding: padding,
          constraints: constraints,
          child: TextFixture.widget(),
        ),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(
        decoration.color,
        theme.colorScheme.surfaceContainerLowest.withOpacity(Panel.opacity),
      );

      expect(container.constraints, constraints);
      expect(container.padding, padding);
    },
  );
}
