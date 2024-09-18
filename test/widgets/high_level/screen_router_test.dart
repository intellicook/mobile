import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/providers/screen_route.dart';
import 'package:intellicook_mobile/widgets/high_level/screen_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<ScreenRoute>()])
import 'screen_router_test.mocks.dart';

void main() {
  for (final (index, widget) in ScreenRouter.screens.indexed) {
    final state = ScreenRouteState.values[index];
    final provider = MockScreenRoute();

    when(provider.state).thenReturn(state);

    testWidgets(
      'Screen router shows $state',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              screenRouteProvider.overrideWith(() => provider),
            ],
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: widget,
            ),
          ),
        );

        expect(find.byType(widget.runtimeType), findsOneWidget);
      },
    );
  }
}
