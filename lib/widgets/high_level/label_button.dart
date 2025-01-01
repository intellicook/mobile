import 'package:flutter/material.dart';
import 'package:intellicook_mobile/utils/extensions/theme_data.dart';
import 'package:intellicook_mobile/widgets/low_level/button.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';

enum LabelButtonType {
  primary,
  secondary,
}

class LabelButton extends StatelessWidget {
  const LabelButton({
    super.key,
    required this.label,
    this.type = defaultType,
    this.enabled = defaultEnabled,
    this.isHigh = defaultIsHigh,
    this.leading,
    this.onClicked,
    this.onPressed,
    this.onReleased,
    this.onStateChanged,
  });

  static const defaultType = LabelButtonType.primary;
  static const defaultEnabled = true;
  static const defaultIsHigh = false;

  final String label;
  final LabelButtonType type;
  final bool enabled;
  final bool isHigh;
  final Widget? leading;
  final ClickableOnClickedCallback? onClicked;
  final ClickableOnPressedCallback? onPressed;
  final ClickableOnReleasedCallback? onReleased;
  final ClickableOnStateChangedCallback? onStateChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonFactory = switch (type) {
      LabelButtonType.primary => Button.primary,
      LabelButtonType.secondary => Button.secondary,
    };

    final textStyle = switch (type) {
      LabelButtonType.primary => theme.textTheme.bodyLarge?.copyWith(
          color: theme.onMain,
        ),
      LabelButtonType.secondary => theme.textTheme.bodyLarge,
    };

    return buttonFactory(
      onClicked: onClicked,
      onPressed: onPressed,
      onReleased: onReleased,
      onStateChanged: onStateChanged,
      enabled: enabled,
      isHigh: isHigh,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...(leading != null
                ? [
                    leading!,
                    const SizedBox(width: 8),
                  ]
                : const []),
            Flexible(
              child: Text(
                label,
                style: enabled
                    ? textStyle
                    : textStyle?.copyWith(
                        color: theme.disabledColor,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
