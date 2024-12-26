import 'dart:typed_data';

import 'package:app_controller_client/app_controller_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/recognize_ingredients.dart';
import 'package:intellicook_mobile/providers/ingredient_recognition_images.dart';
import 'package:intellicook_mobile/screens/nested/recipe_search_screen.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/extensions/theme_data.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';
import 'package:intellicook_mobile/widgets/high_level/panel_card.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';

class IngredientRecognitionScreen extends ConsumerStatefulWidget {
  const IngredientRecognitionScreen({super.key});

  @override
  ConsumerState createState() => _IngredientRecognitionScreenState();
}

class _IngredientRecognitionScreenState extends ConsumerState
    with WidgetsBindingObserver {
  final pageController = PageController();
  final ingredientSelected = ValueNotifier<int?>(null);

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

    void onPageChanged(int index) {
      ingredientSelected.value = null;
    }

    void onIngredientSelected(int index) {
      ingredientSelected.value =
          ingredientSelected.value == index ? null : index;
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
                onPageChanged: onPageChanged,
                children: [
                  ...(switch (images) {
                    AsyncData(:final value) => value.images.indexed.map((e) {
                        final (index, image) = e;
                        return ValueListenableBuilder(
                          valueListenable: ingredientSelected,
                          builder: (context, selectedIngredient, state) =>
                              _ImageIngredients(
                            index: index,
                            image: image,
                            ingredients: ingredients,
                            ingredientSelected: selectedIngredient,
                            onSelected: onIngredientSelected,
                          ),
                        );
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
                          leading: Icon(
                            Icons.camera_alt_rounded,
                            color: theme.onMain,
                          ),
                          onClicked: onTakeAPhoto,
                        ),
                        const SizedBox(height: SpacingConsts.m),
                        LabelButton(
                          label: 'Select from gallery',
                          leading: Icon(
                            Icons.photo_rounded,
                            color: theme.onMain,
                          ),
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

class _ImageIngredients extends ConsumerWidget {
  const _ImageIngredients({
    required this.index,
    required this.image,
    required this.ingredients,
    required this.ingredientSelected,
    required this.onSelected,
  });

  final int index;
  final Uint8List image;
  final AsyncValue<RecognizeIngredientsState> ingredients;
  final int? ingredientSelected;
  final void Function(int) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    void rotateImage(int index) {
      ref.read(ingredientRecognitionImagesProvider.notifier).rotateImage(index);
    }

    void removeImage(int index) {
      ref.read(ingredientRecognitionImagesProvider.notifier).removeImage(index);
    }

    return CustomScrollView(slivers: [
      SliverPadding(
        padding: const EdgeInsets.all(SpacingConsts.m),
        sliver: SliverList.list(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: LabelButton(
                    label: 'Rotate',
                    type: LabelButtonType.secondary,
                    leading: const Icon(Icons.rotate_right_rounded),
                    onClicked: () => rotateImage(index),
                  ),
                ),
                const SizedBox(width: SpacingConsts.s),
                Flexible(
                  flex: 1,
                  child: LabelButton(
                    label: 'Remove',
                    type: LabelButtonType.secondary,
                    leading: const Icon(Icons.delete_rounded),
                    onClicked: () => removeImage(index),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpacingConsts.m),
            ClipRRect(
              borderRadius: SmoothBorderRadiusConsts.s,
              child: Stack(
                children: [
                  Image.memory(
                    image,
                    fit: BoxFit.contain,
                  ),
                  ...switch (ingredients) {
                    AsyncData(:final value) => switch (
                          value.imageIngredients[index]) {
                        List<RecognizeIngredientsIngredientModel> ingredients =>
                          switch (ingredientSelected) {
                            int i => [
                                Positioned.fill(
                                  child: FractionallySizedBox(
                                    alignment: FractionalOffset(
                                      ingredients[i].x +
                                          ingredients[i].width / 2,
                                      ingredients[i].y +
                                          ingredients[i].height / 2,
                                    ),
                                    widthFactor: ingredients[i].width,
                                    heightFactor: ingredients[i].height,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: IntelliCookTheme.primaryColor,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            SmoothBorderRadiusConsts.s,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            null => const [],
                          },
                        null => const [],
                      },
                    _ => const [],
                  }
                ],
              ),
            ),
            const SizedBox(height: SpacingConsts.m),
            ...switch (ingredients) {
              AsyncData(:final value) => switch (
                    value.imageIngredients[index]) {
                  List ingredients => [
                      ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, i) => PanelCard(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              SpacingConsts.s,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ingredients[i].name,
                                  style: textTheme.bodyLarge,
                                ),
                                Row(
                                  children: [
                                    Clickable(
                                      onPressed: () => onSelected(i),
                                      child: Icon(
                                        Icons.highlight_alt_rounded,
                                        color: i == ingredientSelected
                                            ? IntelliCookTheme.primaryColor
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        itemCount: ingredients.length,
                        separatorBuilder: (context, i) => const SizedBox(
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
                      style: textTheme.bodySmall!
                          .copyWith(color: colorScheme.error),
                    ),
                  ),
                ],
              _ => const [],
            },
          ],
        ),
      ),
    ]);
  }
}
