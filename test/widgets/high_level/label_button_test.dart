import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures.dart';
@GenerateNiceMocks([MockSpec<LabelButtonCallbacks>()])
import 'label_button_test.mocks.dart';

abstract class LabelButtonCallbacks {
  void onClick();

  void onPress();

  void onRelease();

  void onStateChange(bool isPressed);
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
    'Label button calls onClick when clicked',
    (WidgetTester tester) async {
      final onClick = MockLabelButtonCallbacks().onClick;

      await tester.pumpWidget(MockMaterialApp(
        child: LabelButton(
          label: label,
          onClick: onClick,
        ),
      ));

      await tester.tap(find.text(label));

      verify(onClick()).called(1);
    },
  );

  testWidgets(
    'Label button calls onPress when pressed',
    (WidgetTester tester) async {
      final onPress = MockLabelButtonCallbacks().onPress;

      await tester.pumpWidget(MockMaterialApp(
        child: LabelButton(
          label: label,
          onPress: onPress,
        ),
      ));

      await tester.press(find.text(label));

      verify(onPress()).called(1);
    },
  );

  testWidgets(
    'Label button calls onRelease when released',
    (WidgetTester tester) async {
      final onRelease = MockLabelButtonCallbacks().onRelease;

      await tester.pumpWidget(MockMaterialApp(
        child: LabelButton(
          label: label,
          onRelease: onRelease,
        ),
      ));

      await tester.tap(find.text(label));

      verify(onRelease()).called(1);
    },
  );

  testWidgets(
    'Label button calls onStateChange when pressed',
    (WidgetTester tester) async {
      final onStateChange = MockLabelButtonCallbacks().onStateChange;

      await tester.pumpWidget(MockMaterialApp(
        child: LabelButton(
          label: label,
          onStateChange: onStateChange,
        ),
      ));

      await tester.press(find.text(label));

      verify(onStateChange(true)).called(1);
    },
  );

  testWidgets(
    'Label button calls onStateChange when released',
    (WidgetTester tester) async {
      final onStateChange = MockLabelButtonCallbacks().onStateChange;

      await tester.pumpWidget(MockMaterialApp(
        child: LabelButton(
          label: label,
          onStateChange: onStateChange,
        ),
      ));

      await tester.tap(find.text(label));

      verify(onStateChange(false)).called(1);
    },
  );

  testWidgets(
    'Label button calls onStateChange when cancelled',
    (WidgetTester tester) async {
      final onStateChange = MockLabelButtonCallbacks().onStateChange;

      await tester.pumpWidget(MockMaterialApp(
        child: LabelButton(
          label: label,
          onStateChange: onStateChange,
        ),
      ));

      await tester.drag(find.text(label), const Offset(0.0, 100.0));

      verify(onStateChange(false)).called(1);
    },
  );
}
