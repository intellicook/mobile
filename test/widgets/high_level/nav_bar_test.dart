import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/nav_bar.dart';

void main() {
  testWidgets('NavBar shows screens', (WidgetTester tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: NavBar(),
      ),
    );

    for (final (label, _) in NavBar.buttons) {
      expect(find.text(label), findsOneWidget);
    }
  });
}
