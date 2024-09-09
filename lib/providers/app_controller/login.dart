import 'dart:io';

import 'package:app_controller_client/app_controller_client.dart';
import 'package:dio/dio.dart';
import 'package:intellicook_mobile/utils/app_controller_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login.g.dart';

@riverpod
class Login extends _$Login {
  @override
  Future<LoginState> build() async {
    return const LoginState.none();
  }

  Future<void> login(String username, String password) async {
    final api = appControllerClient.getAuthApi();
    state = const AsyncLoading();

    try {
      final requestBuilder = LoginPostRequestModelBuilder()
        ..username = username
        ..password = password;

      final response = await api.authLoginPost(
        loginPostRequestModel: requestBuilder.build(),
      );

      state = AsyncData(LoginState.response(response.data));
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.unauthorized) {
        state = const AsyncData(LoginState.invalidCredentials());
        return;
      }

      state = AsyncError(e, e.stackTrace);
      rethrow;
    }
  }
}

class LoginState {
  const LoginState.response(this.response) : invalidCredentials = false;

  const LoginState.invalidCredentials()
      : response = null,
        invalidCredentials = true;

  const LoginState.none()
      : response = null,
        invalidCredentials = false;

  final LoginPostResponseModel? response;
  final bool invalidCredentials;

  bool get hasResponse => response != null || invalidCredentials;
}
