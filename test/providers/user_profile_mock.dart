import 'dart:async';

import 'package:app_controller_client/app_controller_client.dart';
import 'package:intellicook_mobile/providers/app_controller/user_profile.dart';

class MockUserProfile extends UserProfile {
  late UserProfileGetResponseModel buildReturn;

  @override
  Future<UserProfileGetResponseModel> build() async {
    return buildReturn;
  }
}

class MockUserProfileLoading extends UserProfile {
  @override
  Future<UserProfileGetResponseModel> build() async {
    return Completer<UserProfileGetResponseModel>().future;
  }
}
