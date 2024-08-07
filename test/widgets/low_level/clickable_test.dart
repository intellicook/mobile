import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures.dart';
@GenerateNiceMocks([MockSpec<ClickableCallbacks>()])
import 'clickable_test.mocks.dart';

abstract class ClickableCallbacks {
  void onClicked();

  void onPressed();

  void onReleased();

  void onStateChanged(bool isPressed);
}

void main() {
  testWidgets(
    'Clickable shows child',
    (WidgetTester tester) async {
      await tester.pumpWidget(Clickable(
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);
    },
  );

  testWidgets(
    'Clickable calls onClicked when clicked',
    (WidgetTester tester) async {
      final onClicked = MockClickableCallbacks().onClicked;

      await tester.pumpWidget(Clickable(
        onClicked: onClicked,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.tap(find.byType(Clickable));

      verify(onClicked()).called(1);
    },
  );

  testWidgets(
    'Clickable calls onPressed when pressed',
    (WidgetTester tester) async {
      final onPressed = MockClickableCallbacks().onPressed;

      await tester.pumpWidget(Clickable(
        onPressed: onPressed,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.press(find.byType(Clickable));

      verify(onPressed()).called(1);
    },
  );

  testWidgets(
    'Clickable calls onReleased when released',
    (WidgetTester tester) async {
      final onReleased = MockClickableCallbacks().onReleased;

      await tester.pumpWidget(Clickable(
        onReleased: onReleased,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.tap(find.byType(Clickable));

      verify(onReleased()).called(1);
    },
  );

  testWidgets(
    'Clickable does not call onReleased when cancelled',
    (WidgetTester tester) async {
      final onReleased = MockClickableCallbacks().onReleased;

      await tester.pumpWidget(Clickable(
        onReleased: onReleased,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.drag(find.byType(Clickable), const Offset(0.0, 500.0));

      verifyNever(onReleased());
    },
  );

  testWidgets(
    'Clickable calls onStateChanged when pressed',
    (WidgetTester tester) async {
      final onStateChanged = MockClickableCallbacks().onStateChanged;

      await tester.pumpWidget(Clickable(
        onStateChanged: onStateChanged,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.press(find.byType(Clickable));

      verify(onStateChanged(true)).called(1);
    },
  );

  testWidgets(
    'Clickable calls onStateChanged when released',
    (WidgetTester tester) async {
      final onStateChanged = MockClickableCallbacks().onStateChanged;

      await tester.pumpWidget(Clickable(
        onStateChanged: onStateChanged,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.tap(find.byType(Clickable));

      verify(onStateChanged(false)).called(1);
    },
  );

  testWidgets(
    'Clickable calls onStateChanged when cancelled',
    (WidgetTester tester) async {
      final onStateChanged = MockClickableCallbacks().onStateChanged;

      await tester.pumpWidget(Clickable(
        onStateChanged: onStateChanged,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.drag(find.byType(Clickable), const Offset(0.0, 100.0));

      verify(onStateChanged(false)).called(1);
    },
  );
}
