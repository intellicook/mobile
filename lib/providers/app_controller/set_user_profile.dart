import 'package:app_controller_client/app_controller_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:intellicook_mobile/providers/app_controller/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_user_profile.g.dart';

@riverpod
class SetUserProfile extends _$SetUserProfile {
  @override
  Future<SetUserProfilePostResponseModel?> build() async {
    return null;
  }

  Future<void> post(
    UserProfileVeggieIdentityModel veggieIdentity,
    Iterable<String> prefer,
    Iterable<String> dislike,
  ) async {
    final appController = ref.watch(appControllerProvider);
    final userProfile = ref.watch(userProfileProvider);
    final api = appController.client.getRecipeSearchApi();
    state = const AsyncLoading();

    if (userProfile is! AsyncData) {
      final e = StateError('User profile is not loaded');
      state = AsyncError(e, StackTrace.current);
      throw e;
    }

    final requestBuilder = SetUserProfilePostRequestModelBuilder()
      ..veggieIdentity = veggieIdentity
      ..prefer = ListBuilder(prefer)
      ..dislike = ListBuilder(dislike);

    final response = await api.recipeSearchSetUserProfilePost(
      setUserProfilePostRequestModel: requestBuilder.build(),
    );

    state = AsyncData(response.data!);
  }
}
