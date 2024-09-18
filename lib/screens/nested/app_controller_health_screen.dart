import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/providers/app_controller/health.dart';
import 'package:intellicook_mobile/widgets/high_level/app_controller_health.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class AppControllerHealthScreen extends ConsumerWidget {
  const AppControllerHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(healthProvider);

    const title = 'App Controller Health';

    final healthStatuses = AppControllerHealth(health: health);

    final reloadButton = LabelButton(
      label: 'Reload',
      type: LabelButtonType.primary,
      onClicked: () => ref.read(healthProvider.notifier).reload(),
    );

    return BackgroundScaffold(
      title: title,
      child: Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            healthStatuses,
            const Spacer(),
            reloadButton,
          ],
        ),
      ),
    );
  }
}
