import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/common/button.dart';

class ComponentGallery extends StatelessWidget {
  const ComponentGallery({super.key});

  static const title = 'Component Gallery';
  static final components = [
    () => Button.primary(
          child: const Center(
            child: Text('Hello World'),
          ),
        ),
    () => Button.secondary(
          child: const Center(
            child: Text('Hello World'),
          ),
        ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(SpacingConsts.s),
        child: ListView.separated(
          itemCount: components.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: SpacingConsts.s,
          ),
          itemBuilder: (context, index) => components[index](),
        ),
      ),
    );
  }
}
