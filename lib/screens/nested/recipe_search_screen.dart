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
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';
import 'package:intellicook_mobile/widgets/low_level/glassmorphism.dart';

class RecipeSearchScreen extends ConsumerStatefulWidget {
  const RecipeSearchScreen({
    super.key,
    this.ingredients = const [],
    this.extraTerms,
  });

  final List<String> ingredients;
  final String? extraTerms;

  @override
  ConsumerState<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends ConsumerState<RecipeSearchScreen> {
  final searchController = TextEditingController();
  final extraTermsController = TextEditingController();
  late final ingredients = ValueNotifier<List<String>>(widget.ingredients);
  late final extraTerms = ValueNotifier<String?>(widget.extraTerms);
  var isSearchExpanded = true;

  @override
  void initState() {
    super.initState();
    extraTermsController.text = widget.extraTerms ?? '';
    if (widget.ingredients.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(searchRecipesProvider.notifier)
            .searchRecipes(widget.ingredients, widget.extraTerms);
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    extraTermsController.dispose();
    ingredients.dispose();
    extraTerms.dispose();
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
      ref.read(searchRecipesProvider.notifier).searchRecipes(
            ingredients.value,
            extraTerms.value,
          );
    }

    void onExtraTermsChanged(String text) {
      extraTerms.value = text.isNotEmpty ? text : null;
      ref.read(searchRecipesProvider.notifier).searchRecipes(
            ingredients.value,
            extraTerms.value,
          );
    }

    void toggleSearchExpanded() {
      setState(() {
        isSearchExpanded = !isSearchExpanded;
      });
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
                        ValueListenableBuilder<List<String>>(
                          valueListenable: ingredients,
                          builder: (context, ingredientsList, _) {
                            return AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: isSearchExpanded
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              sizeCurve: Curves.easeInOut,
                              firstChild: buildExpandedSearchView(
                                ingredientsList,
                                onSearchSubmitted,
                                onExtraTermsChanged,
                              ),
                              secondChild:
                                  buildCollapsedSearchView(ingredientsList),
                            );
                          },
                        ),
                        buildToggleButton(toggleSearchExpanded),
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

                      final title = recipe.title;
                      final List<String> nameTokens = recipe.matches.fold(
                        [],
                        (acc, match) {
                          if (match.field ==
                              SearchRecipesMatchFieldModel.title) {
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
                                title,
                                nameTokens,
                              ),
                            ),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              style: textTheme.bodySmall,
                              children: [
                                const TextSpan(text: 'Matched Ingredients:\n'),
                                ...switch (recipe.matches
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
                                      ingredient.name,
                                      tokens,
                                    );
                                    return spans.followedBy(
                                      [const TextSpan(text: '\n')],
                                    );
                                  },
                                ).toList()) {
                                  [] => const [TextSpan(text: 'None')],
                                  List spans => spans..removeLast(),
                                },
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

  Widget buildExpandedSearchView(
    List<String> ingredientsList,
    Function(String) onSearchSubmitted,
    Function(String) onExtraTermsChanged,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InputField(
          controller: searchController,
          label: 'Search for recipes',
          hint: 'Enter recipe title or ingredients',
          onSubmitted: onSearchSubmitted,
        ),
        const SizedBox(height: SpacingConsts.m),
        InputField(
          controller: extraTermsController,
          label: 'Additional search terms',
          hint: 'Enter extra search terms (optional)',
          onSubmitted: onExtraTermsChanged,
          suffix: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => onExtraTermsChanged(extraTermsController.text),
          ),
        ),
        const SizedBox(height: SpacingConsts.m),
        if (ingredientsList.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ingredientsList.length,
            itemBuilder: (context, index) {
              final ingredient = ingredientsList[index];
              return IngredientChip(
                ingredient: ingredient,
                onEdit: (text) {
                  ingredientsList[index] = text;
                  ref.read(searchRecipesProvider.notifier).searchRecipes(
                        ingredientsList,
                        extraTerms.value,
                      );
                },
                onRemove: () {
                  ingredientsList.removeAt(index);
                  ref.read(searchRecipesProvider.notifier).searchRecipes(
                        ingredientsList,
                        extraTerms.value,
                      );
                },
              );
            },
            separatorBuilder: (context, index) =>
                const SizedBox(height: SpacingConsts.s),
          ),
        const SizedBox(height: SpacingConsts.m),
      ],
    );
  }

  Widget buildCollapsedSearchView(List<String> ingredientsList) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SpacingConsts.s),
      child: Row(
        children: [
          Icon(Icons.search, size: textTheme.bodyLarge?.fontSize ?? 20),
          const SizedBox(width: SpacingConsts.s),
          Text(
            extraTerms.value != null && extraTerms.value!.isNotEmpty
                ? '"${extraTerms.value}" + ${ingredientsList.length} ingredients'
                : '${ingredientsList.length} ingredients in search',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget buildToggleButton(VoidCallback onPressed) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Clickable(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(bottom: SpacingConsts.m),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSearchExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: textTheme.bodyLarge?.fontSize ?? 20,
            ),
            const SizedBox(width: SpacingConsts.xs),
            Text(
              isSearchExpanded ? 'Hide search' : 'Show search',
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
