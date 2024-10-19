import 'dart:collection';

import 'package:dio/dio.dart';

extension DioExceptionExtensions on DioException {
  String toDisplayString() {
    final statusCode = response?.statusCode;
    final defaultError =
        'An error occurred when connecting to server (status ${statusCode ?? 'unknown'})';

    return switch (response?.data) {
      MapBase error => switch (error['detail']) {
          String detail => detail,
          _ => 'An error occurred when connecting to server:\n'
              '${MapBase.mapToString(error)}\n'
              'If you are seeing this message, '
              'please report the issue to the developers.',
        },
      _ => defaultError,
    };
  }
}
