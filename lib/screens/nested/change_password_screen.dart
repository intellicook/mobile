import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/me.dart';
import 'package:intellicook_mobile/providers/app_controller/me_password_put.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  String? currentPasswordError;
  String? newPasswordError;
  String? confirmNewPasswordError;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final me = ref.watch(meProvider);
    final mePasswordPut = ref.watch(mePasswordPutProvider);

    ref.listen(
      mePasswordPutProvider,
      handleErrorAsSnackBar(context),
    );

    if (mePasswordPut is AsyncData && mePasswordPut.value!.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    void onConfirmClicked() {
      if (!mounted) {
        return;
      }

      setState(() {
        currentPasswordError = null;
        newPasswordError = null;
        confirmNewPasswordError = null;
      });

      var validationFailed = false;

      if (currentPasswordController.text.isEmpty) {
        setState(() {
          currentPasswordError = 'Current Password is required';
        });
        validationFailed = true;
      }

      if (newPasswordController.text.isEmpty) {
        setState(() {
          newPasswordError = 'New Password is required';
        });
        validationFailed = true;
      } else if (newPasswordController.text == currentPasswordController.text) {
        setState(() {
          newPasswordError =
              'New Password must be different from Current Password';
        });
        validationFailed = true;
      }

      if (confirmNewPasswordController.text.isEmpty) {
        setState(() {
          confirmNewPasswordError = 'Confirm New Password is required';
        });
        validationFailed = true;
      } else if (confirmNewPasswordController.text !=
          newPasswordController.text) {
        setState(() {
          confirmNewPasswordError = 'Passwords do not match';
        });
        validationFailed = true;
      }

      if (validationFailed) {
        return;
      }

      ref.read(mePasswordPutProvider.notifier).put(
            currentPasswordController.text,
            newPasswordController.text,
          );
    }

    void onCancelClicked() {
      Navigator.of(context).pop();
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
                    'Change Password',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: SpacingConsts.m),
                  InputField(
                    label: 'Current Password',
                    obscureText: true,
                    controller: currentPasswordController,
                    error: currentPasswordError ??
                        switch (mePasswordPut) {
                          AsyncData(:final value) => value.firstErrorOrNull(
                              MePasswordPutStateErrorKey.oldPassword,
                            ),
                          _ => null,
                        },
                  ),
                  const SizedBox(height: SpacingConsts.s),
                  InputField(
                    label: 'New Password',
                    obscureText: true,
                    controller: newPasswordController,
                    error: newPasswordError ??
                        switch (mePasswordPut) {
                          AsyncData(:final value) => value.firstErrorOrNull(
                              MePasswordPutStateErrorKey.newPassword,
                            ),
                          _ => null,
                        },
                  ),
                  const SizedBox(height: SpacingConsts.s),
                  InputField(
                    label: 'Confirm New Password',
                    obscureText: true,
                    controller: confirmNewPasswordController,
                    error: confirmNewPasswordError,
                  ),
                  ...switch (mePasswordPut) {
                    AsyncLoading() => const [
                        SizedBox(height: SpacingConsts.s),
                        LinearProgressIndicator(),
                      ],
                    _ => const [],
                  },
                  const SizedBox(height: SpacingConsts.m),
                  LabelButton(
                    label: 'Confirm',
                    type: LabelButtonType.primary,
                    onClicked: onConfirmClicked,
                    enabled: me is AsyncData,
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
          const Spacer(),
        ],
      ),
    );
  }
}
