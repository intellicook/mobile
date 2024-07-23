import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/high_level/background.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/label_toggle_switch.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';
import 'package:intellicook_mobile/widgets/high_level/selection.dart';

class ComponentGallery extends StatefulWidget {
  const ComponentGallery({super.key});

  @override
  State<ComponentGallery> createState() => _ComponentGalleryState();
}

class _ComponentGalleryState extends State<ComponentGallery> {
  bool inputsEnabled = true;

  @override
  Widget build(BuildContext context) {
    const title = 'Component Gallery';
    final components = [
      (BuildContext context) => LabelToggleSwitch(
            label: 'Inputs Enabled',
            value: inputsEnabled,
            onChanged: (value) => setState(() => inputsEnabled = value),
          ),
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
      (BuildContext context) => Selection(
            buttons: ['Selection 1', 'Selection 2', 'Last Selection']
                .map<SelectionButton<String>>((label) {
              return SelectionButton(value: label, label: Text(label));
            }).toList(),
            selected: const {'Selection 1'},
          )
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(title),
      ),
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(SpacingConsts.m),
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
        ),
      ),
    );
  }
}
