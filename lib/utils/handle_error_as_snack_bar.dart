import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intellicook_mobile/utils/extensions/dio_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

Function(AsyncValue<T>?, AsyncValue<T>) handleErrorAsSnackBar<T>(
    BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return (previous, current) {
    if (current is AsyncError) {
      final error = current as AsyncError;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: switch (error.error) {
            DioException e => Text(
                e.toDisplayString(),
                style: TextStyle(
                  color: colorScheme.error,
                ),
              ),
            _ => Text(
                'An error occurred',
                style: TextStyle(
                  color: colorScheme.error,
                ),
              ),
          },
          duration: const Duration(seconds: 10),
          backgroundColor: colorScheme.errorContainer,
          showCloseIcon: true,
          closeIconColor: colorScheme.error,
        ),
      );
    }
  };
}
