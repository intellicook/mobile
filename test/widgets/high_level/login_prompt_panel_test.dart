import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/providers/app_controller/login.dart';
import 'package:intellicook_mobile/screens/nested/login_screen.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/login_prompt_panel.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures.dart';
import '../../fixtures.mocks.dart';
import '../../providers/login_mock.dart';

void main() {
  testWidgets(
    'Login prompt panel shows label and push on click',
    (WidgetTester tester) async {
      final mockLogin = MockLogin();
      mockLogin.buildReturn = const LoginState.none();

      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MockMaterialApp(
          providerOverrides: [
            loginProvider.overrideWith(() => mockLogin),
          ],
          navigatorObservers: [mockObserver],
          child: const LoginPromptPanel(),
        ),
      );

      expect(find.text('Login'), findsOneWidget);

      await tester.tap(find.widgetWithText(LabelButton, 'Login'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(LoginScreen), findsOneWidget);
    },
  );
}
