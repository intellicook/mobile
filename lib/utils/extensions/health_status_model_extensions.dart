import 'package:app_controller_client/app_controller_client.dart';
import 'package:flutter/material.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/indication.dart';

extension HealthStatusModelExtensions on HealthStatusModel? {
  Color color(BuildContext context) {
    return switch (this) {
      HealthStatusModel.healthy => IntelliCookTheme.indicationColors
          .of(Theme.of(context).brightness)[Indication.success]!,
      HealthStatusModel.degraded => IntelliCookTheme.indicationColors
          .of(Theme.of(context).brightness)[Indication.warning]!,
      HealthStatusModel.unhealthy => IntelliCookTheme.indicationColors
          .of(Theme.of(context).brightness)[Indication.error]!,
      _ => IntelliCookTheme.indicationColors
          .of(Theme.of(context).brightness)[Indication.unknown]!,
    };
  }
}
