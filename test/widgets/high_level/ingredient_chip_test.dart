import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellicook_mobile/widgets/high_level/ingredient_chip.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures.dart';
@GenerateNiceMocks([MockSpec<IngredientChipCallbacks>()])
import 'ingredient_chip_test.mocks.dart';

abstract class IngredientChipCallbacks {
  void onEdit(String ingredient);

  void onRemove();
}

const ingredient = 'Ingredient';

void main() {
  testWidgets(
    'Ingredient chip shows ingredient',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MockMaterialApp(
        child: Material(
          child: IngredientChip(
            ingredient: ingredient,
          ),
        ),
      ));

      expect(find.text(ingredient), findsOneWidget);
    },
  );

  testWidgets(
    'Ingredient chip shows ingredient and callbacks',
    (WidgetTester tester) async {
      final onEdit = MockIngredientChipCallbacks().onEdit;
      final onRemove = MockIngredientChipCallbacks().onRemove;

      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: IngredientChip(
            ingredient: ingredient,
            onEdit: onEdit,
            onRemove: onRemove,
          ),
        ),
      ));

      expect(find.text(ingredient), findsOneWidget);
      expect(find.byIcon(Icons.edit_rounded), findsOneWidget);
      expect(find.byIcon(Icons.delete_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'Ingredient chip calls onEdit when clicked',
    (WidgetTester tester) async {
      final onEdit = MockIngredientChipCallbacks().onEdit;
      final onRemove = MockIngredientChipCallbacks().onRemove;

      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: IngredientChip(
            ingredient: ingredient,
            onEdit: onEdit,
            onRemove: onRemove,
          ),
        ),
      ));

      await tester.tap(find.byIcon(Icons.edit_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.check_rounded));

      verify(onEdit(ingredient)).called(1);
    },
  );

  testWidgets(
    'Ingredient chip calls onRemove when clicked',
    (WidgetTester tester) async {
      final onEdit = MockIngredientChipCallbacks().onEdit;
      final onRemove = MockIngredientChipCallbacks().onRemove;

      await tester.pumpWidget(MockMaterialApp(
        child: Material(
          child: IngredientChip(
            ingredient: ingredient,
            onEdit: onEdit,
            onRemove: onRemove,
          ),
        ),
      ));

      await tester.tap(find.byIcon(Icons.delete_rounded));
      verify(onRemove()).called(1);
    },
  );
}
