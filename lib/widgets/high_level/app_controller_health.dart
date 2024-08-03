import 'package:app_controller_client/app_controller_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/utils/extensions/health_status_model_extensions.dart';

class AppControllerHealth extends StatelessWidget {
  const AppControllerHealth({
    super.key,
    required this.health,
  });

  final AsyncValue<HealthGetResponseModel> health;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget healthStatusIcon(HealthStatusModel? status) {
      return Icon(
        switch (status) {
          HealthStatusModel.healthy => Icons.check_circle,
          HealthStatusModel.degraded => Icons.error,
          HealthStatusModel.unhealthy => Icons.error,
          _ => Icons.help,
        },
        color: status.color(context),
      );
    }

    return switch (health) {
      AsyncData(:final value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: textTheme.titleLarge,
                children: switch (value.status) {
                  HealthStatusModel.healthy => [
                      WidgetSpan(child: healthStatusIcon(value.status)),
                      const TextSpan(text: ' App Controller is healthy'),
                    ],
                  HealthStatusModel.degraded => [
                      WidgetSpan(child: healthStatusIcon(value.status)),
                      const TextSpan(text: ' App Controller is degraded'),
                    ],
                  HealthStatusModel.unhealthy => [
                      WidgetSpan(child: healthStatusIcon(value.status)),
                      const TextSpan(text: ' App Controller is unhealthy'),
                    ],
                  _ => [
                      WidgetSpan(child: healthStatusIcon(value.status)),
                      const TextSpan(text: ' App Controller status is unknown'),
                    ],
                },
              ),
            ),
            const Divider(),
            ListView.separated(
              padding: EdgeInsets.zero,
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
      AsyncError(:final error) =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(
            text: TextSpan(
              style: textTheme.titleLarge,
              children: [
                WidgetSpan(
                  child: healthStatusIcon(HealthStatusModel.unhealthy),
                ),
                const TextSpan(text: ' App Controller is unreachable '),
              ],
            ),
          ),
          const Divider(),
          Text('$error'),
        ]),
      _ => const LinearProgressIndicator(),
    };
  }
}
