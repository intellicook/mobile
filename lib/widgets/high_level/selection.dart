import 'package:flutter/material.dart';

typedef SelectionButton<T> = ButtonSegment<T>;
typedef OnSelectionChanged<T> = ValueChanged<T>;
typedef OnMultiSelectionChanged<T> = ValueChanged<Set<T>>;

class Selection<T> extends StatefulWidget {
  const Selection({
    super.key,
    required this.buttons,
    required this.selected,
    this.onMultiSelectionChanged,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
  });

  Selection.single({
    super.key,
    required this.buttons,
    required T selected,
    OnSelectionChanged<T>? onSelectionChanged,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
  })  : selected = {selected},
        onMultiSelectionChanged = onSelectionChanged == null
            ? null
            : ((selected) => onSelectionChanged(selected.first));

  const Selection.multi({
    super.key,
    required this.buttons,
    required this.selected,
    this.onMultiSelectionChanged,
    this.multiSelectionEnabled = true,
    this.emptySelectionAllowed = false,
  });

  final List<SelectionButton<T>> buttons;
  final Set<T> selected;
  final OnMultiSelectionChanged<T>? onMultiSelectionChanged;
  final bool multiSelectionEnabled;
  final bool emptySelectionAllowed;

  @override
  State<Selection<T>> createState() => _SelectionState<T>();
}

class _SelectionState<T> extends State<Selection<T>> {
  late Set<T> selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  void didUpdateWidget(Selection<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    // Callback

    void onSelectionChanged(newSelected) {
      setState(() {
        selected = newSelected;
      });
      widget.onMultiSelectionChanged?.call(newSelected);
    }

    return SegmentedButton(
      segments: widget.buttons,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      multiSelectionEnabled: widget.multiSelectionEnabled,
      emptySelectionAllowed: widget.emptySelectionAllowed,
      showSelectedIcon: false,
    );
  }
}
