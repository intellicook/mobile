import 'package:control_style/control_style.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius_consts.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/extensions/tonal_palette_extensions.dart';
import 'package:intellicook_mobile/widgets/low_level/elevated.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.help,
    this.error,
    this.counter,
    this.enabled = defaultEnabled,
  });

  static const defaultEnabled = true;

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? help;
  final String? error;
  final String? counter;
  final bool enabled;

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

    const filled = true;
    const colorOpacity = 0.5;
    final fillColor =
        theme.colorScheme.surfaceContainerLow.withOpacity(colorOpacity);
    final focusColor =
        theme.colorScheme.surfaceContainerLowest.withOpacity(colorOpacity);
    final labelBackgroundColor = theme.colorScheme.surfaceContainerLow;

    // Animation

    const animationDuration = Duration(milliseconds: 80);
    const animationCurve = Curves.easeOut;

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
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    );
    final enabledBorder = DecoratedInputBorder(
      shadow: focusNode.hasFocus ? Elevated.lowShadows() : [],
      child: outlineInputBorder,
    );
    final focusedBorder = enabledBorder.copyWith(
      child: outlineInputBorder.copyWith(
        borderSide: borderSide.copyWith(
          color: focusedBorderColor,
        ),
      ),
    ) as DecoratedInputBorder;
    final errorBorder = enabledBorder.copyWith(
      child: outlineInputBorder.copyWith(
        borderSide: borderSide.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    ) as DecoratedInputBorder;
    final focusedErrorBorder = focusedBorder.copyWith(
      child: outlineInputBorder.copyWith(
        borderSide: borderSide.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    ) as DecoratedInputBorder;
    final disabledBorder = enabledBorder.copyWith(
      child: outlineInputBorder.copyWith(
        borderSide: borderSide.copyWith(
          color: theme.disabledColor,
        ),
      ),
    ) as DecoratedInputBorder;

    return AnimatedContainer(
      duration: animationDuration,
      curve: animationCurve,
      child: TextField(
        controller: widget.controller,
        focusNode: focusNode,
        enabled: widget.enabled,
        decoration: InputDecoration(
          filled: filled,
          fillColor: focusNode.hasFocus ? focusColor : fillColor,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: focusedErrorBorder,
          disabledBorder: disabledBorder,
          floatingLabelStyle: TextStyle(
            backgroundColor: labelBackgroundColor,
          ),
          labelText: widget.label,
          hintText: widget.hint,
          helperText: widget.help,
          counterText: widget.counter,
          errorText: widget.error,
        ),
      ),
    );
  }
}
