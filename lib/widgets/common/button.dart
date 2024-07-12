import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/extensions/tonal_palette_extensions.dart';
import 'package:intellicook_mobile/widgets/common/clickable.dart';
import 'package:intellicook_mobile/widgets/common/elevated.dart';

class BaseButton extends StatefulWidget {
  const BaseButton({
    super.key,
    this.pressedColor,
    this.releasedColor,
    this.pressedBorder,
    this.releasedBorder,
    this.onClick,
    this.onPress,
    this.onRelease,
    this.onStateChange,
    this.child,
  });

  final Color? pressedColor;
  final Color? releasedColor;
  final BoxBorder? pressedBorder;
  final BoxBorder? releasedBorder;
  final ClickableOnClickCallback? onClick;
  final ClickableOnPressCallback? onPress;
  final ClickableOnReleaseCallback? onRelease;
  final ClickableOnStateChangeCallback? onStateChange;
  final Widget? child;

  @override
  State<BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton> {
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
          minHeight: 40.0,
          minWidth: 50.0,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: SpacingConsts.s,
          horizontal: SpacingConsts.m,
        ),
        color: isPressed ? pressedColor : releasedColor,
        border: isPressed ? widget.pressedBorder : widget.releasedBorder,
        isAnimated: true,
        insetShadow: isPressed,
        child: widget.child,
      ),
    );
  }
}

class PrimaryButton extends BaseButton {
  PrimaryButton({
    super.key,
    super.onClick,
    super.onPress,
    super.onRelease,
    super.onStateChange,
    Color? pressedColor,
    Color? releasedColor,
    super.child,
  }) : super(
          pressedColor:
              pressedColor ?? IntelliCookTheme.primaryPalette.getColor(70),
          releasedColor:
              releasedColor ?? IntelliCookTheme.primaryPalette.getColor(80),
        );
}

class SecondaryButton extends BaseButton {
  SecondaryButton({
    super.key,
    super.onClick,
    super.onPress,
    super.onRelease,
    super.onStateChange,
    BoxBorder? pressedBorder,
    BoxBorder? releasedBorder,
    super.child,
  }) : super(
          pressedBorder: pressedBorder ??
              Border.all(
                color: IntelliCookTheme.primaryPalette.getColor(70),
                width: 1.5,
              ),
          releasedBorder: releasedBorder ??
              Border.all(
                color: IntelliCookTheme.primaryPalette.getColor(80),
                width: 1.5,
              ),
        );
}
