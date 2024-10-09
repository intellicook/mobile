import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String message) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: colorScheme.error,
        ),
      ),
      duration: const Duration(seconds: 10),
      backgroundColor: colorScheme.errorContainer,
      showCloseIcon: true,
      closeIconColor: colorScheme.error,
    ),
  );
}
