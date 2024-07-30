import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/high_level/toggle_switch.dart';

class LabelToggleSwitch extends StatelessWidget {
  const LabelToggleSwitch({
    super.key,
    required this.label,
    this.initialValue = defaultInitialValue,
    this.onChanged,
    this.enabled = defaultEnabled,
  });

  static const defaultInitialValue = false;
  static const defaultEnabled = true;

  final String label;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(label,
            style: enabled
                ? theme.textTheme.bodyLarge
                : theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.disabledColor)),
        const SizedBox(width: SpacingConsts.s),
        ToggleSwitch(
          initialValue: initialValue,
          onChanged: onChanged,
          enabled: enabled,
        )
      ],
    );
  }
}
