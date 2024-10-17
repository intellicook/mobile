import 'package:app_controller_client/app_controller_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/providers/app_controller/me.dart';
import 'package:intellicook_mobile/widgets/high_level/profile_account_panel.dart';

import '../../fixtures.dart';
import '../../providers/me_mock.dart';

void main() {
  testWidgets(
    'Profile account panel shows user name, username, and email',
    (WidgetTester tester) async {
      await tester.runAsync(() async {
        final meResponse = (UserGetResponseModelBuilder()
              ..name = 'John Doe'
              ..username = 'john_doe'
              ..email = 'john.doe@example.com'
              ..role = UserRoleModel.user)
            .build();

        final mockMe = MockMe();
        mockMe.buildReturn = meResponse;

        await tester.pumpWidget(
          MockMaterialApp(
            providerOverrides: [
              meProvider.overrideWith(() => mockMe),
            ],
            child: const ProfileAccountPanel(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining(meResponse.name), findsOneWidget);
        expect(find.textContaining(meResponse.username), findsOneWidget);
        expect(find.textContaining(meResponse.email), findsOneWidget);
      });
    },
  );
}
