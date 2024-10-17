import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/me.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class ProfilePasswordPanel extends ConsumerWidget {
  const ProfilePasswordPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(meProvider);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: SpacingConsts.m),
          LabelButton(
            type: LabelButtonType.secondary,
            enabled: me is AsyncData,
            label: 'Change Password',
          ),
        ],
      ),
    );
  }
}
