import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/globals/camera.dart';
import 'package:intellicook_mobile/providers/ingredient_recognition_frames.dart';
import 'package:intellicook_mobile/screens/nested/ingredient_frames_screen.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
import 'package:intellicook_mobile/utils/show_error_snack_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/circle_button.dart';

class IngredientRecognitionScreen extends ConsumerStatefulWidget {
  const IngredientRecognitionScreen({super.key});

  @override
  ConsumerState createState() => _IngredientRecognitionScreenState();
}

class _IngredientRecognitionScreenState extends ConsumerState
    with WidgetsBindingObserver {
  late CameraController controller;
  String? error;

  Future<void> initController(CameraDescription camera) async {
    controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    error = null;
    initController(cameras.first).then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      setState(() {
        error = switch (e) {
          CameraException e => switch (e.code) {
              'CameraAccessDenied' => 'Camera access denied',
              _ => e.code,
            },
          _ => 'An error occurred',
        };
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initController(controller.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    final frames = ref.watch(ingredientRecognitionFramesProvider);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    ref.listen(
      ingredientRecognitionFramesProvider,
      handleErrorAsSnackBar(context),
    );

    if (error != null) {
      showErrorSnackBar(
        context,
        error!,
      );
      Navigator.of(context).pop();
    }

    final mediaSize = MediaQuery.of(context).size;

    const sideButtonsWidth = CircleButton.defaultDiameter * 0.6;

    void onClicked() {
      ref
          .read(ingredientRecognitionFramesProvider.notifier)
          .capture(controller);
    }

    void onIngredientFramesClicked() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: IngredientFramesScreen(),
        ),
      ));
    }

    if (error != null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture ||
        frames is! AsyncData) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        const SizedBox.expand(),
        ClipRect(
          clipper: _MediaSizeClipper(mediaSize),
          child: Transform.scale(
            scale: 1 / (controller.value.aspectRatio * mediaSize.aspectRatio),
            alignment: Alignment.topCenter,
            child: CameraPreview(controller),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: sideButtonsWidth,
                  ),
                  const SizedBox(width: SpacingConsts.xl),
                  SizedBox(
                    width: CircleButton.defaultDiameter,
                    child: CircleButton(
                      primary: true,
                      onClicked: onClicked,
                      child: const Icon(
                        Icons.camera_alt,
                        size: CircleButton.defaultDiameter * 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(width: SpacingConsts.xl),
                  SizedBox(
                    width: sideButtonsWidth,
                    child: CircleButton(
                      diameter: sideButtonsWidth,
                      borderRadius: SmoothBorderRadiusConsts.s,
                      onClicked: onIngredientFramesClicked,
                      child: Center(
                        child: Text(
                          frames.value!.frames.length.toString(),
                          style: textTheme.titleSmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SpacingConsts.l),
            ],
          ),
        ),
      ],
    );
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  const _MediaSizeClipper(this.mediaSize);

  final Size mediaSize;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
