import 'package:app_controller_client/app_controller_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/providers/app_controller/set_user_profile.dart';

class MockSetUserProfile extends SetUserProfile {
  late SetUserProfilePostResponseModel? buildReturn;

  @override
  Future<SetUserProfilePostResponseModel?> build() async {
    return buildReturn;
  }

  @override
  Future<void> post(
    UserProfileVeggieIdentityModel veggieIdentity,
    Iterable<String> prefer,
    Iterable<String> dislike,
  ) async {
    state = const AsyncData(null);
  }
}
