import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/screens/nested/login_screen.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class LoginPromptPanel extends StatelessWidget {
  const LoginPromptPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    void onClicked() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: LoginScreen(),
          ),
        ),
      );
    }

    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Looks like you are not logged in!',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: SpacingConsts.m),
          const Text('Login to access your profile.'),
          const SizedBox(height: SpacingConsts.m),
          LabelButton(
            label: 'Login',
            onClicked: onClicked,
          ),
        ],
      ),
    );
  }
}
