import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/providers/screen_route.dart';
import 'package:intellicook_mobile/widgets/high_level/screen_router.dart';
import 'package:mockito/mockito.dart';

class _FakeAutoDisposeNotifierProviderRef<T> extends SmartFake
    implements AutoDisposeNotifierProviderRef<T> {
  _FakeAutoDisposeNotifierProviderRef(
    super.parent,
    super.parentInvocation,
  );
}

class MockScreenRoute extends AutoDisposeNotifier<ScreenRouteState>
    with Mock
    implements ScreenRoute {
  @override
  AutoDisposeNotifierProviderRef<ScreenRouteState> get ref =>
      (super.noSuchMethod(
        Invocation.getter(#ref),
        returnValue: _FakeAutoDisposeNotifierProviderRef<ScreenRouteState>(
          this,
          Invocation.getter(#ref),
        ),
        returnValueForMissingStub:
            _FakeAutoDisposeNotifierProviderRef<ScreenRouteState>(
          this,
          Invocation.getter(#ref),
        ),
      ) as AutoDisposeNotifierProviderRef<ScreenRouteState>);

  @override
  ScreenRouteState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: ScreenRouteState.home,
        returnValueForMissingStub: ScreenRouteState.home,
      ) as ScreenRouteState);

  @override
  set state(ScreenRouteState? value) => super.noSuchMethod(
        Invocation.setter(
          #state,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  ScreenRouteState build() => (super.noSuchMethod(
        Invocation.method(
          #build,
          [],
        ),
        returnValue: ScreenRouteState.home,
        returnValueForMissingStub: ScreenRouteState.home,
      ) as ScreenRouteState);

  @override
  void set(ScreenRouteState? route) => super.noSuchMethod(
        Invocation.method(
          #set,
          [route],
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool updateShouldNotify(
    ScreenRouteState? previous,
    ScreenRouteState? next,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateShouldNotify,
          [
            previous,
            next,
          ],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
}

const screens = [
  'Home',
  'Profile',
  'Settings',
  'Dev Tools',
];

void main() {
  for (final (index, label) in screens.indexed) {
    final state = ScreenRouteState.values[index];
    final provider = MockScreenRoute();

    when(provider.build()).thenReturn(state);

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
