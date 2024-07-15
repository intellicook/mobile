import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius_consts.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/extensions/tonal_palette_extensions.dart';
import 'package:intellicook_mobile/widgets/common/elevated.dart';

class InputField extends StatefulWidget {
  const InputField({super.key});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Colors

    const colorOpacity = 0.5;
    final fillColor =
        theme.colorScheme.surfaceContainerLow.withOpacity(colorOpacity);
    final focusColor =
        theme.colorScheme.surfaceContainerLowest.withOpacity(colorOpacity);

    // Borders

    final enabledBorderColor = theme.colorScheme.outline;
    final focusedBorderColor = IntelliCookTheme.primaryPalette.getColor(70);
    final borderRadius = SmoothBorderRadius(
      cornerRadius: SmoothBorderRadiusConsts.sCornerRadius,
      cornerSmoothing: SmoothBorderRadiusConsts.cornerSmoothing,
    );
    const borderWidth = 1.5;
    final borderSide = BorderSide(
      width: borderWidth,
      color: enabledBorderColor,
    );
    final enabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    );
    final focusedBorder = enabledBorder.copyWith(
      borderSide: borderSide.copyWith(
        color: focusedBorderColor,
      ),
    );
    final errorBorder = enabledBorder.copyWith(
      borderSide: borderSide.copyWith(
        color: theme.colorScheme.error,
      ),
    );
    final focusedErrorBorder = focusedBorder.copyWith(
      borderSide: borderSide.copyWith(
        color: theme.colorScheme.error,
      ),
    );
    final disabledBorder = enabledBorder.copyWith(
      borderSide: borderSide.copyWith(
        color: theme.disabledColor,
      ),
    );

    return Elevated.low(
      padding: EdgeInsets.zero,
      shadows: focusNode.hasFocus ? Elevated.lowShadows() : null,
      clipBehavior: Clip.none,
      animatedElevatedArgs: const AnimatedElevatedArgs(
        duration: Duration(milliseconds: 80),
        curve: Curves.easeOut,
      ),
      child: TextField(
        focusNode: focusNode,
        decoration: InputDecoration(
          filled: true,
          fillColor: focusNode.hasFocus ? focusColor : fillColor,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: focusedErrorBorder,
          disabledBorder: disabledBorder,
          labelText: 'Enter your username',
        ),
      ),
    );
  }
}
