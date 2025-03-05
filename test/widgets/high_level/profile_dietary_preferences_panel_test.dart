import 'package:app_controller_client/app_controller_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/providers/app_controller/set_user_profile.dart';
import 'package:intellicook_mobile/providers/app_controller/user_profile.dart';
import 'package:intellicook_mobile/widgets/high_level/profile_dietary_preferences_panel.dart';

import '../../fixtures.dart';
import '../../providers/set_user_profile_mock.dart';
import '../../providers/user_profile_mock.dart';

void main() {
  testWidgets(
    'Profile dietary preferences panel shows heading and diet type',
    (WidgetTester tester) async {
      await tester.runAsync(() async {
        final userProfileResponse = (UserProfileGetResponseModelBuilder()
              ..veggieIdentity = UserProfileVeggieIdentityModel.vegetarian
              ..prefer = ListBuilder(['Broccoli', 'Spinach'])
              ..dislike = ListBuilder(['Mushrooms', 'Eggplant']))
            .build();

        final mockUserProfile = MockUserProfile();
        mockUserProfile.buildReturn = userProfileResponse;

        final mockSetUserProfile = MockSetUserProfile();

        await tester.pumpWidget(
          MockMaterialApp(
            providerOverrides: [
              userProfileProvider.overrideWith(() => mockUserProfile),
              setUserProfileProvider.overrideWith(() => mockSetUserProfile),
            ],
            child: const ProfileDietaryPreferencesPanel(),
          ),
        );
        await tester.pumpAndSettle();

        // Check for heading
        expect(find.text('Dietary Preferences'), findsOneWidget);

        // Check for diet type dropdown
        expect(find.text('Diet Type'), findsOneWidget);

        // Check for food preferences sections
        expect(find.text('Preferred Foods'), findsOneWidget);
        expect(find.text('Disliked Foods'), findsOneWidget);

        // Check if preferred foods are displayed
        expect(find.text('Broccoli'), findsOneWidget);
        expect(find.text('Spinach'), findsOneWidget);

        // Check if disliked foods are displayed
        expect(find.text('Mushrooms'), findsOneWidget);
        expect(find.text('Eggplant'), findsOneWidget);
      });
    },
  );

  testWidgets(
    'Profile dietary preferences panel shows shimmer when loading',
    (WidgetTester tester) async {
      final mockUserProfile = MockUserProfileLoading();
      final mockSetUserProfile = MockSetUserProfile();

      await tester.pumpWidget(
        MockMaterialApp(
          providerOverrides: [
            userProfileProvider.overrideWith(() => mockUserProfile),
            setUserProfileProvider.overrideWith(() => mockSetUserProfile),
          ],
          child: const ProfileDietaryPreferencesPanel(),
        ),
      );
      await tester.pump();

      // In loading state we should still see the section headings
      expect(find.text('Dietary Preferences'), findsOneWidget);
      expect(find.text('Diet Type'), findsOneWidget);
      expect(find.text('Preferred Foods'), findsOneWidget);
      expect(find.text('Disliked Foods'), findsOneWidget);
    },
  );
}
