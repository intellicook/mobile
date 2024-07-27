import 'package:flutter/material.dart' hide Switch;
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/toggle_switch.dart';
import 'package:intellicook_mobile/widgets/low_level/toggle_switch_switch.flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures.dart';
@GenerateNiceMocks([MockSpec<ToggleSwitchCallbacks>()])
import 'toggle_switch_test.mocks.dart';

abstract class ToggleSwitchCallbacks {
  void onChanged(bool value);
}

void main() {
  for (final (value, enabled) in [
    (false, false),
    (false, true),
    (true, false),
    (true, true),
  ]) {
    testWidgets(
      'Toggle switch propagates arguments to switch when value is $value, '
      'enabled is $enabled',
      (WidgetTester tester) async {
        await tester.pumpWidget(MockMaterialApp(
          child: Material(
            child: ToggleSwitch(
              value: value,
              enabled: enabled,
            ),
          ),
        ));

        final switchWidget = tester.widget<Switch>(find.byType(Switch));
        expect(switchWidget.value, value);
        expect(switchWidget.onChanged, enabled ? isNotNull : isNull);
      },
    );
  }

  testWidgets(
    'Toggle switch calls onChanged when switch is toggled',
    (WidgetTester tester) async {
      final onChanged = MockToggleSwitchCallbacks().onChanged;

      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: ToggleSwitch(
            onChanged: onChanged,
          ),
        ),
      ));

      await tester.tap(find.byType(Switch));

      verify(onChanged(true)).called(1);
    },
  );

  testWidgets(
    'Toggle switch updates value when switch is toggled',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MockMaterialApp(
        child: Material(
          child: ToggleSwitch(),
        ),
      ));

      final initialSwitchWidget = tester.widget<Switch>(find.byType(Switch));
      final initialValue = initialSwitchWidget.value;

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, !initialValue);
    },
  );
}
