import 'package:flutter/material.dart';

typedef DropdownEntry<T> = DropdownMenuEntry<T>;

class Dropdown<T> extends StatelessWidget {
  const Dropdown({
    super.key,
    this.label,
    this.initialValue,
    required this.entries,
  });

  final String? label;
  final T? initialValue;
  final List<DropdownEntry<T>> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownMenu(
      label: switch (label) {
        null => null,
        String label => Text(
            label,
            style: theme.textTheme.bodyLarge,
          ),
      },
      initialSelection: initialValue,
      dropdownMenuEntries: entries,
    );
  }
}
