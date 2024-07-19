import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures.dart';
@GenerateNiceMocks([MockSpec<LabelButtonCallbacks>()])
import 'label_button_test.mocks.dart';

abstract class LabelButtonCallbacks {
  void onClicked();

  void onPressed();

  void onReleased();

  void onStateChanged(bool isPressed);
}

const label = 'Label';

void main() {
  for (final type in [
    LabelButtonType.primary,
    LabelButtonType.secondary,
  ]) {
    testWidgets(
      'Label button shows label with $type type',
      (WidgetTester tester) async {
        await tester.pumpWidget(MockMaterialApp(
          child: LabelButton(
            label: label,
            type: type,
          ),
        ));

        expect(find.text(label), findsOneWidget);
      },
    );
  }

  testWidgets(
    'Label button calls onClicked when clicked',
    (WidgetTester tester) async {
      final onClicked = MockLabelButtonCallbacks().onClicked;

      await tester.pumpWidget(MockMaterialApp(
        child: LabelButton(
          label: label,
          onClicked: onClicked,
        ),
      ));

      await tester.tap(find.text(label));

      verify(onClicked()).called(1);
    },
  );

  testWidgets(
    'Label button calls onPressed when pressed',
    (WidgetTester tester) async {
      final onPressed = MockLabelButtonCallbacks().onPressed;

      await tester.pumpWidget(MockMaterialApp(
        child: LabelButton(
          label: label,
          onPressed: onPressed,
        ),
      ));

      await tester.press(find.text(label));

      verify(onPressed()).called(1);
    },
  );

  testWidgets(
    'Label button calls onReleased when released',
    (WidgetTester tester) async {
      final onReleased = MockLabelButtonCallbacks().onReleased;

      await tester.pumpWidget(MockMaterialApp(
        child: LabelButton(
          label: label,
          onReleased: onReleased,
        ),
      ));

      await tester.tap(find.text(label));

      verify(onReleased()).called(1);
    },
  );

  testWidgets(
    'Label button calls onStateChanged when pressed',
    (WidgetTester tester) async {
      final onStateChanged = MockLabelButtonCallbacks().onStateChanged;

      await tester.pumpWidget(MockMaterialApp(
        child: LabelButton(
          label: label,
          onStateChanged: onStateChanged,
        ),
      ));

      await tester.press(find.text(label));

      verify(onStateChanged(true)).called(1);
    },
  );

  testWidgets(
    'Label button calls onStateChanged when released',
    (WidgetTester tester) async {
      final onStateChanged = MockLabelButtonCallbacks().onStateChanged;

      await tester.pumpWidget(MockMaterialApp(
        child: LabelButton(
          label: label,
          onStateChanged: onStateChanged,
        ),
      ));

      await tester.tap(find.text(label));

      verify(onStateChanged(false)).called(1);
    },
  );

  testWidgets(
    'Label button calls onStateChanged when cancelled',
    (WidgetTester tester) async {
      final onStateChanged = MockLabelButtonCallbacks().onStateChanged;

      await tester.pumpWidget(MockMaterialApp(
        child: LabelButton(
          label: label,
          onStateChanged: onStateChanged,
        ),
      ));

      await tester.drag(find.text(label), const Offset(0.0, 100.0));

      verify(onStateChanged(false)).called(1);
    },
  );
}
