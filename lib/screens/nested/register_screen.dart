import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/register.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? nameError;
  String? emailError;
  String? usernameError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final register = ref.watch(registerProvider);

    ref.listen(registerProvider, handleErrorAsSnackBar(context));

    ref.listen(registerProvider, (_, state) {
      if (state is AsyncData) {
        if (state.value!.success) {
          Navigator.pop(context);
        }
      }
    });

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    void onConfirmClicked() {
      setState(() {
        nameError = null;
        emailError = null;
        usernameError = null;
        passwordError = null;
        confirmPasswordError = null;
      });

      var validationFailed = false;

      if (nameController.text.isEmpty) {
        setState(() {
          nameError = 'Name is required';
        });
        validationFailed = true;
      }

      if (emailController.text.isEmpty) {
        setState(() {
          emailError = 'Email is required';
        });
        validationFailed = true;
      }

      if (usernameController.text.isEmpty) {
        setState(() {
          usernameError = 'Username is required';
        });
        validationFailed = true;
      }

      if (passwordController.text.isEmpty) {
        setState(() {
          passwordError = 'Password is required';
        });
        validationFailed = true;
      }

      if (confirmPasswordController.text.isEmpty) {
        setState(() {
          confirmPasswordError = 'Confirm Password is required';
        });
        validationFailed = true;
      } else if (confirmPasswordController.text != passwordController.text) {
        setState(() {
          confirmPasswordError = 'Passwords do not match';
        });
        validationFailed = true;
      }

      if (validationFailed) {
        return;
      }

      ref.read(registerProvider.notifier).register(
            nameController.text,
            emailController.text,
            usernameController.text,
            passwordController.text,
          );
    }

    void onCancelClicked() {
      Navigator.pop(context);
    }

    return BackgroundScaffold(
      padding: const EdgeInsets.all(SpacingConsts.l),
      child: Center(
        child: Panel(
          scrollable: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Register',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: SpacingConsts.m),
              InputField(
                label: 'Name',
                controller: nameController,
                error: nameError ??
                    switch (register) {
                      AsyncData(:final value) =>
                        value.firstErrorOrNull(RegisterStateErrorKey.name),
                      _ => null,
                    },
              ),
              const SizedBox(height: SpacingConsts.s),
              InputField(
                label: 'Email',
                controller: emailController,
                error: emailError ??
                    switch (register) {
                      AsyncData(:final value) =>
                        value.firstErrorOrNull(RegisterStateErrorKey.email),
                      _ => null,
                    },
              ),
              const SizedBox(height: SpacingConsts.s),
              InputField(
                label: 'Username',
                controller: usernameController,
                error: usernameError ??
                    switch (register) {
                      AsyncData(:final value) =>
                        value.firstErrorOrNull(RegisterStateErrorKey.username),
                      _ => null,
                    },
              ),
              const SizedBox(height: SpacingConsts.s),
              InputField(
                label: 'Password',
                obscureText: true,
                controller: passwordController,
                error: passwordError ??
                    switch (register) {
                      AsyncData(:final value) =>
                        value.firstErrorOrNull(RegisterStateErrorKey.password),
                      _ => null,
                    },
              ),
              const SizedBox(height: SpacingConsts.s),
              InputField(
                label: 'Confirm Password',
                obscureText: true,
                controller: confirmPasswordController,
                error: confirmPasswordError,
              ),
              switch (register) {
                AsyncLoading() => const SizedBox(height: SpacingConsts.s),
                _ => const SizedBox(),
              },
              switch (register) {
                AsyncLoading() => const LinearProgressIndicator(),
                _ => const SizedBox(),
              },
              const SizedBox(height: SpacingConsts.m),
              LabelButton(
                label: 'Confirm',
                type: LabelButtonType.primary,
                onClicked: onConfirmClicked,
              ),
              const SizedBox(height: SpacingConsts.s),
              LabelButton(
                label: 'Cancel',
                type: LabelButtonType.secondary,
                onClicked: onCancelClicked,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
