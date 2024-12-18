import 'dart:typed_data';

import 'package:app_controller_client/app_controller_client.dart';
import 'package:dio/dio.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recognize_ingredients.g.dart';

@riverpod
class RecognizeIngredients extends _$RecognizeIngredients {
  @override
  Future<RecognizeIngredientsState> build() async {
    return const RecognizeIngredientsState.init();
  }

  Future<void> recognizeIngredientsAt(int index, Uint8List image) async {
    final client = ref.watch(appControllerProvider).client;
    final api = client.getIngredientRecognitionApi();
    final imageIngredients = state.value!.imageIngredients;

    state = AsyncData(RecognizeIngredientsState.loading(
      imageIngredients,
      index,
    ));

    try {
      final response = await api.ingredientRecognitionRecognizeIngredientsPost(
        image: MultipartFile.fromBytes(
          image,
          filename: 'image.jpg',
          contentType: DioMediaType.parse('image/jpeg'),
        ),
      );

      state = AsyncData(RecognizeIngredientsState.success(
        imageIngredients,
        index,
        response.data!.ingredients.toList(),
      ));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> redoAt(int index, Uint8List image) async {
    final client = ref.watch(appControllerProvider).client;
    final api = client.getIngredientRecognitionApi();
    final imageIngredients = state.value!.imageIngredients;

    state = AsyncData(RecognizeIngredientsState.loading(
      imageIngredients,
      index,
      isNew: false,
    ));

    try {
      final response = await api.ingredientRecognitionRecognizeIngredientsPost(
        image: MultipartFile.fromBytes(
          image,
          filename: 'image.jpg',
          contentType: DioMediaType.parse('image/jpeg'),
        ),
      );

      state = AsyncData(RecognizeIngredientsState.success(
        imageIngredients,
        index,
        response.data!.ingredients.toList(),
      ));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> removeAt(int index) async {
    final imageIngredients = state.value!.imageIngredients;

    state = AsyncData(RecognizeIngredientsState.remove(
      imageIngredients,
      index,
    ));
  }
}

class RecognizeIngredientsState {
  const RecognizeIngredientsState.init() : imageIngredients = const [];

  RecognizeIngredientsState.loading(
      List<List<RecognizeIngredientsIngredientModel>?> imageIngredients,
      int index,
      {bool isNew = true})
      : imageIngredients = switch (isNew) {
          true => [
              ...imageIngredients.take(index),
              null,
              ...imageIngredients.skip(index)
            ],
          false => [
              for (var i = 0; i < imageIngredients.length; i++)
                i == index ? null : imageIngredients[i],
            ],
        };

  RecognizeIngredientsState.success(
      List<List<RecognizeIngredientsIngredientModel>?> imageIngredients,
      int index,
      List<RecognizeIngredientsIngredientModel> ingredients)
      : imageIngredients = [
          ...imageIngredients.take(index),
          ingredients,
          ...imageIngredients.skip(index),
        ];

  RecognizeIngredientsState.remove(
      List<List<RecognizeIngredientsIngredientModel>?> imageIngredients,
      int index)
      : imageIngredients = imageIngredients
            .asMap()
            .entries
            .where((e) => e.key != index)
            .map((e) => e.value)
            .toList();

  final List<List<RecognizeIngredientsIngredientModel>?> imageIngredients;
}
