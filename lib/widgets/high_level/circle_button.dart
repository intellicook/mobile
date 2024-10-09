import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/low_level/button.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    this.primary = defaultPrimary,
    this.onClicked,
    this.onPressed,
    this.onReleased,
    this.onStateChanged,
    this.enabled = defaultEnabled,
    this.diameter = defaultDiameter,
    this.borderRadius,
    this.child,
  });

  static const defaultPrimary = false;
  static const defaultEnabled = true;
  static const defaultDiameter = SpacingConsts.xl;

  final bool primary;
  final ClickableOnClickedCallback? onClicked;
  final ClickableOnPressedCallback? onPressed;
  final ClickableOnReleasedCallback? onReleased;
  final ClickableOnStateChangedCallback? onStateChanged;
  final bool enabled;
  final double diameter;
  final BorderRadius? borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final buttonFactory = primary ? Button.primary : Button.secondary;

    return buttonFactory(
      onClicked: onClicked,
      onPressed: onPressed,
      onReleased: onReleased,
      onStateChanged: onStateChanged,
      enabled: enabled,
      constraints: BoxConstraints.tightFor(
        width: diameter,
        height: diameter,
      ),
      padding: EdgeInsets.zero,
      borderRadius: borderRadius ?? BorderRadius.circular(diameter / 2),
      child: child,
    );
  }
}
