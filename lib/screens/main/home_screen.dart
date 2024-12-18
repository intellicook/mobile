import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/screens/nested/ingredient_recognition_screen.dart';
import 'package:intellicook_mobile/screens/nested/recipe_search_screen.dart';
import 'package:intellicook_mobile/widgets/animations/ingredient_recognition_animation.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';
import 'package:intellicook_mobile/widgets/high_level/rive_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    void onIngredientRecognitionClicked() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: IngredientRecognitionScreen(),
        ),
      ));
    }

    void onRecipeSearchClicked() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: RecipeSearchScreen(),
        ),
      ));
    }

    return BackgroundScaffold(
      background: false,
      title: 'Home',
      child: Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to IntelliCook!',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: SpacingConsts.m),
            RiveButton(
              onClicked: onIngredientRecognitionClicked,
              riveBuilder: (context) => SizedBox(
                height: min(
                  (MediaQuery.of(context).size.width - SpacingConsts.m * 2) /
                      16 *
                      9,
                  250,
                ),
                width: double.infinity,
                child: const IngredientRecognitionAnimation(),
              ),
            ),
            const SizedBox(height: SpacingConsts.m),
            LabelButton(
              label: 'Recipe by Manual Input',
              type: LabelButtonType.secondary,
              leading: const Icon(Icons.search_rounded),
              onClicked: onRecipeSearchClicked,
            ),
          ],
        ),
      ),
    );
  }
}
