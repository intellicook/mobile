import 'package:app_controller_client/app_controller_client.dart';
import 'package:dio/dio.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register.g.dart';

@riverpod
class Register extends _$Register {
  @override
  Future<RegisterState> build() async {
    return const RegisterState.none();
  }

  Future<void> register(
    String name,
    String email,
    String username,
    String password,
  ) async {
    final client = ref.read(appControllerProvider).client;
    final api = client.getAuthApi();
    state = const AsyncLoading();

    try {
      final requestBuilder = RegisterPostRequestModelBuilder()
        ..name = name
        ..email = email
        ..username = username
        ..password = password;

      await api.authRegisterPost(
        registerPostRequestModel: requestBuilder.build(),
      );

      state = const AsyncData(RegisterState.success());
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final problemDetails = e.response!.data as Map<String, dynamic>;
        if (problemDetails['errors'] is Map<String, dynamic>) {
          final errors = problemDetails['errors'] as Map<String, dynamic>;
          final errorMap = <RegisterStateErrorKey, List<String>>{};

          errorMap[RegisterStateErrorKey.name] =
              List<String>.from(errors['Name'] ?? []);
          errorMap[RegisterStateErrorKey.email] =
              List<String>.from(errors['Email'] ?? []);
          errorMap[RegisterStateErrorKey.username] =
              List<String>.from(errors['Username'] ?? []);
          errorMap[RegisterStateErrorKey.password] =
              List<String>.from(errors['Password'] ?? []);
          errorMap[RegisterStateErrorKey.unspecified] =
              List<String>.from(errors[''] ?? []);

          state = AsyncData(RegisterState.errors(errorMap));
          return;
        }
      }

      state = AsyncError(e, e.stackTrace);
      rethrow;
    }
  }
}

enum RegisterStateErrorKey {
  name,
  email,
  username,
  password,
  unspecified,
}

class RegisterState {
  const RegisterState.errors(this.errors) : success = false;

  const RegisterState.success()
      : success = true,
        errors = null;

  const RegisterState.none()
      : success = false,
        errors = null;

  final bool success;
  final Map<RegisterStateErrorKey, List<String>>? errors;

  bool get hasResponse => success || errors != null;

  String? firstErrorOrNull(RegisterStateErrorKey key) {
    return errors?[key]?.firstOrNull;
  }
}
