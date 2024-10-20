import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/login_prompt_panel.dart';
import 'package:intellicook_mobile/widgets/high_level/profile_account_panel.dart';
import 'package:intellicook_mobile/widgets/high_level/profile_password_panel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appController = ref.watch(appControllerProvider);

    return BackgroundScaffold(
      background: false,
      title: 'Profile',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: switch (appController.isAuthenticated) {
          false => const [
              LoginPromptPanel(),
            ],
          _ => const [
              ProfileAccountPanel(),
              SizedBox(height: SpacingConsts.m),
              ProfilePasswordPanel(),
            ],
        },
      ),
    );
  }
}