import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ingredient_recognition_images.g.dart';

@riverpod
class IngredientRecognitionImages extends _$IngredientRecognitionImages {
  @override
  Future<IngredientRecognitionImagesState> build() async {
    return IngredientRecognitionImagesState();
  }

  Future<void> pickImages(ImageSource source) async {
    try {
      state = const AsyncLoading();

      final images = state.value!.images;
      final newImages = source == ImageSource.camera
          ? [await state.value!.picker.pickImage(source: source)]
          : await state.value!.picker.pickMultiImage();

      images.addAll(newImages.where((image) => image != null).cast<XFile>());

      state = AsyncData(IngredientRecognitionImagesState(
        picker: state.value?.picker,
        images: images,
      ));
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
  final List<XFile> images;
}
