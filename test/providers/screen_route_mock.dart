import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/providers/screen_route.dart';
import 'package:mockito/mockito.dart';

class MockScreenRoute extends AutoDisposeNotifier<ScreenRouteState>
    with Mock
    implements ScreenRoute {
  ScreenRouteState? buildReturn;

  @override
  ScreenRouteState build() => buildReturn!;

  @override
  void set(ScreenRouteState? route) {}
}
