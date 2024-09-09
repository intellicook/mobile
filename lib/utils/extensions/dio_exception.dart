import 'dart:collection';

import 'package:dio/dio.dart';

extension DioExceptionExtensions on DioException {
  String toDisplayString() {
    final statusCode = response?.statusCode;
    return switch (response?.data) {
      MapBase error => error['title'] ??
          error['details'] ??
          'A server error occurred (status ${statusCode ?? 'unknown'})',
      _ => 'A server error occurred (status ${statusCode ?? 'unknown'})',
    };
  }
}
