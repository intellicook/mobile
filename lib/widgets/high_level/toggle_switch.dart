import 'package:flutter/material.dart' hide Switch;
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/widgets/low_level/elevated.dart';
import 'package:intellicook_mobile/widgets/low_level/toggle_switch_switch.dart';

class ToggleSwitch extends StatefulWidget {
  const ToggleSwitch({
    super.key,
    this.value = defaultValue,
    this.onChanged,
    this.enabled = defaultEnabled,
  });

  static const defaultValue = false;
  static const defaultEnabled = true;

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Track

    final trackColor = WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }

      if (states.contains(WidgetState.selected)) {
        return IntelliCookTheme.primaryColor;
      }

      return theme.colorScheme.surfaceContainerLowest.withOpacity(0.5);
    });
    final trackOutlineWidth = WidgetStateProperty.all(1.5);

    // Thumb

    final thumbColor = WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }

      if (states.contains(WidgetState.selected)) {
        return theme.colorScheme.surfaceContainerLowest;
      }

      return null;
    });

    // Callback

    final onChanged = switch (widget.enabled) {
      true => (newValue) {
          setState(() {
            value = newValue;
          });
          widget.onChanged?.call(newValue);
        },
      false => null,
    };

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Elevated.low(
            padding: EdgeInsets.zero,
            shadows: widget.enabled ? null : [],
            animatedElevatedArgs: const AnimatedElevatedArgs(
              duration: Duration(milliseconds: 80),
              curve: Curves.easeOut,
            ),
            borderRadius: BorderRadius.circular(16.0),
            // Dimensions from switch material 3 default config
            child: const SizedBox(height: 32.0, width: 52.0),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          trackColor: trackColor,
          trackOutlineWidth: trackOutlineWidth,
          thumbColor: thumbColor,
          splashRadius: 0,
        )
      ],
    );
  }
}
