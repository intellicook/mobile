import 'package:app_controller_client/app_controller_client.dart';
import 'package:dio/dio.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:intellicook_mobile/providers/app_controller/me.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'me_password_put.g.dart';

@riverpod
class MePasswordPut extends _$MePasswordPut {
  @override
  Future<MePasswordPutState> build() async {
    return const MePasswordPutState.none();
  }

  Future<void> put(String oldPassword, String newPassword) async {
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
      final requestBuilder = UserPasswordPutRequestModelBuilder()
        ..oldPassword = oldPassword
        ..newPassword = newPassword;

      await api.userMePasswordPut(
        userPasswordPutRequestModel: requestBuilder.build(),
      );

      state = const AsyncData(MePasswordPutState.success());
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final problemDetails = e.response!.data as Map<String, dynamic>;
        if (problemDetails['errors'] is Map<String, dynamic>) {
          final errors = problemDetails['errors'] as Map<String, dynamic>;

          final keyToErrorKey = <String, MePasswordPutStateErrorKey>{
            'OldPassword': MePasswordPutStateErrorKey.oldPassword,
            'NewPassword': MePasswordPutStateErrorKey.newPassword,
          };

          final errorMap = {
            for (final e in keyToErrorKey.entries)
              e.value: (List<String>.from(errors[e.key] ?? []))
          };
          errorMap[MePasswordPutStateErrorKey.unspecified] = List<String>.from(
            errors.entries
                .where((e) => !keyToErrorKey.containsKey(e.key))
                .map((e) => e.value)
                .expand((e) => e)
                .toList(),
          );

          state = AsyncData(MePasswordPutState.errors(errorMap));
          return;
        }
      }

      state = AsyncError(e, e.stackTrace);
      rethrow;
    }
  }
}

enum MePasswordPutStateErrorKey {
  oldPassword,
  newPassword,
  unspecified,
}

class MePasswordPutState {
  const MePasswordPutState.errors(this.errors) : success = false;

  const MePasswordPutState.success()
      : success = true,
        errors = null;

  const MePasswordPutState.none()
      : success = false,
        errors = null;

  final bool success;
  final Map<MePasswordPutStateErrorKey, List<String>>? errors;

  bool get hasResponse => success || errors != null;

  String? firstErrorOrNull(MePasswordPutStateErrorKey key) {
    return errors?[key]?.firstOrNull;
  }
}
