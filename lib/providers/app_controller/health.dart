import 'dart:collection';
import 'dart:io';

import 'package:app_controller_client/app_controller_client.dart';
import 'package:dio/dio.dart';
import 'package:intellicook_mobile/utils/app_controller_client.dart';
import 'package:intellicook_mobile/utils/fake_load_time.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health.g.dart';

@riverpod
class Health extends _$Health {
  @override
  Future<UnmodifiableListView<HealthGetResponseModel>> build() async {
    final api = appControllerClient.getHealthApi();

    try {
      final response = await fakeLoadTime(() => api.healthGet());
      return UnmodifiableListView(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.serviceUnavailable) {
        return UnmodifiableListView(e.response?.data);
      }

      rethrow;
    }
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
  }
}
