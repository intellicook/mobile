import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/login.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final login = ref.watch(loginProvider);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    void onLoginClicked() {
      ref.read(loginProvider.notifier).login(
            usernameController.text,
            passwordController.text,
          );
    }

    return BackgroundScaffold(
      title: 'Login',
      padding: const EdgeInsets.all(SpacingConsts.l),
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: SpacingConsts.m),
                  InputField(
                    label: 'Username',
                    controller: usernameController,
                  ),
                  const SizedBox(height: SpacingConsts.s),
                  const InputField(
                    label: 'Password',
                    obscureText: true,
                  ),
                  switch (login) {
                    AsyncData(:final value) => switch (value.hasResponse) {
                        false => const SizedBox(),
                        true => const SizedBox(height: SpacingConsts.s),
                      },
                    AsyncError() => const SizedBox(height: SpacingConsts.s),
                    AsyncLoading() => const SizedBox(height: SpacingConsts.s),
                    _ => const SizedBox(),
                  },
                  switch (login) {
                    AsyncData(:final value) => switch (value.hasResponse) {
                        false => const SizedBox(),
                        true => switch (value.invalidCredentials) {
                            false => const Text('Login successful'),
                            true => const Text(
                                'Invalid username or password',
                                style: TextStyle(color: Colors.red),
                              ),
                          }
                      },
                    AsyncError(:final error) => Text(
                        '$error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    AsyncLoading() => const LinearProgressIndicator(),
                    _ => const SizedBox(),
                  },
                  const SizedBox(height: SpacingConsts.m),
                  LabelButton(
                    label: 'Login',
                    type: LabelButtonType.primary,
                    onClicked: onLoginClicked,
                  ),
                  const SizedBox(height: SpacingConsts.s),
                  const LabelButton(
                    label: 'Register',
                    type: LabelButtonType.secondary,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
