import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intellicook_mobile/providers/app_controller/recognize_ingredients.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ingredient_recognition_images.g.dart';

@riverpod
class IngredientRecognitionImages extends _$IngredientRecognitionImages {
  @override
  Future<IngredientRecognitionImagesState> build() async {
    return IngredientRecognitionImagesState();
  }

  Future<void> addImages(ImageSource source) async {
    try {
      final images = state.value!.images;
      final newStartIndex = images.length;
      final newImages = source == ImageSource.camera
          ? [await state.value!.picker.pickImage(source: source)]
          : await state.value!.picker.pickMultiImage();

      images.addAll(newImages
          .where((image) => image != null)
          .cast<XFile>()
          .map((image) => File(image.path).readAsBytesSync()));

      state = AsyncData(IngredientRecognitionImagesState(
        picker: state.value?.picker,
        images: images,
      ));

      for (var i = 0; i < newImages.length; i++) {
        ref.read(recognizeIngredientsProvider.notifier).recognizeIngredientsAt(
              newStartIndex + i,
              images[newStartIndex + i],
            );
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> rotateImage(int index) async {
    try {
      final images = state.value!.images;
      final image = images[index];

      final originalImage = img.decodeImage(image)!;
      final rotatedImage = img.copyRotate(originalImage, angle: 90);
      final finalImage = img.encodeJpg(rotatedImage);

      images[index] = finalImage;

      state = AsyncData(IngredientRecognitionImagesState(
        picker: state.value?.picker,
        images: images,
      ));

      ref.read(recognizeIngredientsProvider.notifier).redoAt(index, finalImage);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> removeImage(int index) async {
    try {
      final images = state.value!.images;
      images.removeAt(index);

      state = AsyncData(IngredientRecognitionImagesState(
        picker: state.value?.picker,
        images: images,
      ));

      ref.read(recognizeIngredientsProvider.notifier).removeAt(index);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

class IngredientRecognitionImagesState {
  IngredientRecognitionImagesState({
    picker,
    images,
  })  : picker = picker ?? ImagePicker(),
        images = images ?? [];

  final ImagePicker picker;
  final List<Uint8List> images;
}
