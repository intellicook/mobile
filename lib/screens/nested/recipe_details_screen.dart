import 'package:app_controller_client/app_controller_client.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/opacity.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key, required this.recipe});

  final SearchRecipesRecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BackgroundScaffold(
      title: 'Recipe Details',
      child: Panel(
        padding: EdgeInsets.zero,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(SpacingConsts.m),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: SpacingConsts.m),
                    Text(
                      'Ingredients',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: SpacingConsts.s),
                    Wrap(
                      spacing: SpacingConsts.s,
                      runSpacing: SpacingConsts.s,
                      children: recipe.ingredients
                          .map(
                            (ingredient) => DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius:
                                      SmoothBorderRadiusConsts.sCornerRadius,
                                  cornerSmoothing:
                                      SmoothBorderRadiusConsts.cornerSmoothing,
                                ),
                                border: Border.all(
                                  width: 1.5,
                                  color: colorScheme.outline,
                                ),
                                color: colorScheme.surfaceContainerLow
                                    .withOpacity(OpacityConsts.low(context)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(SpacingConsts.s),
                                child: Text(
                                  ingredient,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: SpacingConsts.m),
                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: SpacingConsts.s),
                    ...recipe.detail!.instructions
                        .where((value) => value.isNotEmpty)
                        .toList()
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: SpacingConsts.s,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Step ${entry.key + 1}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: SpacingConsts.s),
                                Text(entry.value),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
