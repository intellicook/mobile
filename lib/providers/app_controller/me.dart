import 'package:app_controller_client/app_controller_client.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'me.g.dart';

@riverpod
class Me extends _$Me {
  @override
  Future<UserGetResponseModel> build() async {
    final appController = ref.watch(appControllerProvider);
    final api = appController.client.getUserApi();

    final response = await api.userMeGet();
    return response.data!;
  }
}
