import 'package:flutter/material.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    this.background = defaultBackground,
    this.title = defaultTitle,
  });

  static const defaultBackground = true;
  static const defaultTitle = 'Placeholder Screen';

  final bool background;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return BackgroundScaffold(
      background: background,
      child: Center(
        child: Text(
          title,
          style: textTheme.titleLarge,
        ),
      ),
    );
  }
}
