import 'package:control_style/control_style.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart' hide DropdownMenu, DropdownMenuEntry;
import 'package:intellicook_mobile/constants/opacity.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius_consts.dart';
import 'package:intellicook_mobile/widgets/low_level/dropdown_dropdown_menu.flutter.dart';

typedef DropdownEntry<T> = DropdownMenuEntry<T>;

class Dropdown<T> extends StatelessWidget {
  const Dropdown({
    super.key,
    this.label,
    this.hint,
    this.help,
    this.error,
    this.initialValue,
    this.enabled = defaultEnabled,
    this.width,
    this.onChanged,
    required this.entries,
  });

  static const defaultEnabled = true;

  final String? label;
  final String? hint;
  final String? help;
  final String? error;
  final T? initialValue;
  final bool enabled;
  final double? width;
  final ValueChanged<T?>? onChanged;
  final List<DropdownEntry<T>> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final label = switch (this.label) {
      null => null,
      String label => Text(label),
    };

    // Colors

    const filled = true;
    final fillColor =
        theme.colorScheme.surfaceContainerLow.withOpacity(OpacityConsts.low);
    final labelBackgroundColor = theme.colorScheme.surfaceContainerLow;

    // Borders

    final enabledBorderColor = theme.colorScheme.outline;
    final borderRadius = SmoothBorderRadius(
      cornerRadius: SmoothBorderRadiusConsts.sCornerRadius,
      cornerSmoothing: SmoothBorderRadiusConsts.cornerSmoothing,
    );
    const borderWidth = 1.5;
    final borderSide = BorderSide(
      width: borderWidth,
      color: enabledBorderColor,
    );
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    );
    final enabledBorder = DecoratedInputBorder(
      child: outlineInputBorder,
    );
    final errorBorder = enabledBorder.copyWith(
      child: outlineInputBorder.copyWith(
        borderSide: borderSide.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    ) as DecoratedInputBorder;
    final disabledBorder = enabledBorder.copyWith(
      child: outlineInputBorder.copyWith(
        borderSide: borderSide.copyWith(
          color: theme.disabledColor,
        ),
      ),
    ) as DecoratedInputBorder;

    return DropdownMenu(
      label: label,
      hintText: hint,
      helperText: help,
      errorText: error,
      initialSelection: initialValue,
      width: width,
      enabled: enabled,
      enableSearch: false,
      onSelected: onChanged,
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        filled: filled,
        fillColor: fillColor,
        enabledBorder: enabledBorder,
        errorBorder: errorBorder,
        disabledBorder: disabledBorder,
        floatingLabelStyle: TextStyle(
          backgroundColor: labelBackgroundColor,
        ),
      ),
      dropdownMenuEntries: entries,
    );
  }
}
