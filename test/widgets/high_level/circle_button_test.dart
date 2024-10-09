import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/circle_button.dart';
import 'package:intellicook_mobile/widgets/low_level/button.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures.dart';
@GenerateNiceMocks([MockSpec<CircleButtonCallbacks>()])
import 'circle_button_test.mocks.dart';

abstract class CircleButtonCallbacks {
  void onClicked();

  void onPressed();

  void onReleased();

  void onStateChanged(bool isPressed);
}

void main() {
  testWidgets(
    'Circle button with child and arguments',
    (WidgetTester tester) async {
      const label = 'child';
      const enabled = false;
      final onClicked = MockCircleButtonCallbacks().onClicked;
      final onPressed = MockCircleButtonCallbacks().onPressed;
      final onReleased = MockCircleButtonCallbacks().onReleased;
      final onStateChanged = MockCircleButtonCallbacks().onStateChanged;

      await tester.pumpWidget(MockMaterialApp(
        child: CircleButton(
          enabled: enabled,
          onClicked: onClicked,
          onPressed: onPressed,
          onReleased: onReleased,
          onStateChanged: onStateChanged,
          child: const Text(label),
        ),
      ));

      expect(find.text(label), findsOneWidget);

      final button = tester.widget<Button>(find.byType(Button));
      expect(button.enabled, enabled);
      expect(button.onClicked, onClicked);
      expect(button.onPressed, onPressed);
      expect(button.onReleased, onReleased);
      expect(button.onStateChanged, onStateChanged);
    },
  );

  testWidgets(
    'Circle button with arguments',
    (WidgetTester tester) async {
      const enabled = false;
      final onClicked = MockCircleButtonCallbacks().onClicked;
      final onPressed = MockCircleButtonCallbacks().onPressed;
      final onReleased = MockCircleButtonCallbacks().onReleased;
      final onStateChanged = MockCircleButtonCallbacks().onStateChanged;

      await tester.pumpWidget(MockMaterialApp(
        child: CircleButton(
          enabled: enabled,
          onClicked: onClicked,
          onPressed: onPressed,
          onReleased: onReleased,
          onStateChanged: onStateChanged,
        ),
      ));

      final button = tester.widget<Button>(find.byType(Button));
      expect(button.enabled, enabled);
      expect(button.onClicked, onClicked);
      expect(button.onPressed, onPressed);
      expect(button.onReleased, onReleased);
      expect(button.onStateChanged, onStateChanged);
    },
  );

  testWidgets(
    'Circle button calls onClicked when clicked',
    (WidgetTester tester) async {
      final onClicked = MockCircleButtonCallbacks().onClicked;

      await tester.pumpWidget(MockMaterialApp(
        child: CircleButton(
          onClicked: onClicked,
        ),
      ));

      await tester.tap(find.byType(Button));

      verify(onClicked()).called(1);
    },
  );

  testWidgets(
    'Circle button calls onPressed when pressed',
    (WidgetTester tester) async {
      final onPressed = MockCircleButtonCallbacks().onPressed;

      await tester.pumpWidget(MockMaterialApp(
        child: CircleButton(
          onPressed: onPressed,
        ),
      ));

      await tester.press(find.byType(Button));

      verify(onPressed()).called(1);
    },
  );

  testWidgets(
    'Circle button calls onReleased when released',
    (WidgetTester tester) async {
      final onReleased = MockCircleButtonCallbacks().onReleased;

      await tester.pumpWidget(MockMaterialApp(
        child: CircleButton(
          onReleased: onReleased,
        ),
      ));

      await tester.tap(find.byType(Button));

      verify(onReleased()).called(1);
    },
  );

  testWidgets(
    'Circle button calls onStateChanged when pressed',
    (WidgetTester tester) async {
      final onStateChanged = MockCircleButtonCallbacks().onStateChanged;

      await tester.pumpWidget(MockMaterialApp(
        child: CircleButton(
          onStateChanged: onStateChanged,
        ),
      ));

      await tester.press(find.byType(Button));

      verify(onStateChanged(true)).called(1);
    },
  );

  testWidgets(
    'Circle button calls onStateChanged when released',
    (WidgetTester tester) async {
      final onStateChanged = MockCircleButtonCallbacks().onStateChanged;

      await tester.pumpWidget(MockMaterialApp(
        child: CircleButton(
          onStateChanged: onStateChanged,
        ),
      ));

      await tester.tap(find.byType(Button));

      verify(onStateChanged(false)).called(1);
    },
  );

  testWidgets(
    'Circle button calls onStateChanged when cancelled',
    (WidgetTester tester) async {
      final onStateChanged = MockCircleButtonCallbacks().onStateChanged;

      await tester.pumpWidget(MockMaterialApp(
        child: CircleButton(
          onStateChanged: onStateChanged,
        ),
      ));

      await tester.drag(find.byType(Button), const Offset(0.0, 100.0));

      verify(onStateChanged(false)).called(1);
    },
  );
}
