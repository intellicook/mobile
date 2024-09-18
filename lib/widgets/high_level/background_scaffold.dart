import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/high_level/background.dart';

class BackgroundScaffold extends StatelessWidget {
  const BackgroundScaffold({
    super.key,
    this.background = defaultBackground,
    this.padding = defaultPadding,
    this.child,
    this.title,
  });

  static const defaultBackground = true;
  static const defaultPadding = EdgeInsets.all(SpacingConsts.m);

  final bool background;
  final EdgeInsetsGeometry padding;
  final String? title;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    Widget backgroundWidget(Widget child) {
      return background ? Background(child: child) : child;
    }

    return backgroundWidget(
      SafeArea(
        child: Padding(
          padding: padding,
          child: Column(
            children: [
              switch (title) {
                null => const SizedBox(),
                String title => Padding(
                    padding: const EdgeInsets.only(
                      bottom: SpacingConsts.s,
                    ),
                    child: Text(
                      title,
                      style: textTheme.titleLarge,
                    ),
                  ),
              },
              switch (child) {
                null => const SizedBox(),
                Widget child => Expanded(
                    child: child,
                  ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
