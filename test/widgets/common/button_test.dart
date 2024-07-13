import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/extensions/tonal_palette_extensions.dart';
import 'package:intellicook_mobile/widgets/common/button.dart';
import 'package:intellicook_mobile/widgets/common/elevated.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<ButtonCallbacks>(), MockSpec<BuildContext>()])
import 'button_test.mocks.dart';

abstract class ButtonCallbacks {
  void onClick();

  void onPress();

  void onRelease();

  void onStateChange(bool isPressed);
}

void main() {
  testWidgets(
    'Button shows child',
    (WidgetTester tester) async {
      const testText = 'Test Text';

      await tester.pumpWidget(const Button(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(testText),
        ),
      ));

      expect(find.text(testText), findsOneWidget);
    },
  );

  testWidgets(
    'Button shows child with arguments when released',
    (WidgetTester tester) async {
      const pressedColor = Colors.red;
      const releasedColor = Colors.blue;
      final pressedBorder = Border.all(color: Colors.green);
      final releasedBorder = Border.all(color: Colors.orange);
      const testText = 'Test Text';

      await tester.pumpWidget(Button(
        pressedColor: pressedColor,
        releasedColor: releasedColor,
        pressedBorder: pressedBorder,
        releasedBorder: releasedBorder,
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Text(testText),
        ),
      ));

      expect(find.text(testText), findsOneWidget);

      final elevated = tester.widget(find.byType(Elevated)) as Elevated;
      expect(elevated.color, releasedColor);
      expect(elevated.border, releasedBorder);
    },
  );

  testWidgets(
    'Button shows child with arguments when pressed',
    (WidgetTester tester) async {
      const pressedColor = Colors.red;
      const releasedColor = Colors.blue;
      final pressedBorder = Border.all(color: Colors.green);
      final releasedBorder = Border.all(color: Colors.orange);
      const testText = 'Test Text';

      await tester.pumpWidget(Button(
        pressedColor: pressedColor,
        releasedColor: releasedColor,
        pressedBorder: pressedBorder,
        releasedBorder: releasedBorder,
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Text(testText),
        ),
      ));

      await tester.press(find.byType(Button));
      await tester.pumpAndSettle();

      expect(find.text(testText), findsOneWidget);

      final elevated = tester.widget(find.byType(Elevated)) as Elevated;
      expect(elevated.color, pressedColor);
      expect(elevated.border, pressedBorder);
    },
  );

  testWidgets(
    'Primary button shows child with defaults when released',
    (WidgetTester tester) async {
      final context = MockBuildContext();
      final pressedBorder = Border.all(color: Colors.green);
      final releasedBorder = Border.all(color: Colors.orange);
      const testText = 'Test Text';

      await tester.pumpWidget(MaterialApp(
        theme: IntelliCookTheme.theme(context, Brightness.light),
        home: Button.primary(
          pressedBorder: pressedBorder,
          releasedBorder: releasedBorder,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Text(testText),
          ),
        ),
      ));

      expect(find.text(testText), findsOneWidget);

      final elevated = tester.widget(find.byType(Elevated)) as Elevated;
      expect(
        elevated.color,
        IntelliCookTheme.primaryPalette.getColor(Button.releasedPaletteTone),
      );
      expect(elevated.border, releasedBorder);
    },
  );

  testWidgets(
    'Primary button shows child with defaults when pressed',
    (WidgetTester tester) async {
      final context = MockBuildContext();
      final pressedBorder = Border.all(color: Colors.green);
      final releasedBorder = Border.all(color: Colors.orange);
      const testText = 'Test Text';

      await tester.pumpWidget(MaterialApp(
        theme: IntelliCookTheme.theme(context, Brightness.light),
        home: Button.primary(
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

      final elevated = tester.widget(find.byType(Elevated)) as Elevated;
      expect(
        elevated.color,
        IntelliCookTheme.primaryPalette.getColor(Button.pressedPaletteTone),
      );
      expect(elevated.border, pressedBorder);
    },
  );

  testWidgets(
    'Secondary button shows child with defaults when released',
    (WidgetTester tester) async {
      final context = MockBuildContext();
      const pressedColor = Colors.red;
      const releasedColor = Colors.blue;
      const testText = 'Test Text';

      await tester.pumpWidget(MaterialApp(
        theme: IntelliCookTheme.theme(context, Brightness.light),
        home: Button.secondary(
          pressedColor: pressedColor,
          releasedColor: releasedColor,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Text(testText),
          ),
        ),
      ));

      expect(find.text(testText), findsOneWidget);

      final elevated = tester.widget(find.byType(Elevated)) as Elevated;
      expect(elevated.color, releasedColor);
      expect(
        elevated.border,
        Border.all(
          color: IntelliCookTheme.primaryPalette
              .getColor(Button.releasedPaletteTone),
          width: Button.secondaryBorderWidth,
        ),
      );
    },
  );

  testWidgets(
    'Secondary button shows child with defaults when pressed',
    (WidgetTester tester) async {
      final context = MockBuildContext();
      const pressedColor = Colors.red;
      const releasedColor = Colors.blue;
      const testText = 'Test Text';

      await tester.pumpWidget(MaterialApp(
        theme: IntelliCookTheme.theme(context, Brightness.light),
        home: Button.secondary(
          pressedColor: pressedColor,
          releasedColor: releasedColor,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Text(testText),
          ),
        ),
      ));

      await tester.press(find.byType(Button));
      await tester.pumpAndSettle();

      expect(find.text(testText), findsOneWidget);

      final elevated = tester.widget(find.byType(Elevated)) as Elevated;
      expect(elevated.color, pressedColor);
      expect(
        elevated.border,
        Border.all(
          color: IntelliCookTheme.primaryPalette
              .getColor(Button.pressedPaletteTone),
          width: Button.secondaryBorderWidth,
        ),
      );
    },
  );

  testWidgets(
    'Button calls onClick when clicked',
    (WidgetTester tester) async {
      final onClick = MockButtonCallbacks().onClick;

      await tester.pumpWidget(Button(
        onClick: onClick,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.tap(find.byType(Button));

      verify(onClick()).called(1);
    },
  );

  testWidgets(
    'Button calls onPress when pressed',
    (WidgetTester tester) async {
      final onPress = MockButtonCallbacks().onPress;

      await tester.pumpWidget(Button(
        onPress: onPress,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.press(find.byType(Button));

      verify(onPress()).called(1);
    },
  );

  testWidgets(
    'Button calls onRelease when released',
    (WidgetTester tester) async {
      final onRelease = MockButtonCallbacks().onRelease;

      await tester.pumpWidget(Button(
        onRelease: onRelease,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.tap(find.byType(Button));

      verify(onRelease()).called(1);
    },
  );

  testWidgets(
    'Button calls onStateChange when pressed',
    (WidgetTester tester) async {
      final onStateChange = MockButtonCallbacks().onStateChange;

      await tester.pumpWidget(Button(
        onStateChange: onStateChange,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.press(find.byType(Button));

      verify(onStateChange(true)).called(1);
    },
  );

  testWidgets(
    'Button calls onStateChange when released',
    (WidgetTester tester) async {
      final onStateChange = MockButtonCallbacks().onStateChange;

      await tester.pumpWidget(Button(
        onStateChange: onStateChange,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.tap(find.byType(Button));

      verify(onStateChange(false)).called(1);
    },
  );

  testWidgets(
    'Button calls onStateChange when cancelled',
    (WidgetTester tester) async {
      final onStateChange = MockButtonCallbacks().onStateChange;

      await tester.pumpWidget(Button(
        onStateChange: onStateChange,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.drag(find.byType(Button), const Offset(0.0, 100.0));

      verify(onStateChange(false)).called(1);
    },
  );
}
