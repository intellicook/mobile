import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:intellicook_mobile/constants/shadow.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius_consts.dart';
import 'package:intellicook_mobile/constants/spacing.dart';

class AnimatedElevatedArgs {
  const AnimatedElevatedArgs({
    this.duration = defaultDuration,
    this.curve = defaultCurve,
  });

  final Duration duration;
  final Curve curve;

  static const defaultDuration = Duration(milliseconds: 80);
  static const defaultCurve = Curves.easeOut;
}

class Elevated extends StatelessWidget {
  const Elevated({
    super.key,
    this.border,
    this.borderRadius,
    this.shadows,
    this.padding,
    this.color,
    this.constraints,
    this.animatedElevatedArgs,
    this.child,
  });

  Elevated.low({
    super.key,
    this.border,
    this.padding,
    this.color,
    this.constraints,
    this.animatedElevatedArgs,
    insetShadow = false,
    this.child,
  })  : borderRadius = SmoothBorderRadiusConsts.s,
        shadows = ShadowConsts.low(inset: insetShadow);

  Elevated.high({
    super.key,
    this.border,
    this.padding,
    this.color,
    this.constraints,
    this.animatedElevatedArgs,
    insetShadow = false,
    this.child,
  })  : borderRadius = SmoothBorderRadiusConsts.l,
        shadows = ShadowConsts.high(inset: insetShadow);

  final BoxBorder? border;
  final SmoothBorderRadius? borderRadius;
  final List<BoxShadow>? shadows;
  final EdgeInsets? padding;
  final Color? color;
  final BoxConstraints? constraints;
  final AnimatedElevatedArgs? animatedElevatedArgs;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = this.borderRadius ?? SmoothBorderRadiusConsts.l;
    final shadows = this.shadows ?? ShadowConsts.high();
    final padding = this.padding ?? const EdgeInsets.all(SpacingConsts.m);
    final color = this.color ?? theme.colorScheme.surfaceContainerLowest;

    if (animatedElevatedArgs != null) {
      return AnimatedContainer(
        duration: animatedElevatedArgs!.duration,
        curve: animatedElevatedArgs!.curve,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: color,
          border: border,
          borderRadius: borderRadius,
          boxShadow: shadows,
        ),
        constraints: constraints,
        padding: padding,
        child: child,
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color,
        border: border,
        borderRadius: borderRadius,
        boxShadow: shadows,
      ),
      constraints: constraints,
      padding: padding,
      child: child,
    );
  }
}
