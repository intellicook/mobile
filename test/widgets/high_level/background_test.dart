import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/background.dart';

import '../../fixtures.dart';

void main() {
  testWidgets(
    'Background shows child',
    (WidgetTester tester) async {
      await tester.pumpWidget(Background(
        child: TextFixture.widget(),
      ));

      expect(find.text(TextFixture.text), findsOneWidget);
    },
  );
}
