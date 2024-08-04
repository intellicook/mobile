import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/opacity.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/theme.dart';
import 'package:intellicook_mobile/utils/extensions/text_span.dart';
import 'package:intellicook_mobile/widgets/low_level/elevated.dart';

class DragDropdown extends StatefulWidget {
  DragDropdown({
    super.key,
    required this.initialValue,
    required this.values,
    this.onChanged,
  });

  final String initialValue;
  final List<String> values;
  final ValueChanged<String>? onChanged;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  State<DragDropdown> createState() => _DragDropdownState();
}

class _DragDropdownState extends State<DragDropdown> {
  late int index;
  late bool isDragging;

  @override
  void initState() {
    super.initState();
    index = widget.values.indexOf(widget.initialValue);
    isDragging = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const animationDuration = Duration(milliseconds: 300);
    const insertCurve = Curves.easeIn;
    const removeCurve = Curves.easeOut;
    const horizontalPadding = SpacingConsts.l;

    // Width
    final width = widget.values
        .map((value) =>
            TextSpan(
              text: value,
              style: theme.textTheme.bodyLarge,
            ).size(context).width +
            horizontalPadding * 2)
        .reduce((a, b) => a > b ? a : b);

    // Functions

    void setNewValue(Offset position) {
      final columnRenderObject =
          widget._listKey.currentContext?.findRenderObject() as RenderBox?;
      if (widget._listKey.currentContext?.size == null ||
          columnRenderObject == null) {
        return;
      }

      final normY = position.dy / columnRenderObject.size.height;
      final newIndex = (normY * widget.values.length)
          .clamp(0, widget.values.length - 1)
          .floor();

      if (index != newIndex) {
        setState(() {
          index = newIndex;
        });
      }
    }

    Widget itemBuilder(
      BuildContext context,
      int index,
      Animation<double> animation,
    ) {
      return SizeTransition(
        sizeFactor: animation.drive(
          CurveTween(curve: isDragging ? insertCurve : removeCurve),
        ),
        child: SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: SmoothBorderRadiusConsts.s,
              border: this.index == index && isDragging
                  ? Border.all(
                      color: IntelliCookTheme.primaryColor,
                      width: 1.5,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: SpacingConsts.ms,
                horizontal: horizontalPadding,
              ),
              child: Text(
                widget.values[index],
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      );
    }

    void setIsDragging(bool value) {
      if (isDragging == value) {
        return;
      }

      setState(() {
        isDragging = value;
      });

      if (!value) {
        widget.onChanged?.call(widget.values[index]);
        for (final index
            in List.generate(widget.values.length, (index) => index)
                .where((index) => index != this.index)
                .toList()
                .reversed) {
          widget._listKey.currentState?.removeItem(
            index,
            (context, animation) => itemBuilder(context, index, animation),
            duration: animationDuration,
          );
        }
      } else {
        for (final index
            in List.generate(widget.values.length, (index) => index)
                .where((index) => index != this.index)
                .toList()) {
          widget._listKey.currentState?.insertItem(
            index,
            duration: animationDuration,
          );
        }
      }
    }

    return GestureDetector(
      onVerticalDragUpdate: (_) {},
      child: SizedBox(
        width: width,
        child: Elevated.low(
          backgroundBlurred: true,
          padding: EdgeInsets.zero,
          color: theme.colorScheme.surfaceContainerLowest
              .withOpacity(OpacityConsts.low(context)),
          animatedElevatedArgs: AnimatedElevatedArgs(
            duration: animationDuration,
            curve: isDragging ? insertCurve : removeCurve,
          ),
          child: Listener(
            onPointerMove: (event) {
              setNewValue(event.localPosition);
            },
            onPointerUp: (event) {
              setIsDragging(false);
            },
            onPointerDown: (event) {
              setIsDragging(true);
              setNewValue(Offset.zero);
            },
            child: AnimatedList(
              key: widget._listKey,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              initialItemCount: 1,
              itemBuilder: (context, index, animation) {
                index = switch (isDragging) {
                  true => index,
                  false => this.index,
                };

                return itemBuilder(context, index, animation);
              },
            ),
          ),
        ),
      ),
    );
  }
}
