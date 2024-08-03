import 'dart:io';

import 'package:app_controller_client/app_controller_client.dart';
import 'package:dio/dio.dart';
import 'package:intellicook_mobile/utils/app_controller_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health.g.dart';

@riverpod
class Health extends _$Health {
  @override
  Future<HealthGetResponseModel> build() async {
    final api = appControllerClient.getHealthApi();

    try {
      final response = await api.healthGet();
      return response.data!;
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.serviceUnavailable) {
        return e.response?.data as HealthGetResponseModel;
      }

      rethrow;
    }
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
  }
}
