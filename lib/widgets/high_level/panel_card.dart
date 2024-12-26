import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/opacity.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/low_level/elevated.dart';

class PanelCard extends StatelessWidget {
  const PanelCard({
    super.key,
    this.border,
    this.color,
    this.padding = defaultPadding,
    this.scrollable = defaultScrollable,
    this.isHigh = defaultIsHigh,
    this.constraints,
    this.child,
  });

  const PanelCard.high({
    super.key,
    this.border,
    this.color,
    this.padding = defaultPadding,
    this.scrollable = defaultScrollable,
    this.isHigh = true,
    this.constraints,
    this.child,
  });

  const PanelCard.low({
    super.key,
    this.border,
    this.color,
    this.padding = defaultPadding,
    this.scrollable = defaultScrollable,
    this.isHigh = false,
    this.constraints,
    this.child,
  });

  static const defaultPadding = EdgeInsets.all(SpacingConsts.xs);
  static const defaultScrollable = false;
  static const defaultIsHigh = false;

  final Border? border;
  final Color? color;
  final EdgeInsets? padding;
  final bool scrollable;
  final bool isHigh;
  final BoxConstraints? constraints;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = this.color ??
        theme.colorScheme.surfaceContainerLowest
            .withOpacity(OpacityConsts.low(context));

    final elevatedChild = switch (scrollable) {
      true => SingleChildScrollView(
          padding: padding,
          child: child,
        ),
      false => child,
    };

    final panel = switch (isHigh) {
      true => Elevated.high,
      false => Elevated.low,
    };

    return panel(
      border: border,
      color: color,
      padding: scrollable ? EdgeInsets.zero : padding,
      constraints: constraints,
      child: elevatedChild,
    );
  }
}
