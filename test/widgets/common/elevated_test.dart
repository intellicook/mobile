import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/constants/shadow.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius_consts.dart';
import 'package:intellicook_mobile/widgets/common/elevated.dart';

void main() {
  testWidgets(
    'Elevated shows child',
    (WidgetTester tester) async {
      const testText = 'Test Text';

      await tester.pumpWidget(const Elevated(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(testText),
        ),
      ));

      expect(find.text(testText), findsOneWidget);
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
      const testText = 'Test Text';

      await tester.pumpWidget(Elevated(
        border: border,
        borderRadius: borderRadius,
        shadows: shadows,
        padding: padding,
        color: color,
        constraints: constraints,
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Text(testText),
        ),
      ));

      expect(find.text(testText), findsOneWidget);

      final container = tester.widget(find.byType(Container)) as Container;

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, border);
      expect(decoration.borderRadius, borderRadius);
      expect(decoration.color, color);
      expect(decoration.boxShadow, shadows);

      expect(container.constraints, constraints);
      expect(container.padding, padding);
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
      const animatedElevatedArgs = AnimatedElevatedArgs(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
      const testText = 'Test Text';

      await tester.pumpWidget(Elevated(
        border: border,
        borderRadius: borderRadius,
        shadows: shadows,
        padding: padding,
        color: color,
        constraints: constraints,
        animatedElevatedArgs: animatedElevatedArgs,
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Text(testText),
        ),
      ));

      expect(find.text(testText), findsOneWidget);

      final container =
          tester.widget(find.byType(AnimatedContainer)) as AnimatedContainer;

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, border);
      expect(decoration.borderRadius, borderRadius);
      expect(decoration.color, color);
      expect(decoration.boxShadow, shadows);

      expect(container.constraints, constraints);
      expect(container.padding, padding);
      expect(container.duration, animatedElevatedArgs.duration);
      expect(container.curve, animatedElevatedArgs.curve);
    },
  );

  testWidgets(
    'High elevated shows child with arguments and defaults',
    (WidgetTester tester) async {
      final border = Border.all(color: Colors.black);
      const padding = EdgeInsets.all(10);
      const color = Colors.red;
      const constraints = BoxConstraints.tightFor(width: 100, height: 100);
      const testText = 'Test Text';

      await tester.pumpWidget(Elevated.high(
        border: border,
        padding: padding,
        color: color,
        constraints: constraints,
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Text(testText),
        ),
      ));

      expect(find.text(testText), findsOneWidget);

      final container = tester.widget(find.byType(Container)) as Container;

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, border);
      expect(decoration.borderRadius, SmoothBorderRadiusConsts.l);
      expect(decoration.color, color);
      expect(decoration.boxShadow, ShadowConsts.high());

      expect(container.constraints, constraints);
      expect(container.padding, padding);
    },
  );

  testWidgets(
    'Low elevated shows child with arguments and defaults',
    (WidgetTester tester) async {
      final border = Border.all(color: Colors.black);
      const padding = EdgeInsets.all(10);
      const color = Colors.red;
      const constraints = BoxConstraints.tightFor(width: 100, height: 100);
      const testText = 'Test Text';

      await tester.pumpWidget(Elevated.low(
        border: border,
        padding: padding,
        color: color,
        constraints: constraints,
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Text(testText),
        ),
      ));

      expect(find.text(testText), findsOneWidget);

      final container = tester.widget(find.byType(Container)) as Container;

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, border);
      expect(decoration.borderRadius, SmoothBorderRadiusConsts.s);
      expect(decoration.color, color);
      expect(decoration.boxShadow, ShadowConsts.low());

      expect(container.constraints, constraints);
      expect(container.padding, padding);
    },
  );
}
