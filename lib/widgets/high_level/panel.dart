import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/opacity.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/low_level/elevated.dart';

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    this.color,
    this.padding = defaultPadding,
    this.scrollable = defaultScrollable,
    this.constraints,
    this.borderRadius,
    this.child,
  });

  static const defaultPadding = EdgeInsets.all(SpacingConsts.m);
  static const defaultScrollable = false;

  final Color? color;
  final EdgeInsets? padding;
  final bool scrollable;
  final BoxConstraints? constraints;
  final BorderRadius? borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = this.color ??
        theme.colorScheme.surfaceContainerLowest
            .withOpacity(OpacityConsts.high(context));

    final elevatedChild = switch (scrollable) {
      true => SingleChildScrollView(
          padding: padding,
          child: child,
        ),
      false => child,
    };

    return Elevated.high(
      color: color,
      padding: scrollable ? EdgeInsets.zero : padding,
      constraints: constraints,
      borderRadius: borderRadius,
      child: elevatedChild,
    );
  }
}
