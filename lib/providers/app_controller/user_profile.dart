import 'package:app_controller_client/app_controller_client.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile.g.dart';

@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<UserProfileGetResponseModel> build() async {
    final appController = ref.watch(appControllerProvider);
    final api = appController.client.getRecipeSearchApi();

    final response = await api.recipeSearchUserProfileGet();
    return response.data!;
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
  }
}
