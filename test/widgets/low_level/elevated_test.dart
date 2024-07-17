import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/low_level/elevated.dart';

import '../../fixtures.dart';

void main() {
  testWidgets(
    'Elevated shows child',
    (WidgetTester tester) async {
      await tester.pumpWidget(Elevated(
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);
    },
  );

  testWidgets(
    'Elevated shows child with arguments',
    (WidgetTester tester) async {
      final border = Border.all(color: Colors.black);
      final borderRadius = SmoothBorderRadius(cornerRadius: 10);
      final shadows = <BoxShadow>[
        const BoxShadow(
          color: Colors.black,
          blurRadius: 10,
        ),
      ];
      const padding = EdgeInsets.all(10);
      const color = Colors.red;
      const constraints = BoxConstraints.tightFor(width: 100, height: 100);
      const clipBehavior = Clip.none;

      await tester.pumpWidget(Elevated(
        border: border,
        borderRadius: borderRadius,
        shadows: shadows,
        padding: padding,
        color: color,
        constraints: constraints,
        clipBehavior: clipBehavior,
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, border);
      expect(decoration.borderRadius, borderRadius);
      expect(decoration.color, color);
      expect(decoration.boxShadow, shadows);

      expect(container.constraints, constraints);
      expect(container.padding, padding);
      expect(container.clipBehavior, clipBehavior);
    },
  );

  testWidgets(
    'Animated elevated shows child with arguments',
    (WidgetTester tester) async {
      final border = Border.all(color: Colors.black);
      final borderRadius = SmoothBorderRadius(cornerRadius: 10);
      final shadows = <BoxShadow>[
        const BoxShadow(
          color: Colors.black,
          blurRadius: 10,
        ),
      ];
      const padding = EdgeInsets.all(10);
      const color = Colors.red;
      const constraints = BoxConstraints.tightFor(width: 100, height: 100);
      const clipBehavior = Clip.none;
      const animatedElevatedArgs = AnimatedElevatedArgs(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );

      await tester.pumpWidget(Elevated(
        border: border,
        borderRadius: borderRadius,
        shadows: shadows,
        padding: padding,
        color: color,
        constraints: constraints,
        clipBehavior: clipBehavior,
        animatedElevatedArgs: animatedElevatedArgs,
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);

      final container =
          tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, border);
      expect(decoration.borderRadius, borderRadius);
      expect(decoration.color, color);
      expect(decoration.boxShadow, shadows);

      expect(container.constraints, constraints);
      expect(container.padding, padding);
      expect(container.clipBehavior, clipBehavior);
      expect(container.duration, animatedElevatedArgs.duration);
      expect(container.curve, animatedElevatedArgs.curve);
    },
  );

  testWidgets(
    'Animated elevated shows child with arguments and defaults',
    (WidgetTester tester) async {
      final border = Border.all(color: Colors.black);
      final borderRadius = SmoothBorderRadius(cornerRadius: 10);
      final shadows = <BoxShadow>[
        const BoxShadow(
          color: Colors.black,
          blurRadius: 10,
        ),
      ];
      const color = Colors.red;
      const constraints = BoxConstraints.tightFor(width: 100, height: 100);
      const animatedElevatedArgs = AnimatedElevatedArgs();

      await tester.pumpWidget(Elevated(
        border: border,
        borderRadius: borderRadius,
        shadows: shadows,
        color: color,
        constraints: constraints,
        animatedElevatedArgs: animatedElevatedArgs,
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);

      final container =
          tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, border);
      expect(decoration.borderRadius, borderRadius);
      expect(decoration.color, color);
      expect(decoration.boxShadow, shadows);

      expect(container.constraints, constraints);
      expect(container.padding, Elevated.defaultPadding);
      expect(container.clipBehavior, Elevated.defaultClipBehavior);
      expect(container.duration, animatedElevatedArgs.duration);
      expect(container.curve, animatedElevatedArgs.curve);
    },
  );

  testWidgets(
    'High elevated shows child with arguments and defaults',
    (WidgetTester tester) async {
      final border = Border.all(color: Colors.black);
      const color = Colors.red;
      const constraints = BoxConstraints.tightFor(width: 100, height: 100);

      await tester.pumpWidget(Elevated.high(
        border: border,
        color: color,
        constraints: constraints,
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, border);
      expect(decoration.borderRadius, Elevated.highBorderRadius);
      expect(decoration.color, color);
      expect(decoration.boxShadow, Elevated.highShadows());

      expect(container.constraints, constraints);
      expect(container.padding, Elevated.defaultPadding);
      expect(container.clipBehavior, Elevated.defaultClipBehavior);
    },
  );

  testWidgets(
    'High elevated shows child with inset shadow',
    (WidgetTester tester) async {
      await tester.pumpWidget(Elevated.high(
        insetShadow: true,
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, Elevated.highShadows(inset: true));
    },
  );

  testWidgets(
    'Low elevated shows child with arguments and defaults',
    (WidgetTester tester) async {
      final border = Border.all(color: Colors.black);
      const color = Colors.red;
      const constraints = BoxConstraints.tightFor(width: 100, height: 100);

      await tester.pumpWidget(Elevated.low(
        border: border,
        color: color,
        constraints: constraints,
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, border);
      expect(decoration.borderRadius, Elevated.lowBorderRadius);
      expect(decoration.color, color);
      expect(decoration.boxShadow, Elevated.lowShadows());

      expect(container.constraints, constraints);
      expect(container.padding, Elevated.defaultPadding);
      expect(container.clipBehavior, Elevated.defaultClipBehavior);
    },
  );

  testWidgets(
    'Low elevated shows child with inset shadow',
    (WidgetTester tester) async {
      await tester.pumpWidget(Elevated.low(
        insetShadow: true,
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, Elevated.lowShadows(inset: true));
    },
  );
}
