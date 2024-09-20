import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/nav_bar.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';
import 'package:rive/rive.dart';

void main() {
  testWidgets(
    'Nav bar show buttons and rive animation',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: NavBar(),
          ),
        ),
      );

      expect(find.byType(RiveAnimation), findsNWidgets(4));
      expect(find.byType(Clickable), findsNWidgets(4));
    },
    // Rive animation tests not working
    // https://github.com/rive-app/rive-flutter/issues/417
    // https://github.com/rive-app/rive-flutter/issues/354
    skip: true,
  );
}
