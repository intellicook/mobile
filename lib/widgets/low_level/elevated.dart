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

  static const defaultDuration = Duration(milliseconds: 100);
  static const defaultCurve = Curves.easeInOut;

  final Duration duration;
  final Curve curve;
}

class Elevated extends StatelessWidget {
  const Elevated({
    super.key,
    this.border,
    this.borderRadius,
    this.shadows,
    this.padding = defaultPadding,
    this.color,
    this.constraints,
    this.clipBehavior = defaultClipBehavior,
    this.animatedElevatedArgs,
    this.child,
  });

  Elevated.low({
    super.key,
    this.border,
    this.padding = defaultPadding,
    this.color,
    this.constraints,
    this.clipBehavior = defaultClipBehavior,
    this.animatedElevatedArgs,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
    bool insetShadow = defaultInsetShadow,
    this.child,
  })  : borderRadius = borderRadius ?? lowBorderRadius,
        shadows = shadows ?? lowShadows(inset: insetShadow);

  Elevated.high({
    super.key,
    this.border,
    this.padding = defaultPadding,
    this.color,
    this.constraints,
    this.clipBehavior = defaultClipBehavior,
    this.animatedElevatedArgs,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
    bool insetShadow = defaultInsetShadow,
    this.child,
  })  : borderRadius = borderRadius ?? highBorderRadius,
        shadows = shadows ?? highShadows(inset: insetShadow);

  static const defaultPadding = EdgeInsets.all(SpacingConsts.m);
  static const defaultInsetShadow = false;
  static const defaultClipBehavior = Clip.antiAlias;
  static const lowShadows = ShadowConsts.low;
  static const highShadows = ShadowConsts.high;
  static final lowBorderRadius = SmoothBorderRadiusConsts.s;
  static final highBorderRadius = SmoothBorderRadiusConsts.l;

  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;
  final EdgeInsets? padding;
  final Color? color;
  final BoxConstraints? constraints;
  final Clip clipBehavior;
  final AnimatedElevatedArgs? animatedElevatedArgs;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      color: color,
      border: border,
      borderRadius: borderRadius,
      boxShadow: shadows,
    );

    final container = switch (animatedElevatedArgs) {
      null => (Widget? child) => Container(
            clipBehavior: clipBehavior,
            decoration: boxDecoration,
            constraints: constraints,
            padding: padding,
            child: child,
          ),
      var args => (Widget? child) => AnimatedContainer(
            duration: args.duration,
            curve: args.curve,
            clipBehavior: clipBehavior,
            decoration: boxDecoration,
            constraints: constraints,
            padding: padding,
            child: child,
          ),
    };

    return container(child);
  }
}
