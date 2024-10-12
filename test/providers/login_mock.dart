import 'dart:async';

import 'package:intellicook_mobile/providers/app_controller/login.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class MockLogin extends AutoDisposeAsyncNotifier<LoginState>
    with Mock
    implements Login {
  LoginState? buildReturn;

  @override
  Future<LoginState> build() async => buildReturn!;

  @override
  Future<void> login(
    String? username,
    String? password,
  ) async {}
}
