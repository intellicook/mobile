import 'dart:collection';

import 'package:app_controller_client/app_controller_client.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/indication.dart';
import 'package:intellicook_mobile/widgets/high_level/shimmer.dart';
import 'package:intellicook_mobile/widgets/high_level/shimmer_text.dart';

class AppControllerHealth extends StatelessWidget {
  const AppControllerHealth({
    super.key,
    required this.health,
  });

  final AsyncValue<UnmodifiableListView<HealthGetResponseModel>> health;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    Widget healthStatusIcon(
      HealthStatusModel? status, {
      bool large = false,
    }) {
      const smallIconSize = SpacingConsts.ml;
      const largeIconSize = smallIconSize + SpacingConsts.m;

      if (status == null) {
        return SizedBox(
          width: largeIconSize,
          height: largeIconSize,
          child: Icon(
            Icons.circle,
            size: large ? largeIconSize : smallIconSize,
          ),
        );
      }

      return SizedBox(
        width: largeIconSize,
        height: largeIconSize,
        child: Icon(
          switch (status) {
            HealthStatusModel.healthy => Icons.check_circle,
            HealthStatusModel.degraded => Icons.error,
            HealthStatusModel.unhealthy => Icons.error,
            _ => Icons.help,
          },
          color: switch (status) {
            HealthStatusModel.healthy => IntelliCookTheme.indicationColors
                .of(theme.brightness)[Indication.success]!,
            HealthStatusModel.degraded => IntelliCookTheme.indicationColors
                .of(theme.brightness)[Indication.warning]!,
            HealthStatusModel.unhealthy => IntelliCookTheme.indicationColors
                .of(theme.brightness)[Indication.error]!,
            _ => IntelliCookTheme.indicationColors
                .of(theme.brightness)[Indication.unknown]!,
          },
          size: large ? largeIconSize : smallIconSize,
        ),
      );
    }

    List<Widget> healthStatus(HealthGetResponseModel value) {
      return [
        ListTile(
          leading: healthStatusIcon(value.status, large: true),
          title: Text(
            switch (value.status) {
              HealthStatusModel.healthy =>
                '${value.service.name.toNoCase().toTitleCase()} is healthy',
              HealthStatusModel.degraded =>
                '${value.service.name.toNoCase().toTitleCase()} is degraded',
              HealthStatusModel.unhealthy =>
                '${value.service.name.toNoCase().toTitleCase()} is unhealthy',
              _ =>
                '${value.service.name.toNoCase().toTitleCase()} status is unknown',
            },
            style: textTheme.titleLarge,
          ),
        ),
        const Divider(),
        ListView.separated(
          shrinkWrap: true,
          itemCount: value.checks.length,
          itemBuilder: (context, index) {
            final check = value.checks[index];
            return ListTile(
              leading: healthStatusIcon(check.status),
              title: Text(check.name),
              subtitle: Text(switch (value.status) {
                HealthStatusModel.healthy => 'Healthy',
                HealthStatusModel.degraded => 'Degraded',
                HealthStatusModel.unhealthy => 'Unhealthy',
                _ => 'Unknown',
              }),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
        const Divider(),
      ];
    }

    return switch (health) {
      AsyncData(:final value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: value.expand(healthStatus).toList(),
        ),
      AsyncError(:final error) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: healthStatusIcon(
                HealthStatusModel.unhealthy,
                large: true,
              ),
              title: Text(
                'App Controller is unreachable',
                style: textTheme.titleLarge,
              ),
            ),
            const Divider(),
            Text('$error'),
          ],
        ),
      _ => Shimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: healthStatusIcon(null, large: true),
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: ShimmerText(
                    'App Controller is healthy',
                    style: textTheme.titleLarge,
                  ),
                ),
              ),
              const Divider(),
              ListView.separated(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: healthStatusIcon(null),
                    title: const Align(
                      alignment: Alignment.centerLeft,
                      child: ShimmerText(
                        'Service Placeholder',
                      ),
                    ),
                    subtitle: const Align(
                      alignment: Alignment.centerLeft,
                      child: ShimmerText(
                        'Healthy',
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
              const Divider(),
              ListTile(
                leading: healthStatusIcon(null, large: true),
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: ShimmerText(
                    'App Controller is healthy',
                    style: textTheme.titleLarge,
                  ),
                ),
              ),
              const Divider(),
              ListView.separated(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: healthStatusIcon(null),
                    title: const Align(
                      alignment: Alignment.centerLeft,
                      child: ShimmerText(
                        'Service Placeholder',
                      ),
                    ),
                    subtitle: const Align(
                      alignment: Alignment.centerLeft,
                      child: ShimmerText(
                        'Healthy',
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ],
          ),
        ),
    };
  }
}
