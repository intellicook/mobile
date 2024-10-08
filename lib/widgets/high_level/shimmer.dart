import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;

class Shimmer extends StatelessWidget {
  const Shimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return shimmer.Shimmer.fromColors(
      baseColor: theme.colorScheme.onSurface.withOpacity(0.1),
      highlightColor: theme.colorScheme.onSurface.withOpacity(0.2),
      child: child,
    );
  }
}
