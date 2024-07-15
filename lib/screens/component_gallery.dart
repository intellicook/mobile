import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/common/background.dart';
import 'package:intellicook_mobile/widgets/common/button.dart';
import 'package:intellicook_mobile/widgets/common/input_field.dart';
import 'package:intellicook_mobile/widgets/common/panel.dart';

class ComponentGallery extends StatelessWidget {
  const ComponentGallery({super.key});

  static const title = 'Component Gallery';
  static final components = [
    (BuildContext context) => Button.primary(
          child: Center(
            child: Text(
              'Hello World',
              style: Theme.of(context).textTheme.bodyLarge,
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
    (BuildContext context) => const InputField(),
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
                height: SpacingConsts.s,
              ),
              itemBuilder: (context, index) => components[index](context),
            ),
          ),
        ),
      ),
    );
  }
}
