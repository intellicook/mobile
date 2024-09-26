import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class IngredientRecognitionAnimation extends StatefulWidget {
  const IngredientRecognitionAnimation({super.key});

  @override
  State<IngredientRecognitionAnimation> createState() =>
      _IngredientRecognitionAnimationState();
}

class _IngredientRecognitionAnimationState
    extends State<IngredientRecognitionAnimation> {
  RiveAnimationController? controller;

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/ingredient_recognition.riv',
      artboard: 'ingredient_recognition',
      alignment: Alignment.center,
      fit: BoxFit.scaleDown,
      useArtboardSize: true,
      onInit: (artboard) {
        final theme = Theme.of(context);
        final textTheme = theme.textTheme;
        artboard
            .component<TextValueRun>('label_run')
            ?.style
            ?.fills
            .first
            .paint
            .color = textTheme.headlineLarge!.color!;

        final stateMachineName = artboard.stateMachines.first.name;
        controller = StateMachineController.fromArtboard(
          artboard,
          stateMachineName,
        );
        if (controller != null) {
          artboard.addController(controller!);
        }
      },
    );
  }
}
