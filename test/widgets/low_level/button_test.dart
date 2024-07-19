import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/widgets/low_level/button.dart';
import 'package:intellicook_mobile/widgets/low_level/elevated.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures.dart';
@GenerateNiceMocks([MockSpec<ButtonCallbacks>()])
import 'button_test.mocks.dart';

abstract class ButtonCallbacks {
  void onClicked();

  void onPressed();

  void onReleased();

  void onStateChanged(bool isPressed);
}

void main() {
  testWidgets(
    'Button shows child',
    (WidgetTester tester) async {
      await tester.pumpWidget(Button(
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);
    },
  );

  testWidgets(
    'Button shows child with arguments when released',
    (WidgetTester tester) async {
      const pressedColor = Colors.red;
      const releasedColor = Colors.blue;
      final pressedBorder = Border.all(color: Colors.green);
      final releasedBorder = Border.all(color: Colors.orange);
      const constraints = BoxConstraints.tightFor(width: 100, height: 100);
      const padding = EdgeInsets.all(10);
      const animatedElevatedArgs = AnimatedElevatedArgs(
        duration: Duration(milliseconds: 10),
        curve: Curves.linear,
      );

      await tester.pumpWidget(Button(
        pressedColor: pressedColor,
        releasedColor: releasedColor,
        pressedBorder: pressedBorder,
        releasedBorder: releasedBorder,
        constraints: constraints,
        padding: padding,
        animatedElevatedArgs: animatedElevatedArgs,
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);

      final elevated = tester.widget<Elevated>(find.byType(Elevated));
      expect(elevated.color, releasedColor);
      expect(elevated.border, releasedBorder);
      expect(elevated.constraints, constraints);
      expect(elevated.padding, padding);
      expect(elevated.animatedElevatedArgs, animatedElevatedArgs);
    },
  );

  testWidgets(
    'Button shows child with arguments when pressed',
    (WidgetTester tester) async {
      const pressedColor = Colors.red;
      const releasedColor = Colors.blue;
      final pressedBorder = Border.all(color: Colors.green);
      final releasedBorder = Border.all(color: Colors.orange);
      const constraints = BoxConstraints.tightFor(width: 100, height: 100);
      const padding = EdgeInsets.all(10);
      const animatedElevatedArgs = AnimatedElevatedArgs(
        duration: Duration(milliseconds: 10),
        curve: Curves.linear,
      );

      await tester.pumpWidget(Button(
        pressedColor: pressedColor,
        releasedColor: releasedColor,
        pressedBorder: pressedBorder,
        releasedBorder: releasedBorder,
        constraints: constraints,
        padding: padding,
        animatedElevatedArgs: animatedElevatedArgs,
        child: TextFixture.widget(),
      ));

      await tester.press(find.byType(Button));
      await tester.pumpAndSettle();

      expect(find.text(TextFixture.text), findsOneWidget);

      final elevated = tester.widget<Elevated>(find.byType(Elevated));
      expect(elevated.color, pressedColor);
      expect(elevated.border, pressedBorder);
      expect(elevated.constraints, constraints);
      expect(elevated.padding, padding);
      expect(elevated.animatedElevatedArgs, animatedElevatedArgs);
    },
  );

  testWidgets(
    'Primary button shows child with arguments and defaults when released',
    (WidgetTester tester) async {
      final pressedBorder = Border.all(color: Colors.green);
      final releasedBorder = Border.all(color: Colors.orange);
      const testText = 'Test Text';

      await tester.pumpWidget(MockMaterialApp(
        child: Button.primary(
          pressedBorder: pressedBorder,
          releasedBorder: releasedBorder,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Text(testText),
          ),
        ),
      ));

      expect(find.text(testText), findsOneWidget);

      final elevated = tester.widget<Elevated>(find.byType(Elevated));
      expect(
        elevated.color,
        IntelliCookTheme.primaryColor,
      );
      expect(elevated.border, releasedBorder);
      expect(elevated.constraints, Button.defaultConstraints);
      expect(elevated.padding, Button.defaultPadding);
      expect(elevated.animatedElevatedArgs, Button.defaultAnimatedElevatedArgs);
    },
  );

  testWidgets(
    'Primary button shows child with arguments and defaults when pressed',
    (WidgetTester tester) async {
      final pressedBorder = Border.all(color: Colors.green);
      final releasedBorder = Border.all(color: Colors.orange);
      const testText = 'Test Text';

      await tester.pumpWidget(MockMaterialApp(
        child: Button.primary(
          pressedBorder: pressedBorder,
          releasedBorder: releasedBorder,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Text(testText),
          ),
        ),
      ));

      await tester.press(find.byType(Button));
      await tester.pumpAndSettle();

      expect(find.text(testText), findsOneWidget);

      final elevated = tester.widget<Elevated>(find.byType(Elevated));
      expect(
        elevated.color,
        IntelliCookTheme.primaryColorDark,
      );
      expect(elevated.border, pressedBorder);
      expect(elevated.constraints, Button.defaultConstraints);
      expect(elevated.padding, Button.defaultPadding);
      expect(elevated.animatedElevatedArgs, Button.defaultAnimatedElevatedArgs);
    },
  );

  testWidgets(
    'Secondary button shows child with arguments and defaults when released',
    (WidgetTester tester) async {
      const testText = 'Test Text';

      await tester.pumpWidget(MockMaterialApp(
        child: Button.secondary(
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Text(testText),
          ),
        ),
      ));

      expect(find.text(testText), findsOneWidget);

      final elevated = tester.widget<Elevated>(find.byType(Elevated));
      expect(
        elevated.border,
        Border.all(
          color: IntelliCookTheme.primaryColor,
          width: Button.secondaryBorderWidth,
        ),
      );
      expect(elevated.constraints, Button.defaultConstraints);
      expect(elevated.padding, Button.defaultPadding);
      expect(elevated.animatedElevatedArgs, Button.defaultAnimatedElevatedArgs);
    },
  );

  testWidgets(
    'Secondary button shows child with arguments and defaults when pressed',
    (WidgetTester tester) async {
      const testText = 'Test Text';

      await tester.pumpWidget(MockMaterialApp(
        child: Button.secondary(
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Text(testText),
          ),
        ),
      ));

      await tester.press(find.byType(Button));
      await tester.pumpAndSettle();

      expect(find.text(testText), findsOneWidget);

      final elevated = tester.widget<Elevated>(find.byType(Elevated));
      expect(
        elevated.border,
        Border.all(
          color: IntelliCookTheme.primaryColorDark,
          width: Button.secondaryBorderWidth,
        ),
      );
      expect(elevated.constraints, Button.defaultConstraints);
      expect(elevated.padding, Button.defaultPadding);
      expect(elevated.animatedElevatedArgs, Button.defaultAnimatedElevatedArgs);
    },
  );

  testWidgets(
    'Button calls onClicked when clicked',
    (WidgetTester tester) async {
      final onClicked = MockButtonCallbacks().onClicked;

      await tester.pumpWidget(Button(
        onClicked: onClicked,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.tap(find.byType(Button));

      verify(onClicked()).called(1);
    },
  );

  testWidgets(
    'Button calls onPressed when pressed',
    (WidgetTester tester) async {
      final onPressed = MockButtonCallbacks().onPressed;

      await tester.pumpWidget(Button(
        onPressed: onPressed,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.press(find.byType(Button));

      verify(onPressed()).called(1);
    },
  );

  testWidgets(
    'Button calls onReleased when released',
    (WidgetTester tester) async {
      final onReleased = MockButtonCallbacks().onReleased;

      await tester.pumpWidget(Button(
        onReleased: onReleased,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.tap(find.byType(Button));

      verify(onReleased()).called(1);
    },
  );

  testWidgets(
    'Button calls onStateChanged when pressed',
    (WidgetTester tester) async {
      final onStateChanged = MockButtonCallbacks().onStateChanged;

      await tester.pumpWidget(Button(
        onStateChanged: onStateChanged,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.press(find.byType(Button));

      verify(onStateChanged(true)).called(1);
    },
  );

  testWidgets(
    'Button calls onStateChanged when released',
    (WidgetTester tester) async {
      final onStateChanged = MockButtonCallbacks().onStateChanged;

      await tester.pumpWidget(Button(
        onStateChanged: onStateChanged,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.tap(find.byType(Button));

      verify(onStateChanged(false)).called(1);
    },
  );

  testWidgets(
    'Button calls onStateChanged when cancelled',
    (WidgetTester tester) async {
      final onStateChanged = MockButtonCallbacks().onStateChanged;

      await tester.pumpWidget(Button(
        onStateChanged: onStateChanged,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.drag(find.byType(Button), const Offset(0.0, 100.0));

      verify(onStateChanged(false)).called(1);
    },
  );
}
