import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/ingredient_recognition_images.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class IngredientRecognitionScreen extends ConsumerStatefulWidget {
  const IngredientRecognitionScreen({super.key});

  @override
  ConsumerState createState() => _IngredientRecognitionScreenState();
}

class _IngredientRecognitionScreenState extends ConsumerState
    with WidgetsBindingObserver {
  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(ingredientRecognitionImagesProvider);

    ref.listen(
      ingredientRecognitionImagesProvider,
      handleErrorAsSnackBar(context),
    );

    void onTakeAPhoto() {
      ref
          .read(ingredientRecognitionImagesProvider.notifier)
          .pickImages(ImageSource.camera);
    }

    void onSelectFromGallery() {
      ref
          .read(ingredientRecognitionImagesProvider.notifier)
          .pickImages(ImageSource.gallery);
    }

    return BackgroundScaffold(
      title: 'Ingredients Recognition',
      child: Panel(
        padding: EdgeInsets.zero,
        child: PageView(
          controller: pageController,
          children: [
            ...(switch (images) {
              AsyncData(:final value) => value.images
                  .map((image) => Padding(
                        padding: const EdgeInsets.all(SpacingConsts.m),
                        child: Image.file(
                          File(image.path),
                          fit: BoxFit.contain,
                        ),
                      ))
                  .toList(),
              AsyncLoading() => const [
                  Center(child: CircularProgressIndicator()),
                ],
              AsyncError(:final error) => [
                  Center(child: Text('Error: $error')),
                ],
              _ => const [],
            }),
            Padding(
              padding: const EdgeInsets.all(SpacingConsts.m),
              child: Column(
                children: [
                  const Spacer(),
                  LabelButton(
                    label: 'Take a photo',
                    leading: const Icon(Icons.camera_alt),
                    onClicked: onTakeAPhoto,
                  ),
                  const SizedBox(height: SpacingConsts.m),
                  LabelButton(
                    label: 'Select from gallery',
                    leading: const Icon(Icons.photo),
                    onClicked: onSelectFromGallery,
                  ),
                  const Spacer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
