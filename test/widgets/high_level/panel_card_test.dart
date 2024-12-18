import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/panel_card.dart';

import '../../fixtures.dart';

void main() {
  testWidgets(
    'Panel card shows children',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MockMaterialApp(
        child: Material(
          child: PanelCard(
            child: Text('Child'),
          ),
        ),
      ));

      expect(find.text('Child'), findsOneWidget);
    },
  );
}
