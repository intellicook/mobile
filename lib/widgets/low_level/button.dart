import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/opacity.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';
import 'package:intellicook_mobile/widgets/low_level/elevated.dart';

class Button extends StatefulWidget {
  const Button({
    super.key,
    this.onClicked,
    this.onPressed,
    this.onReleased,
    this.onStateChanged,
    this.enabled = defaultEnabled,
    this.pressedColor,
    this.releasedColor,
    this.disabledColor,
    this.pressedBorder,
    this.releasedBorder,
    this.disabledBorder,
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
    this.enabled = defaultEnabled,
    this.pressedBorder,
    this.releasedBorder,
    this.disabledBorder,
    this.constraints = defaultConstraints,
    this.padding = defaultPadding,
    this.animatedElevatedArgs = defaultAnimatedElevatedArgs,
    Color? pressedColor,
    Color? releasedColor,
    this.disabledColor,
    this.child,
  })  : pressedColor = pressedColor ?? IntelliCookTheme.primaryColorDark,
        releasedColor = releasedColor ?? IntelliCookTheme.primaryColor;

  Button.secondary({
    super.key,
    this.onClicked,
    this.onPressed,
    this.onReleased,
    this.onStateChanged,
    this.enabled = defaultEnabled,
    this.pressedColor,
    this.releasedColor,
    this.disabledColor = secondaryDisabledColor,
    this.constraints = defaultConstraints,
    this.padding = defaultPadding,
    this.animatedElevatedArgs = defaultAnimatedElevatedArgs,
    BoxBorder? pressedBorder,
    BoxBorder? releasedBorder,
    this.disabledBorder,
    this.child,
  })  : pressedBorder = pressedBorder ??
            Border.all(
              color: IntelliCookTheme.primaryColorDark,
              width: secondaryBorderWidth,
            ),
        releasedBorder = releasedBorder ??
            Border.all(
              color: IntelliCookTheme.primaryColor,
              width: secondaryBorderWidth,
            );

  static const defaultEnabled = true;
  static const minHeight = 40.0;
  static const minWidth = 50.0;
  static const secondaryDisabledColor = Colors.transparent;
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
  final bool enabled;
  final Color? pressedColor;
  final Color? releasedColor;
  final Color? disabledColor;
  final BoxBorder? pressedBorder;
  final BoxBorder? releasedBorder;
  final BoxBorder? disabledBorder;
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
    const opacity = OpacityConsts.low;
    final pressedColor = widget.pressedColor ??
        theme.colorScheme.surfaceContainerLow.withOpacity(opacity);
    final releasedColor = widget.releasedColor ??
        theme.colorScheme.surfaceContainerLowest.withOpacity(opacity);
    final disabledColor = widget.disabledColor ??
        (theme.brightness == Brightness.light
            ? Colors.black12
            : Colors.white10);
    final disabledBorder = widget.disabledBorder ??
        (widget.releasedBorder == null
            ? null
            : Border.all(
                color: theme.disabledColor,
                width: Button.secondaryBorderWidth,
              ));

    return Clickable(
      onClicked: widget.enabled ? widget.onClicked : null,
      onPressed: widget.enabled ? widget.onPressed : null,
      onReleased: widget.enabled ? widget.onReleased : null,
      onStateChanged: widget.enabled
          ? (bool isPressed) {
              setState(() {
                this.isPressed = isPressed;
              });
              widget.onStateChanged?.call(isPressed);
            }
          : null,
      child: Elevated.low(
        constraints: widget.constraints,
        padding: widget.padding,
        color: widget.enabled
            ? isPressed
                ? pressedColor
                : releasedColor
            : disabledColor,
        border: widget.enabled
            ? isPressed
                ? widget.pressedBorder
                : widget.releasedBorder
            : disabledBorder,
        animatedElevatedArgs: widget.animatedElevatedArgs,
        insetShadow: widget.enabled && isPressed,
        shadows: widget.enabled ? null : [],
        child: widget.child,
      ),
    );
  }
}
