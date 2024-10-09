import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/ingredient_recognition_frames.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class IngredientFramesScreen extends ConsumerWidget {
  const IngredientFramesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frames = ref.watch(ingredientRecognitionFramesProvider);

    ref.listen(
      ingredientRecognitionFramesProvider,
      handleErrorAsSnackBar(context),
    );

    if (frames is! AsyncData) {
      return const Center(child: CircularProgressIndicator());
    }

    final framesBytes = frames.value!.framesBytes;

    return BackgroundScaffold(
      title: 'Ingredients Recognition',
      child: Panel(
        child: ListView.separated(
          itemBuilder: (context, index) => Image.memory(
            framesBytes[index],
            fit: BoxFit.fitWidth,
          ),
          separatorBuilder: (context, index) => const SizedBox(
            height: SpacingConsts.m,
          ),
          itemCount: framesBytes.length,
        ),
      ),
    );
  }
}
