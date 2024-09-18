import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/providers/screen_route.dart';
import 'package:intellicook_mobile/widgets/high_level/screen_router.dart';

void main() {
  for (final (index, widget) in ScreenRouter.screens.indexed) {
    final screen = ScreenRouteState.values[index];
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
