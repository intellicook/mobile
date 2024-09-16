import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';

import '../../fixtures.dart';

const title = 'Title';

void main() {
  testWidgets(
    'Background scaffold shows title and child',
    (WidgetTester tester) async {
      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: BackgroundScaffold(
            title: title,
            child: TextFixture.widget(),
          ),
        ),
      ));

      expect(find.text(title), findsOneWidget);
      expect(find.text(TextFixture.text), findsOneWidget);
    },
    skip: true, // TODO: Implement title
  );

  testWidgets(
    'Background scaffold shows title and child with arguments',
    (WidgetTester tester) async {
      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: BackgroundScaffold(
            title: title,
            padding: EdgeInsets.zero,
            child: TextFixture.widget(),
          ),
        ),
      ));

      expect(find.text(title), findsOneWidget);
      expect(find.text(TextFixture.text), findsOneWidget);
    },
    skip: true, // TODO: Implement title
  );
}
