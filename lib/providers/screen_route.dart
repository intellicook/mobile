import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'screen_route.g.dart';

@riverpod
class ScreenRoute extends _$ScreenRoute {
  @override
  ScreenRouteState build() {
    return ScreenRouteState.home;
  }

  void set(ScreenRouteState route) async {
    state = route;
  }
}

enum ScreenRouteState {
  home,
  profile,
  settings,
  devTools,
}
