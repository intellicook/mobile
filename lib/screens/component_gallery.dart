import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/high_level/background.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class ComponentGallery extends StatelessWidget {
  const ComponentGallery({super.key});

  static const title = 'Component Gallery';
  static final components = [
    (BuildContext context) => const LabelButton(
          label: 'Primary Button',
          type: LabelButtonType.primary,
        ),
    (BuildContext context) => const LabelButton(
          label: 'Secondary Button',
          type: LabelButtonType.secondary,
        ),
    (BuildContext context) => const InputField(
          label: 'Input Field',
          hint: 'Type something...',
        ),
  ];

  @override
  Widget build(BuildContext context) {
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
