import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/high_level/background.dart';

class BackgroundScaffold extends StatelessWidget {
  const BackgroundScaffold({
    super.key,
    this.padding = defaultPadding,
    this.child,
    this.title,
  });

  static const defaultPadding = EdgeInsets.all(SpacingConsts.m);

  final EdgeInsetsGeometry padding;
  final String? title;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: switch (title) {
          null => null,
          String title => Text(title),
        },
      ),
      body: Background(
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
