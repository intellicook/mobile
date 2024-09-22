import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius.dart';
import 'package:intellicook_mobile/widgets/low_level/button.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';
import 'package:rive/rive.dart';

class RiveButton extends StatelessWidget {
  const RiveButton({
    super.key,
    required this.rive,
    this.height,
    this.width,
    this.enabled = defaultEnabled,
    this.onClicked,
    this.onPressed,
    this.onReleased,
    this.onStateChanged,
  });

  static const defaultEnabled = true;

  final RiveAnimation rive;
  final double? height;
  final double? width;
  final bool enabled;
  final ClickableOnClickedCallback? onClicked;
  final ClickableOnPressedCallback? onPressed;
  final ClickableOnReleasedCallback? onReleased;
  final ClickableOnStateChangedCallback? onStateChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Button.secondary(
            onClicked: onClicked,
            onPressed: onPressed,
            onReleased: onReleased,
            onStateChanged: onStateChanged,
            enabled: enabled,
            padding: EdgeInsets.zero,
            child: const ColoredBox(color: Colors.transparent),
          ),
        ),
        ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: SmoothBorderRadiusConsts.s,
          child: SizedBox(
            height: height,
            width: width,
            child: rive,
          ),
        ),
      ],
    );
  }
}
