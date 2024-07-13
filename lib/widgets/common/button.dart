import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/extensions/tonal_palette_extensions.dart';
import 'package:intellicook_mobile/widgets/common/clickable.dart';
import 'package:intellicook_mobile/widgets/common/elevated.dart';

class Button extends StatefulWidget {
  const Button({
    super.key,
    this.onClick,
    this.onPress,
    this.onRelease,
    this.onStateChange,
    this.pressedColor,
    this.releasedColor,
    this.pressedBorder,
    this.releasedBorder,
    this.child,
  });

  Button.primary({
    super.key,
    this.onClick,
    this.onPress,
    this.onRelease,
    this.onStateChange,
    this.pressedBorder,
    this.releasedBorder,
    Color? pressedColor,
    Color? releasedColor,
    this.child,
  })  : pressedColor = pressedColor ??
            IntelliCookTheme.primaryPalette.getColor(pressedPaletteTone),
        releasedColor = releasedColor ??
            IntelliCookTheme.primaryPalette.getColor(releasedPaletteTone);

  Button.secondary({
    super.key,
    this.onClick,
    this.onPress,
    this.onRelease,
    this.onStateChange,
    this.pressedColor,
    this.releasedColor,
    BoxBorder? pressedBorder,
    BoxBorder? releasedBorder,
    this.child,
  })  : pressedBorder = pressedBorder ??
            Border.all(
              color:
                  IntelliCookTheme.primaryPalette.getColor(pressedPaletteTone),
              width: secondaryBorderWidth,
            ),
        releasedBorder = releasedBorder ??
            Border.all(
              color:
                  IntelliCookTheme.primaryPalette.getColor(releasedPaletteTone),
              width: secondaryBorderWidth,
            );

  final ClickableOnClickCallback? onClick;
  final ClickableOnPressCallback? onPress;
  final ClickableOnReleaseCallback? onRelease;
  final ClickableOnStateChangeCallback? onStateChange;
  final Color? pressedColor;
  final Color? releasedColor;
  final BoxBorder? pressedBorder;
  final BoxBorder? releasedBorder;
  final Widget? child;

  static const minHeight = 40.0;
  static const minWidth = 50.0;
  static const pressedPaletteTone = 70;
  static const releasedPaletteTone = 80;
  static const secondaryBorderWidth = 1.5;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pressedColor =
        widget.pressedColor ?? theme.colorScheme.surfaceContainerLow;
    final releasedColor =
        widget.releasedColor ?? theme.colorScheme.surfaceContainerLowest;

    return Clickable(
      onClick: widget.onClick,
      onPress: widget.onPress,
      onRelease: widget.onRelease,
      onStateChange: (bool isPressed) {
        setState(() {
          this.isPressed = isPressed;
        });
        widget.onStateChange?.call(isPressed);
      },
      child: Elevated.low(
        constraints: const BoxConstraints(
          minHeight: Button.minHeight,
          minWidth: Button.minWidth,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: SpacingConsts.s,
          horizontal: SpacingConsts.m,
        ),
        color: isPressed ? pressedColor : releasedColor,
        border: isPressed ? widget.pressedBorder : widget.releasedBorder,
        animatedElevatedArgs: const AnimatedElevatedArgs(),
        insetShadow: isPressed,
        child: widget.child,
      ),
    );
  }
}
