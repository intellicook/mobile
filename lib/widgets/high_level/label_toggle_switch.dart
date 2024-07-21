import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/high_level/toggle_switch.dart';

class LabelToggleSwitch extends StatelessWidget {
  const LabelToggleSwitch({
    super.key,
    required this.label,
    this.value = defaultValue,
    this.onChanged,
    this.enabled = defaultEnabled,
  });

  static const defaultValue = false;
  static const defaultEnabled = true;

  final String label;
  final bool value;
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
          value: value,
          onChanged: onChanged,
          enabled: enabled,
        )
      ],
    );
  }
}
