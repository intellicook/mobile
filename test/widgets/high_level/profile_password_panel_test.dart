import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/profile_password_panel.dart';

import '../../fixtures.dart';

void main() {
  testWidgets(
    'Profile password panel shows heading',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MockMaterialApp(
          child: ProfilePasswordPanel(),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Password'), findsAtLeast(1));
    },
  );
}
