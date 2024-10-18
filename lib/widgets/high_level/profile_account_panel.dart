import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/me.dart';
import 'package:intellicook_mobile/screens/nested/edit_account_screen.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';
import 'package:intellicook_mobile/widgets/high_level/shimmer.dart';
import 'package:intellicook_mobile/widgets/high_level/shimmer_text.dart';

class ProfileAccountPanel extends ConsumerWidget {
  const ProfileAccountPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(meProvider);

    ref.listen(
      meProvider,
      handleErrorAsSnackBar(context),
    );

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    void onEditAccountClicked() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: EditAccountScreen(),
          ),
        ),
      );
    }

    return Panel(
      child: switch (me) {
        AsyncData(:final value) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.name,
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: SpacingConsts.m),
              Text('Username: ${value.username}'),
              Text('Email: ${value.email}'),
              const SizedBox(height: SpacingConsts.m),
              LabelButton(
                type: LabelButtonType.secondary,
                label: 'Edit Account',
                onClicked: onEditAccountClicked,
              ),
            ],
          ),
        _ => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerText(
                      'User Name',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: SpacingConsts.m),
                    const ShimmerText('Username: user1234'),
                    const SizedBox(height: SpacingConsts.xs),
                    const ShimmerText('Email: user@example.com'),
                  ],
                ),
              ),
              const SizedBox(height: SpacingConsts.m),
              const LabelButton(
                type: LabelButtonType.secondary,
                enabled: false,
                label: 'Edit Account',
              ),
            ],
          ),
      },
    );
  }
}
