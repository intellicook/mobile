import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/high_level/background.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';
import 'package:intellicook_mobile/widgets/low_level/button.dart';

class ComponentGallery extends StatelessWidget {
  const ComponentGallery({super.key});

  static const title = 'Component Gallery';
  static final components = [
    (BuildContext context) => Button.primary(
          child: Center(
            child: Text(
              'Hello World',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onInverseSurface,
                  ),
            ),
          ),
        ),
    (BuildContext context) => Button.secondary(
          child: Center(
            child: Text(
              'Hello World',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
    (BuildContext context) => const InputField(
          label: 'Label text',
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
