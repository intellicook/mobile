import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ingredient_recognition_frames.g.dart';

@riverpod
class IngredientRecognitionFrames extends _$IngredientRecognitionFrames {
  @override
  Future<IngredientRecognitionFramesState> build() async {
    return IngredientRecognitionFramesState();
  }

  Future<void> capture(CameraController cameraController) async {
    try {
      if (state is! AsyncData) {
        throw StateError('Frames provider is not ready');
      }

      final framesBytes = state.value!.framesBytes;
      final frames = state.value!.frames;

      final imageFile = await cameraController.takePicture();
      final imageBytes = await imageFile.readAsBytes();
      final uiImage = await decodeImageFromList(imageBytes);

      framesBytes.add(imageBytes);
      frames.add(uiImage);

      state = AsyncData(IngredientRecognitionFramesState(
        framesBytes: framesBytes,
        frames: frames,
      ));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

class IngredientRecognitionFramesState {
  IngredientRecognitionFramesState({
    framesBytes,
    frames,
  })  : framesBytes = framesBytes ?? [],
        frames = frames ?? [];

  final List<Uint8List> framesBytes;
  final List<ui.Image> frames;
}
