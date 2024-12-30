import 'package:app_controller_client/app_controller_client.dart';
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
  const RecipeSearchScreen({super.key, this.ingredients = const []});

  final List<String> ingredients;

  @override
  ConsumerState<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends ConsumerState<RecipeSearchScreen> {
  final searchController = TextEditingController();
  late final ingredients = ValueNotifier<List<String>>(widget.ingredients);

  @override
  void initState() {
    super.initState();
    if (widget.ingredients.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(searchRecipesProvider.notifier)
            .searchRecipes(widget.ingredients);
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    ingredients.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchRecipes = ref.watch(searchRecipesProvider);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

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

                      final name = recipe.name;
                      final List<String> nameTokens = recipe.matches.fold(
                        [],
                        (acc, match) {
                          if (match.field ==
                              SearchRecipesMatchFieldModel.nameField) {
                            acc.addAll(match.tokens);
                          }
                          return acc;
                        },
                      );

                      List<TextSpan> buildHighlightedTextSpans(
                        String text,
                        Iterable<String> tokens,
                      ) {
                        final spans = <TextSpan>[];
                        final regex =
                            RegExp(tokens.map(RegExp.escape).join('|'));
                        int start = 0;

                        for (final match in regex.allMatches(text)) {
                          if (match.start > start) {
                            spans.add(TextSpan(
                              text: text.substring(start, match.start),
                            ));
                          }
                          spans.add(TextSpan(
                            text: match.group(0),
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ));
                          start = match.end;
                        }

                        if (start < text.length) {
                          spans.add(TextSpan(
                            text: text.substring(start),
                          ));
                        }

                        return spans;
                      }

                      return PanelCard(
                        child: ListTile(
                          title: RichText(
                            text: TextSpan(
                              style: textTheme.titleMedium,
                              children: buildHighlightedTextSpans(
                                name,
                                nameTokens,
                              ),
                            ),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              style: textTheme.bodySmall,
                              children: [
                                const TextSpan(text: 'Matched Ingredients:\n'),
                                ...recipe.matches
                                    .where((match) =>
                                        match.field ==
                                        SearchRecipesMatchFieldModel
                                            .ingredients)
                                    .expand(
                                  (match) {
                                    final tokens = match.tokens;
                                    final ingredient =
                                        recipe.ingredients[match.index!];
                                    final spans = buildHighlightedTextSpans(
                                      ingredient,
                                      tokens,
                                    );
                                    return spans.followedBy(
                                      [const TextSpan(text: '\n')],
                                    );
                                  },
                                ).toList()
                                  ..removeLast(),
                              ],
                            ),
                          ),
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
