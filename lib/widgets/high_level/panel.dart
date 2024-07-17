import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/low_level/elevated.dart';

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    this.color,
    this.padding = defaultPadding,
    this.constraints,
    this.child,
  });

  static const defaultPadding = EdgeInsets.all(SpacingConsts.m);
  static const opacity = 0.5;

  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = this.color ??
        theme.colorScheme.surfaceContainerLowest.withOpacity(opacity);

    return Elevated.high(
      color: color,
      padding: padding,
      constraints: constraints,
      child: child,
    );
  }
}
