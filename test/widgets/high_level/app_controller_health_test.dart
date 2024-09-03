import 'dart:collection';

import 'package:app_controller_client/app_controller_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/app_controller_health.dart';
import 'package:intellicook_mobile/widgets/high_level/shimmer.dart';

import '../../fixtures.dart';

void main() {
  testWidgets(
    'AppControllerHealth shows health status when status is healthy',
    (WidgetTester tester) async {
      final health = AsyncValue.data(UnmodifiableListView([
        (HealthGetResponseModelBuilder()
              ..service = HealthServiceModel.appController
              ..status = HealthStatusModel.healthy
              ..checks = ListBuilder([
                (HealthCheckModelBuilder()
                      ..name = 'check1'
                      ..status = HealthStatusModel.healthy)
                    .build(),
              ]))
            .build()
      ]));

      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: AppControllerHealth(health: health),
        ),
      ));

      expect(find.text('App Controller is healthy'), findsOneWidget);
      expect(find.text('check1'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
    },
  );

  testWidgets(
    'AppControllerHealth shows health status when status is degraded',
    (WidgetTester tester) async {
      final health = AsyncValue.data(UnmodifiableListView([
        (HealthGetResponseModelBuilder()
              ..service = HealthServiceModel.appController
              ..status = HealthStatusModel.degraded
              ..checks = ListBuilder([
                (HealthCheckModelBuilder()
                      ..name = 'check1'
                      ..status = HealthStatusModel.degraded)
                    .build(),
              ]))
            .build()
      ]));

      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: AppControllerHealth(health: health),
        ),
      ));

      expect(find.text('App Controller is degraded'), findsOneWidget);
      expect(find.text('check1'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsNWidgets(2));
    },
  );

  testWidgets(
    'AppControllerHealth shows health status when status is unhealthy',
    (WidgetTester tester) async {
      final health = AsyncValue.data(UnmodifiableListView([
        (HealthGetResponseModelBuilder()
              ..service = HealthServiceModel.appController
              ..status = HealthStatusModel.unhealthy
              ..checks = ListBuilder([
                (HealthCheckModelBuilder()
                      ..name = 'check1'
                      ..status = HealthStatusModel.unhealthy)
                    .build(),
              ]))
            .build()
      ]));

      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: AppControllerHealth(health: health),
        ),
      ));

      expect(find.text('App Controller is unhealthy'), findsOneWidget);
      expect(find.text('check1'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsNWidgets(2));
    },
  );

  testWidgets(
    'AppControllerHealth shows errors when status is unreachable',
    (WidgetTester tester) async {
      const errorReason = 'any error reason';
      final health =
          AsyncValue<UnmodifiableListView<HealthGetResponseModel>>.error(
        DioException.connectionError(
          requestOptions: RequestOptions(),
          reason: errorReason,
        ),
        StackTrace.empty,
      );

      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: AppControllerHealth(health: health),
        ),
      ));

      expect(find.text('App Controller is unreachable'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.textContaining(errorReason), findsOneWidget);
    },
  );

  testWidgets(
    'AppControllerHealth shows shimmers when status is loading',
    (WidgetTester tester) async {
      const health =
          AsyncValue<UnmodifiableListView<HealthGetResponseModel>>.loading();

      await tester.pumpWidget(const MockMaterialApp(
        child: Material(
          child: AppControllerHealth(health: health),
        ),
      ));

      expect(find.byType(Shimmer), findsAny);
    },
  );
}
