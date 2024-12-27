import 'package:control_style/control_style.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/opacity.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/widgets/low_level/elevated.dart';
import 'package:intellicook_mobile/widgets/low_level/glassmorphism.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    this.controller,
    this.focusNode,
    this.style,
    this.label,
    this.hint,
    this.help,
    this.error,
    this.counter,
    this.fillColor,
    this.focusColor,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.contentPadding,
    this.constraints,
    this.prefix,
    this.suffix,
    this.maxLines = defaultMaxLines,
    this.autofocus = defaultAutofocus,
    this.enabled = defaultEnabled,
    this.readOnly = defaultReadOnly,
    this.obscureText = defaultObscureText,
    this.filled = defaultFilled,
    this.isDense = defaultIsDense,
    this.isGlassmorphism = defaultIsGlassmorphism,
  });

  static const defaultMaxLines = 1;
  static const defaultAutofocus = false;
  static const defaultReadOnly = false;
  static const defaultEnabled = true;
  static const defaultObscureText = false;
  static const defaultFilled = true;
  static const defaultIsDense = false;
  static const defaultIsGlassmorphism = false;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final String? label;
  final String? hint;
  final String? help;
  final String? error;
  final String? counter;
  final Color? fillColor;
  final Color? focusColor;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final EdgeInsets? contentPadding;
  final BoxConstraints? constraints;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool filled;
  final bool isDense;
  final bool isGlassmorphism;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late final focusNode = widget.focusNode ?? FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Colors

    final filled = widget.filled;
    final colorOpacity = OpacityConsts.low(context);
    final fillColor = widget.fillColor ??
        theme.colorScheme.surfaceContainerLow.withOpacity(colorOpacity);
    final focusColor = widget.fillColor ??
        theme.colorScheme.surfaceContainerLowest.withOpacity(colorOpacity);
    final labelBackgroundColor = theme.colorScheme.surfaceContainerLow;

    // Animation

    const animationDuration = Duration(milliseconds: 80);
    const animationCurve = Curves.easeOut;

    // Borders

    final enabledBorderColor = theme.colorScheme.outline;
    final focusedBorderColor = IntelliCookTheme.primaryColor;
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

    // Glassmorphism

    final glassmorphism = switch (widget.isGlassmorphism) {
      true => (child) => ClipRRect(
            borderRadius: SmoothBorderRadius(
              cornerRadius: SmoothBorderRadiusConsts.sCornerRadius,
              cornerSmoothing: SmoothBorderRadiusConsts.cornerSmoothing,
            ),
            child: Glassmorphism(
              child: child,
            ),
          ),
      false => (child) => child,
    };

    return glassmorphism(
      AnimatedContainer(
        duration: animationDuration,
        curve: animationCurve,
        child: TextField(
          controller: widget.controller,
          focusNode: focusNode,
          style: widget.style,
          maxLines: widget.maxLines,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
          onSubmitted: widget.onSubmitted,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            isDense: widget.isDense,
            contentPadding: widget.contentPadding,
            constraints: widget.constraints,
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
            prefixIcon: widget.prefix,
            suffixIcon: widget.suffix,
            labelText: widget.label,
            hintText: widget.hint,
            helperText: widget.help,
            counterText: widget.counter,
            errorText: widget.error,
            errorMaxLines: 50,
          ),
        ),
      ),
    );
  }
}
