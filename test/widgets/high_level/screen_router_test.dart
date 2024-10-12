import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/providers/screen_route.dart';
import 'package:intellicook_mobile/widgets/high_level/screen_router.dart';

import '../../providers/screen_route_mock.dart';

const screens = [
  'Home',
  'Profile',
  'Settings',
  'Dev Tools',
];

void main() {
  for (final (index, label) in screens.indexed) {
    final state = ScreenRouteState.values[index];
    final mockScreenRoute = MockScreenRoute();
    mockScreenRoute.buildReturn = state;

    testWidgets(
      'Screen router shows $state',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              screenRouteProvider.overrideWith(() => mockScreenRoute),
            ],
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ScreenRouter(
                screens: screens.map((label) => Text(label)).toList(),
              ),
            ),
          ),
        );

        expect(find.text(label), findsOneWidget);
      },
    );
  }
}
