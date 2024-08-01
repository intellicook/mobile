import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/health.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class AppControllerHealth extends ConsumerWidget {
  const AppControllerHealth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(healthProvider);

    final content = [
      (BuildContext context) => LabelButton(
            label: 'Reload',
            type: LabelButtonType.primary,
            onClicked: () => ref.read(healthProvider.notifier).reload(),
          ),
      (BuildContext context) => switch (health) {
            AsyncData(:final value) => Text(value.toString()),
            AsyncError(:final error) => Text('Error: $error'),
            _ => const LinearProgressIndicator(),
          },
    ];

    const title = 'App Controller Health';

    return BackgroundScaffold(
      title: title,
      child: Panel(
        child: ListView.separated(
          clipBehavior: Clip.none,
          itemCount: content.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: SpacingConsts.m,
          ),
          itemBuilder: (context, index) => content[index](context),
        ),
      ),
    );
  }
}
