import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/login.dart';
import 'package:intellicook_mobile/screens/nested/register_screen.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
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
  String? usernameError;
  String? passwordError;

  @override
  void dispose() {
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final login = ref.watch(loginProvider);

    ref.listen(loginProvider, handleErrorAsSnackBar(context));

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    ref.listen(loginProvider, (_, state) {
      if (state is AsyncData && state.value?.response != null) {
        Navigator.of(context).pop();
      }
    });

    void onLoginClicked() {
      if (!mounted) {
        return;
      }

      setState(() {
        usernameError = null;
        passwordError = null;
      });

      var validationFailed = false;

      if (usernameController.text.isEmpty) {
        setState(() {
          usernameError = 'Username cannot be empty';
        });
        validationFailed = true;
      }

      if (passwordController.text.isEmpty) {
        setState(() {
          passwordError = 'Password cannot be empty';
        });
        validationFailed = true;
      }

      if (validationFailed) {
        return;
      }

      ref.read(loginProvider.notifier).login(
            usernameController.text,
            passwordController.text,
          );
    }

    void onRegisterClicked() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: RegisterScreen(),
        ),
      ));
    }

    return BackgroundScaffold(
      padding: const EdgeInsets.all(SpacingConsts.l),
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: Panel(
              scrollable: true,
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
                    error: usernameError,
                  ),
                  const SizedBox(height: SpacingConsts.s),
                  InputField(
                    label: 'Password',
                    obscureText: true,
                    controller: passwordController,
                    error: passwordError,
                  ),
                  switch (login) {
                    AsyncData(:final value) => switch (value.hasResponse) {
                        false => const SizedBox(),
                        true => switch (value.invalidCredentials) {
                            false => const SizedBox(),
                            true => const SizedBox(height: SpacingConsts.s),
                          },
                      },
                    AsyncLoading() => const SizedBox(height: SpacingConsts.s),
                    _ => const SizedBox(),
                  },
                  switch (login) {
                    AsyncData(:final value) => switch (value.hasResponse) {
                        false => const SizedBox(),
                        true => switch (value.invalidCredentials) {
                            false => const SizedBox(),
                            true => const Text(
                                'Invalid username or password',
                                style: TextStyle(color: Colors.red),
                              ),
                          }
                      },
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
                  LabelButton(
                    label: 'Register',
                    type: LabelButtonType.secondary,
                    onClicked: onRegisterClicked,
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
