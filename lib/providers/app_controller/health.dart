import 'dart:collection';
import 'dart:io';

import 'package:app_controller_client/app_controller_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:intellicook_mobile/globals/app_controller_client.dart';
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
        return UnmodifiableListView(standardSerializers.deserialize(
          e.response!.data,
          specifiedType:
              const FullType(BuiltList, [FullType(HealthGetResponseModel)]),
        ) as BuiltList<HealthGetResponseModel>);
      }

      rethrow;
    }
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
  }
}
