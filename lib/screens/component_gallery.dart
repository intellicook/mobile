import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/theme.dart' as theme_provider;
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/dropdown.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/label_toggle_switch.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class ComponentGallery extends ConsumerStatefulWidget {
  const ComponentGallery({super.key});

  @override
  ConsumerState<ComponentGallery> createState() => _ComponentGalleryState();
}

class _ComponentGalleryState extends ConsumerState<ComponentGallery> {
  bool inputsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(theme_provider.themeProvider);

    const title = 'Component Gallery';
    final components = [
      (BuildContext context) => Align(
            alignment: Alignment.topRight,
            child: Dropdown(
              label: 'Theme',
              initialValue: theme.value?.mode ?? ThemeMode.system,
              onChanged: (value) => ref
                  .read(theme_provider.themeProvider.notifier)
                  .set(value ?? ThemeMode.system),
              entries: const [
                DropdownEntry<ThemeMode>(
                  value: ThemeMode.system,
                  label: 'System',
                ),
                DropdownEntry<ThemeMode>(
                  value: ThemeMode.light,
                  label: 'Light',
                ),
                DropdownEntry<ThemeMode>(
                  value: ThemeMode.dark,
                  label: 'Dark',
                ),
              ],
            ),
          ),
      (BuildContext context) => LabelToggleSwitch(
            label: 'Inputs Enabled',
            initialValue: inputsEnabled,
            onChanged: (value) => setState(() => inputsEnabled = value),
          ),
      (BuildContext context) => const Divider(),
      (BuildContext context) => LabelButton(
            label: 'Primary Button',
            type: LabelButtonType.primary,
            enabled: inputsEnabled,
          ),
      (BuildContext context) => LabelButton(
            label: 'Secondary Button',
            type: LabelButtonType.secondary,
            enabled: inputsEnabled,
          ),
      (BuildContext context) => InputField(
            label: 'Input Field',
            hint: 'Type something...',
            enabled: inputsEnabled,
          ),
      (BuildContext context) => Align(
            alignment: Alignment.topRight,
            child: LabelToggleSwitch(
              label: 'Toggle Switch',
              enabled: inputsEnabled,
            ),
          ),
      (BuildContext context) => Align(
            alignment: Alignment.topRight,
            child: Dropdown(
              width: 160,
              label: 'Dropdown',
              enabled: inputsEnabled,
              entries: const [
                DropdownEntry<int>(
                  value: 1,
                  label: 'Option 1',
                ),
                DropdownEntry<int>(
                  value: 2,
                  label: 'Option 2',
                ),
                DropdownEntry<int>(
                  value: 3,
                  label: 'Option 3',
                ),
              ],
            ),
          ),
    ];

    return BackgroundScaffold(
      title: title,
      child: Panel(
        child: ListView.separated(
          clipBehavior: Clip.none,
          itemCount: components.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: SpacingConsts.m,
          ),
          itemBuilder: (context, index) => components[index](context),
        ),
      ),
    );
  }
}
