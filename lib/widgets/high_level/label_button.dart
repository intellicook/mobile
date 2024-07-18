import 'package:flutter/material.dart';
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
    this.onClick,
    this.onPress,
    this.onRelease,
    this.onStateChange,
  });

  static const defaultType = LabelButtonType.primary;

  final String label;
  final LabelButtonType type;
  final ClickableOnClickCallback? onClick;
  final ClickableOnPressCallback? onPress;
  final ClickableOnReleaseCallback? onRelease;
  final ClickableOnStateChangeCallback? onStateChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonFactory = switch (type) {
      LabelButtonType.primary => Button.primary,
      LabelButtonType.secondary => Button.secondary,
    };

    final textStyle = switch (type) {
      LabelButtonType.primary => theme.textTheme.bodyLarge?.copyWith(
          color: theme.brightness == Brightness.light
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onInverseSurface,
        ),
      LabelButtonType.secondary => theme.textTheme.bodyLarge,
    };

    return buttonFactory(
      onClick: onClick,
      onPress: onPress,
      onRelease: onRelease,
      onStateChange: onStateChange,
      child: Center(
        child: Text(
          label,
          style: textStyle,
        ),
      ),
    );
  }
}
