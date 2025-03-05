import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/dropdown.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures.dart';
@GenerateNiceMocks([MockSpec<DropdownCallbacks>()])
import 'dropdown_test.mocks.dart';

abstract class DropdownCallbacks {
  void onChanged(int? value);
}

// When finding the button or menu, we should expect at least one found
// because of https://github.com/flutter/flutter/issues/89905

void main() {
  testWidgets(
    'Dropdown shows label, hint, help',
    (WidgetTester tester) async {
      const labelText = 'Label text';
      const hintText = 'Hint text';
      const helpText = 'Help text';

      await tester.pumpWidget(const MockMaterialApp(
        child: Material(
          child: Dropdown(
            label: labelText,
            hint: hintText,
            help: helpText,
            entries: [],
          ),
        ),
      ));

      expect(find.text(labelText), findsOneWidget);
      expect(find.text(hintText), findsOneWidget);
      expect(find.text(helpText), findsOneWidget);
    },
  );

  testWidgets(
    'Dropdown shows error',
    (WidgetTester tester) async {
      const labelText = 'Label text';
      const hintText = 'Hint text';
      const helpText = 'Help text';
      const errorText = 'Error text';

      await tester.pumpWidget(const MockMaterialApp(
        child: Material(
          child: Dropdown(
            label: labelText,
            hint: hintText,
            help: helpText,
            error: errorText,
            entries: [],
          ),
        ),
      ));

      expect(find.text(errorText), findsOneWidget);
    },
  );

  testWidgets(
    'Dropdown shows menu when clicked',
    (WidgetTester tester) async {
      const labelText = 'Label text';
      const entries = [
        DropdownEntry<int>(
          value: 1,
          label: 'Option 1',
        ),
        DropdownEntry<int>(
          value: 2,
          label: 'Option 2',
        ),
      ];

      await tester.pumpWidget(const MockMaterialApp(
        child: Dropdown(
          label: labelText,
          entries: entries,
        ),
      ));

      await tester.tap(find.byType(Dropdown<int>));
      await tester.pumpAndSettle();

      expect(find.text('Option 1'), findsAtLeast(1));
      expect(find.text('Option 2'), findsAtLeast(1));
    },
  );

  testWidgets(
    'Dropdown shows initial value',
    (WidgetTester tester) async {
      const labelText = 'Label text';
      const entries = [
        DropdownEntry<int>(
          value: 1,
          label: 'Option 1',
        ),
        DropdownEntry<int>(
          value: 2,
          label: 'Option 2',
        ),
      ];
      const initialValue = 2;

      await tester.pumpWidget(const MockMaterialApp(
        child: Material(
          child: Dropdown(
            label: labelText,
            entries: entries,
            initialValue: initialValue,
          ),
        ),
      ));

      expect(find.text('Option 2'), findsAtLeastNWidgets(1));
    },
  );

  // Skipped due to the issue mentioned at the top of the file
  // Don't know how to solve this...
  testWidgets(
    'Dropdown calls onChanged when an entry is selected',
    (WidgetTester tester) async {
      const labelText = 'Label text';
      const entries = [
        DropdownEntry<int>(
          value: 1,
          label: 'Option 1',
        ),
        DropdownEntry<int>(
          value: 2,
          label: 'Option 2',
        ),
      ];
      final onChanged = MockDropdownCallbacks().onChanged;

      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: Dropdown(
            label: labelText,
            onChanged: onChanged,
            entries: entries,
          ),
        ),
      ));

      await tester.tap(find.byType(Dropdown<int>));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownMenuItem<int>).first);
      await tester.pumpAndSettle();

      verify(onChanged(any)).called(1);
    },
    skip: true,
  );
}
