import 'package:flutter/material.dart' hide Switch;
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/label_toggle_switch.dart';
import 'package:intellicook_mobile/widgets/high_level/toggle_switch.dart';
import 'package:intellicook_mobile/widgets/low_level/toggle_switch_switch.flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures.dart';
@GenerateNiceMocks([MockSpec<LabelToggleSwitchCallbacks>()])
import 'label_toggle_switch_test.mocks.dart';

abstract class LabelToggleSwitchCallbacks {
  void onChanged(bool value);
}

const label = 'Label';

void main() {
  testWidgets(
    'Label toggle switch shows label',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MockMaterialApp(
        child: Material(
          child: LabelToggleSwitch(
            label: label,
          ),
        ),
      ));

      expect(find.text(label), findsOneWidget);
    },
  );

  for (final (value, enabled) in [
    (false, false),
    (false, true),
    (true, false),
    (true, true),
  ]) {
    testWidgets(
      'Label toggle switch propagates arguments to toggle switch when value is '
      '$value, enabled is $enabled',
      (WidgetTester tester) async {
        await tester.pumpWidget(MockMaterialApp(
          child: Material(
            child: LabelToggleSwitch(
              label: label,
              value: value,
              enabled: enabled,
            ),
          ),
        ));

        final toggleSwitch =
            tester.widget<ToggleSwitch>(find.byType(ToggleSwitch));
        expect(toggleSwitch.value, value);
        expect(toggleSwitch.enabled, enabled);
      },
    );
  }

  testWidgets(
    'Label toggle switch calls onChanged when switch is toggled',
    (WidgetTester tester) async {
      final onChanged = MockLabelToggleSwitchCallbacks().onChanged;

      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: LabelToggleSwitch(
            label: label,
            onChanged: onChanged,
          ),
        ),
      ));

      await tester.tap(find.byType(Switch));

      verify(onChanged(true)).called(1);
    },
  );
}
