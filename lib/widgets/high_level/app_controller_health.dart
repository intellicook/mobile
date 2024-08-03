import 'package:app_controller_client/app_controller_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/indication.dart';
import 'package:intellicook_mobile/widgets/high_level/shimmer.dart';
import 'package:intellicook_mobile/widgets/high_level/shimmer_text.dart';

class AppControllerHealth extends StatelessWidget {
  const AppControllerHealth({
    super.key,
    required this.health,
  });

  final AsyncValue<HealthGetResponseModel> health;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    Widget healthStatusIcon(HealthStatusModel? status) {
      return Icon(
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
      );
    }

    return switch (health) {
      AsyncData(:final value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: healthStatusIcon(value.status),
              title: Text(
                switch (value.status) {
                  HealthStatusModel.healthy => 'App Controller is healthy',
                  HealthStatusModel.degraded => 'App Controller is degraded',
                  HealthStatusModel.unhealthy => 'App Controller is unhealthy',
                  _ => 'App Controller status is unknown',
                },
                style: textTheme.titleLarge,
              ),
            ),
            const Divider(),
            ListView.separated(
              shrinkWrap: true,
              itemCount: value.checks?.length ?? 0,
              itemBuilder: (context, index) {
                final check = value.checks![index];
                return ListTile(
                  leading: healthStatusIcon(check.status),
                  title: Text(check.name ?? 'Unknown'),
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
          ],
        ),
      AsyncError(:final error) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: healthStatusIcon(HealthStatusModel.unhealthy),
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
                leading: const Icon(Icons.circle),
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
                  return const ListTile(
                    leading: Icon(Icons.circle),
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: ShimmerText(
                        'Service Placeholder',
                      ),
                    ),
                    subtitle: Align(
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
