import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/drag_dropdown.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures.dart';
@GenerateNiceMocks([MockSpec<DragDropdownCallbacks>()])
import 'drag_dropdown_test.mocks.dart';

abstract class DragDropdownCallbacks {
  void onChanged(String value);
}

const values = ['Option 1', 'Option 2', 'Option 3'];

void main() {
  testWidgets(
    'Drag dropdown shows initial value',
    (WidgetTester tester) async {
      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: DragDropdown(
            initialValue: values[0],
            values: values,
          ),
        ),
      ));

      expect(find.text(values[0]), findsOneWidget);
      expect(find.text(values[1]), findsNothing);
      expect(find.text(values[2]), findsNothing);
    },
  );

  testWidgets(
    'Drag dropdown shows menu when held down',
    (WidgetTester tester) async {
      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: DragDropdown(
            initialValue: values[0],
            values: values,
          ),
        ),
      ));

      await tester.press(find.text(values[0]));
      await tester.pumpAndSettle();

      expect(find.text(values[0]), findsOneWidget);
      expect(find.text(values[1]), findsOneWidget);
      expect(find.text(values[2]), findsOneWidget);
    },
  );

  testWidgets(
    'Drag dropdown shows selected value when released',
    (WidgetTester tester) async {
      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: DragDropdown(
            initialValue: values[0],
            values: values,
          ),
        ),
      ));

      final gesture = await tester.press(find.text(values[0]));
      await tester.pumpAndSettle();

      // Not sure why this doesn't work, hence the hardcoded offset.
      // await gesture.moveTo(tester.getCenter(find.text(values[2])));
      await gesture.moveBy(const Offset(0, 400));
      await tester.pumpAndSettle();

      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text(values[0]), findsNothing);
      expect(find.text(values[1]), findsNothing);
      expect(find.text(values[2]), findsOneWidget);
    },
  );

  testWidgets(
    'Drag dropdown calls onChanged when released',
    (WidgetTester tester) async {
      final onChanged = MockDragDropdownCallbacks().onChanged;

      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: DragDropdown(
            initialValue: values[0],
            values: values,
            onChanged: onChanged,
          ),
        ),
      ));

      final gesture = await tester.press(find.text(values[0]));
      await tester.pumpAndSettle();

      // Not sure why this doesn't work, hence the hardcoded offset.
      // await gesture.moveTo(tester.getCenter(find.text(values[2])));
      await gesture.moveBy(const Offset(0, 400));
      await tester.pumpAndSettle();

      await gesture.up();
      await tester.pumpAndSettle();

      verify(onChanged(values[2])).called(1);
    },
  );
}
