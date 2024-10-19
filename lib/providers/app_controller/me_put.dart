import 'package:app_controller_client/app_controller_client.dart';
import 'package:dio/dio.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:intellicook_mobile/providers/app_controller/me.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'me_put.g.dart';

@riverpod
class MePut extends _$MePut {
  @override
  Future<MePutState> build() async {
    return const MePutState.none();
  }

  Future<void> put(String name, String email, String username) async {
    final appController = ref.watch(appControllerProvider);
    final me = ref.watch(meProvider);
    final api = appController.client.getUserApi();
    state = const AsyncLoading();

    if (me is! AsyncData) {
      final e = StateError('Me is not loaded');
      state = AsyncError(e, StackTrace.current);
      throw e;
    }

    try {
      if (me.value!.name == name &&
          me.value!.email == email &&
          me.value!.username == username) {
        final response = UserPutResponseModelBuilder()
          ..accessToken = appController.accessToken;
        state = AsyncData(MePutState.response(response.build()));
        return;
      }

      final requestBuilder = UserPutRequestModelBuilder()
        ..name = name
        ..email = email
        ..username = username;

      final response = await api.userMePut(
        userPutRequestModel: requestBuilder.build(),
      );

      state = AsyncData(MePutState.response(response.data!));
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final problemDetails = e.response!.data as Map<String, dynamic>;
        if (problemDetails['errors'] is Map<String, dynamic>) {
          final errors = problemDetails['errors'] as Map<String, dynamic>;
          final errorMap = <MePutStateErrorKey, List<String>>{};

          errorMap[MePutStateErrorKey.name] =
              List<String>.from(errors['Name'] ?? []);
          errorMap[MePutStateErrorKey.email] =
              List<String>.from(errors['Email'] ?? []);
          errorMap[MePutStateErrorKey.username] =
              List<String>.from(errors['Username'] ?? []);
          errorMap[MePutStateErrorKey.unspecified] =
              List<String>.from(errors[''] ?? []);

          state = AsyncData(MePutState.errors(errorMap));
          return;
        }
      }

      state = AsyncError(e, e.stackTrace);
      rethrow;
    }
  }
}

enum MePutStateErrorKey {
  name,
  email,
  username,
  unspecified,
}

class MePutState {
  const MePutState.errors(this.errors) : response = null;

  const MePutState.response(UserPutResponseModel this.response) : errors = null;

  const MePutState.none()
      : response = null,
        errors = null;

  final UserPutResponseModel? response;
  final Map<MePutStateErrorKey, List<String>>? errors;

  bool get hasResponse => response != null || errors != null;

  String? firstErrorOrNull(MePutStateErrorKey key) {
    return errors?[key]?.firstOrNull;
  }
}
