import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:intellicook_mobile/providers/app_controller/me.dart';
import 'package:intellicook_mobile/providers/app_controller/me_put.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class EditAccountScreen extends ConsumerStatefulWidget {
  const EditAccountScreen({super.key});

  @override
  ConsumerState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends ConsumerState<EditAccountScreen> {
  late bool controllerInitialized;
  late bool meUpdated;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String? nameError;
  String? emailError;
  String? usernameError;

  @override
  void initState() {
    super.initState();
    controllerInitialized = false;
    meUpdated = false;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final me = ref.watch(meProvider);
    final mePut = ref.watch(mePutProvider);

    ref.listen(
      meProvider,
      handleErrorAsSnackBar(context),
    );

    ref.listen(
      mePutProvider,
      handleErrorAsSnackBar(context),
    );

    ref.listen(appControllerProvider, (_, __) {
      if (meUpdated) {
        ref.read(meProvider.notifier).reload();
        Navigator.pop(context);
      }
    });

    if (me is AsyncData && !controllerInitialized) {
      nameController.text = me.value!.name;
      emailController.text = me.value!.email;
      usernameController.text = me.value!.username;
      controllerInitialized = true;
    }

    if (mePut is AsyncData && mePut.value!.response != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(appControllerProvider.notifier)
            .setAccessToken(mePut.value!.response!.accessToken);
      });
      setState(() {
        meUpdated = true;
      });
    }

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    void onConfirmClicked() {
      if (!mounted) {
        return;
      }

      setState(() {
        nameError = null;
        emailError = null;
        usernameError = null;
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

      if (validationFailed) {
        return;
      }

      ref.read(mePutProvider.notifier).put(
            nameController.text,
            emailController.text,
            usernameController.text,
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
                    'Edit Account',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: SpacingConsts.m),
                  InputField(
                    label: 'Name',
                    controller: nameController,
                    error: nameError ??
                        switch (mePut) {
                          AsyncData(:final value) =>
                            value.firstErrorOrNull(MePutStateErrorKey.name),
                          _ => null,
                        },
                  ),
                  const SizedBox(height: SpacingConsts.s),
                  InputField(
                    label: 'Email',
                    controller: emailController,
                    error: emailError ??
                        switch (mePut) {
                          AsyncData(:final value) =>
                            value.firstErrorOrNull(MePutStateErrorKey.email),
                          _ => null,
                        },
                  ),
                  const SizedBox(height: SpacingConsts.s),
                  InputField(
                    label: 'Username',
                    controller: usernameController,
                    error: usernameError ??
                        switch (mePut) {
                          AsyncData(:final value) =>
                            value.firstErrorOrNull(MePutStateErrorKey.username),
                          _ => null,
                        },
                  ),
                  ...switch (mePut) {
                    AsyncData(:final value) when value.hasResponse => const [
                        SizedBox(height: SpacingConsts.s),
                        LinearProgressIndicator(),
                      ],
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
