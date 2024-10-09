import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intellicook_mobile/utils/extensions/dio_exception.dart';
import 'package:intellicook_mobile/utils/show_error_snack_bar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

Function(AsyncValue<T>?, AsyncValue<T>) handleErrorAsSnackBar<T>(
  BuildContext context,
) {
  return (previous, current) {
    if (current is AsyncError) {
      final error = current as AsyncError;
      showErrorSnackBar(
        context,
        switch (error.error) {
          DioException e => e.toDisplayString(),
          _ => 'An error occurred',
        },
      );
    }
  };
}
