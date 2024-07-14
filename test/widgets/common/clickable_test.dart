import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/common/clickable.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures.dart';
@GenerateNiceMocks([MockSpec<ClickableCallbacks>()])
import 'clickable_test.mocks.dart';

abstract class ClickableCallbacks {
  void onClick();

  void onPress();

  void onRelease();

  void onStateChange(bool isPressed);
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
    'Clickable calls onClick when clicked',
    (WidgetTester tester) async {
      final onClick = MockClickableCallbacks().onClick;

      await tester.pumpWidget(Clickable(
        onClick: onClick,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.tap(find.byType(Clickable));

      verify(onClick()).called(1);
    },
  );

  testWidgets(
    'Clickable calls onPress when pressed',
    (WidgetTester tester) async {
      final onPress = MockClickableCallbacks().onPress;

      await tester.pumpWidget(Clickable(
        onPress: onPress,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.press(find.byType(Clickable));

      verify(onPress()).called(1);
    },
  );

  testWidgets(
    'Clickable calls onRelease when released',
    (WidgetTester tester) async {
      final onRelease = MockClickableCallbacks().onRelease;

      await tester.pumpWidget(Clickable(
        onRelease: onRelease,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.tap(find.byType(Clickable));

      verify(onRelease()).called(1);
    },
  );

  testWidgets(
    'Clickable calls onStateChange when pressed',
    (WidgetTester tester) async {
      final onStateChange = MockClickableCallbacks().onStateChange;

      await tester.pumpWidget(Clickable(
        onStateChange: onStateChange,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.press(find.byType(Clickable));

      verify(onStateChange(true)).called(1);
    },
  );

  testWidgets(
    'Clickable calls onStateChange when released',
    (WidgetTester tester) async {
      final onStateChange = MockClickableCallbacks().onStateChange;

      await tester.pumpWidget(Clickable(
        onStateChange: onStateChange,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.tap(find.byType(Clickable));

      verify(onStateChange(false)).called(1);
    },
  );

  testWidgets(
    'Clickable calls onStateChange when cancelled',
    (WidgetTester tester) async {
      final onStateChange = MockClickableCallbacks().onStateChange;

      await tester.pumpWidget(Clickable(
        onStateChange: onStateChange,
        child: const ColoredBox(
          color: Colors.red,
          child: SizedBox.square(dimension: 100.0),
        ),
      ));

      await tester.drag(find.byType(Clickable), const Offset(0.0, 100.0));

      verify(onStateChange(false)).called(1);
    },
  );
}
