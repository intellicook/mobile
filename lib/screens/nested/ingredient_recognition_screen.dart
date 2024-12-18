import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/recognize_ingredients.dart';
import 'package:intellicook_mobile/providers/ingredient_recognition_images.dart';
import 'package:intellicook_mobile/screens/nested/recipe_search_screen.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';
import 'package:intellicook_mobile/widgets/high_level/panel_card.dart';

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
    final ingredients = ref.watch(recognizeIngredientsProvider);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    ref.listen(
      ingredientRecognitionImagesProvider,
      handleErrorAsSnackBar(context),
    );

    void onTakeAPhoto() {
      ref
          .read(ingredientRecognitionImagesProvider.notifier)
          .addImages(ImageSource.camera);
    }

    void onSelectFromGallery() {
      ref
          .read(ingredientRecognitionImagesProvider.notifier)
          .addImages(ImageSource.gallery);
    }

    void rotateImage(int index) {
      ref.read(ingredientRecognitionImagesProvider.notifier).rotateImage(index);
    }

    void removeImage(int index) {
      ref.read(ingredientRecognitionImagesProvider.notifier).removeImage(index);
    }

    void onRecipeSearchClicked() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          body: RecipeSearchScreen(
            ingredients: ingredients.value!.imageIngredients
                .map((e) => e!.map((e) => e.name).toList())
                .expand((e) => e)
                .toList(),
          ),
        ),
      ));
    }

    return BackgroundScaffold(
      title: 'Ingredients Recognition',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Panel(
              padding: EdgeInsets.zero,
              child: PageView(
                controller: pageController,
                children: [
                  ...(switch (images) {
                    AsyncData(:final value) => value.images.indexed.map((e) {
                        final (index, image) = e;
                        return CustomScrollView(slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(SpacingConsts.m),
                            sliver: SliverList.list(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: LabelButton(
                                        label: 'Rotate',
                                        type: LabelButtonType.secondary,
                                        leading: const Icon(
                                            Icons.rotate_right_rounded),
                                        onClicked: () => rotateImage(index),
                                      ),
                                    ),
                                    const SizedBox(width: SpacingConsts.s),
                                    Flexible(
                                      flex: 1,
                                      child: LabelButton(
                                        label: 'Remove',
                                        type: LabelButtonType.secondary,
                                        leading:
                                            const Icon(Icons.delete_rounded),
                                        onClicked: () => removeImage(index),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: SpacingConsts.m),
                                Image.memory(
                                  image,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: SpacingConsts.m),
                                ...switch (ingredients) {
                                  AsyncData(:final value) => switch (
                                        value.imageIngredients[index]) {
                                      List ingredients => [
                                          ListView.separated(
                                            shrinkWrap: true,
                                            itemBuilder: (context, i) =>
                                                PanelCard(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  SpacingConsts.s,
                                                ),
                                                child:
                                                    Text(ingredients[i].name),
                                              ),
                                            ),
                                            itemCount: ingredients.length,
                                            separatorBuilder: (context, i) =>
                                                const SizedBox(
                                              height: SpacingConsts.s,
                                            ),
                                          ),
                                        ],
                                      null => const [
                                          Center(
                                            child: LinearProgressIndicator(),
                                          ),
                                        ],
                                    },
                                  AsyncLoading() => const [
                                      Center(child: LinearProgressIndicator()),
                                    ],
                                  AsyncError(:final error) => [
                                      Center(
                                        child: Text(
                                          'Error: $error',
                                          style: textTheme.bodySmall!.copyWith(
                                              color: colorScheme.error),
                                        ),
                                      ),
                                    ],
                                  _ => const [],
                                },
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    AsyncLoading() => const [
                        Center(child: CircularProgressIndicator()),
                      ],
                    AsyncError(:final error) => [
                        Center(
                          child: Text(
                            'Error: $error',
                            style: textTheme.bodySmall!
                                .copyWith(color: colorScheme.error),
                          ),
                        ),
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
                          leading: const Icon(Icons.camera_alt_rounded),
                          onClicked: onTakeAPhoto,
                        ),
                        const SizedBox(height: SpacingConsts.m),
                        LabelButton(
                          label: 'Select from gallery',
                          leading: const Icon(Icons.photo_rounded),
                          onClicked: onSelectFromGallery,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: SpacingConsts.m),
          LabelButton(
            label: 'All Good! Search Recipes',
            enabled: ingredients.maybeWhen(
              data: (value) => !value.imageIngredients.any((e) => e == null),
              orElse: () => false,
            ),
            onClicked: onRecipeSearchClicked,
          ),
        ],
      ),
    );
  }
}
