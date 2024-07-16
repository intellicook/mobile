import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/common/input_field.dart';

import '../../fixtures.dart';

void main() {
  testWidgets(
    'InputField shows label, hint, help, counter',
    (WidgetTester tester) async {
      const labelText = 'Label text';
      const hintText = 'Hint text';
      const helpText = 'Help text';
      const counterText = 'Counter text';

      await tester.pumpWidget(const MockMaterialApp(
        child: Material(
          child: InputField(
            label: labelText,
            hint: hintText,
            help: helpText,
            counter: counterText,
          ),
        ),
      ));

      expect(find.text(labelText), findsOneWidget);
      expect(find.text(hintText), findsOneWidget);
      expect(find.text(helpText), findsOneWidget);
      expect(find.text(counterText), findsOneWidget);
    },
  );

  testWidgets(
    'InputField shows error',
    (WidgetTester tester) async {
      const labelText = 'Label text';
      const hintText = 'Hint text';
      const helpText = 'Help text';
      const counterText = 'Counter text';
      const errorText = 'Error text';

      await tester.pumpWidget(const MockMaterialApp(
        child: Material(
          child: InputField(
            label: labelText,
            hint: hintText,
            help: helpText,
            counter: counterText,
            error: errorText,
          ),
        ),
      ));

      expect(find.text(errorText), findsOneWidget);
    },
  );
}
