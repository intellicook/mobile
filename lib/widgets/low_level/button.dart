import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/extensions/tonal_palette_extensions.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';
import 'package:intellicook_mobile/widgets/low_level/elevated.dart';

class Button extends StatefulWidget {
  const Button({
    super.key,
    this.onClicked,
    this.onPressed,
    this.onReleased,
    this.onStateChanged,
    this.pressedColor,
    this.releasedColor,
    this.pressedBorder,
    this.releasedBorder,
    this.constraints = defaultConstraints,
    this.padding = defaultPadding,
    this.animatedElevatedArgs = defaultAnimatedElevatedArgs,
    this.child,
  });

  Button.primary({
    super.key,
    this.onClicked,
    this.onPressed,
    this.onReleased,
    this.onStateChanged,
    this.pressedBorder,
    this.releasedBorder,
    this.constraints = defaultConstraints,
    this.padding = defaultPadding,
    this.animatedElevatedArgs = defaultAnimatedElevatedArgs,
    Color? pressedColor,
    Color? releasedColor,
    this.child,
  })  : pressedColor = pressedColor ??
            IntelliCookTheme.primaryPalette.getColor(pressedPaletteTone),
        releasedColor = releasedColor ??
            IntelliCookTheme.primaryPalette.getColor(releasedPaletteTone);

  Button.secondary({
    super.key,
    this.onClicked,
    this.onPressed,
    this.onReleased,
    this.onStateChanged,
    this.pressedColor,
    this.releasedColor,
    this.constraints = defaultConstraints,
    this.padding = defaultPadding,
    this.animatedElevatedArgs = defaultAnimatedElevatedArgs,
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

  static const minHeight = 40.0;
  static const minWidth = 50.0;
  static const pressedPaletteTone = 70;
  static const releasedPaletteTone = 80;
  static const secondaryBorderWidth = 1.5;
  static const defaultConstraints = BoxConstraints(
    minHeight: Button.minHeight,
    minWidth: Button.minWidth,
  );
  static const defaultPadding = EdgeInsets.symmetric(
    vertical: SpacingConsts.s,
    horizontal: SpacingConsts.m,
  );
  static const defaultAnimatedElevatedArgs = AnimatedElevatedArgs(
    duration: Duration(milliseconds: 80),
    curve: Curves.easeOut,
  );

  final ClickableOnClickedCallback? onClicked;
  final ClickableOnPressedCallback? onPressed;
  final ClickableOnReleasedCallback? onReleased;
  final ClickableOnStateChangedCallback? onStateChanged;
  final Color? pressedColor;
  final Color? releasedColor;
  final BoxBorder? pressedBorder;
  final BoxBorder? releasedBorder;
  final BoxConstraints? constraints;
  final EdgeInsets? padding;
  final AnimatedElevatedArgs? animatedElevatedArgs;
  final Widget? child;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const opacity = 0.5;
    final pressedColor = widget.pressedColor ??
        theme.colorScheme.surfaceContainerLow.withOpacity(opacity);
    final releasedColor = widget.releasedColor ??
        theme.colorScheme.surfaceContainerLowest.withOpacity(opacity);

    return Clickable(
      onClicked: widget.onClicked,
      onPressed: widget.onPressed,
      onReleased: widget.onReleased,
      onStateChanged: (bool isPressed) {
        setState(() {
          this.isPressed = isPressed;
        });
        widget.onStateChanged?.call(isPressed);
      },
      child: Elevated.low(
        constraints: widget.constraints,
        padding: widget.padding,
        color: isPressed ? pressedColor : releasedColor,
        border: isPressed ? widget.pressedBorder : widget.releasedBorder,
        animatedElevatedArgs: widget.animatedElevatedArgs,
        insetShadow: isPressed,
        child: widget.child,
      ),
    );
  }
}
