import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/search_recipes.dart';
import 'package:intellicook_mobile/screens/nested/recipe_details_screen.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/ingredient_chip.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';
import 'package:intellicook_mobile/widgets/high_level/panel_card.dart';
import 'package:intellicook_mobile/widgets/low_level/glassmorphism.dart';

class RecipeSearchScreen extends ConsumerStatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  ConsumerState<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends ConsumerState<RecipeSearchScreen> {
  final searchController = TextEditingController();
  final ingredients = ValueNotifier<List<String>>([]);

  @override
  void dispose() {
    searchController.dispose();
    ingredients.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchRecipes = ref.watch(searchRecipesProvider);

    ref.listen(searchRecipesProvider, handleErrorAsSnackBar(context));

    void onSearchSubmitted(String text) {
      ingredients.value = [...ingredients.value, text];
      searchController.clear();
      ref.read(searchRecipesProvider.notifier).searchRecipes(ingredients.value);
    }

    return BackgroundScaffold(
      title: 'Recipe Search',
      child: Panel(
        padding: EdgeInsets.zero,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            PinnedHeaderSliver(
              child: ClipRect(
                child: Glassmorphism(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: SpacingConsts.m,
                      right: SpacingConsts.m,
                      top: SpacingConsts.m,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InputField(
                          controller: searchController,
                          label: 'Search for recipes',
                          hint: 'Enter recipe title or ingredients',
                          onSubmitted: onSearchSubmitted,
                        ),
                        const SizedBox(height: SpacingConsts.m),
                        ValueListenableBuilder<List<String>>(
                          valueListenable: ingredients,
                          builder: (context, ingredients, child) {
                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: ingredients.length,
                              itemBuilder: (context, index) {
                                final ingredient = ingredients[index];
                                return IngredientChip(
                                  ingredient: ingredient,
                                  onEdit: (text) {
                                    ingredients[index] = text;
                                    ref
                                        .read(searchRecipesProvider.notifier)
                                        .searchRecipes(ingredients);
                                  },
                                  onRemove: () {
                                    ingredients.removeAt(index);
                                    ref
                                        .read(searchRecipesProvider.notifier)
                                        .searchRecipes(ingredients);
                                  },
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: SpacingConsts.s),
                            );
                          },
                        ),
                        const SizedBox(height: SpacingConsts.m),
                        const Divider(height: 1.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            switch (searchRecipes) {
              AsyncLoading() => const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              AsyncData(:final value) => SliverPadding(
                  padding: const EdgeInsets.all(SpacingConsts.m),
                  sliver: SliverList.separated(
                    itemCount: value.response.length,
                    itemBuilder: (context, index) {
                      final recipe = value.response[index];
                      return PanelCard(
                        child: ListTile(
                          title: Text(recipe.name),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Scaffold(
                                body: RecipeDetailsScreen(recipe: recipe),
                              ),
                            ));
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: SpacingConsts.s),
                  ),
                ),
              _ => const SliverFillRemaining(),
            },
          ],
        ),
      ),
    );
  }
}
