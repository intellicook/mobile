import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/screen_router.dart';

void main() {
  for (final screen in ScreenRouter.screens.keys) {
    final widget = ScreenRouter.screens[screen]!;
    testWidgets(
      'Screen router shows $screen',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: widget,
          ),
        );

        expect(find.byType(widget.runtimeType), findsOneWidget);
      },
    );
  }
}
