import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/widgets/high_level/background.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';

class BackgroundScaffold extends StatelessWidget {
  const BackgroundScaffold({
    super.key,
    this.background = defaultBackground,
    this.padding = defaultPadding,
    this.titleGutterButton = defaultTitleGutterBottom,
    this.backButton,
    this.child,
    this.title,
  });

  static const defaultBackground = true;
  static const defaultTitleGutterBottom = SpacingConsts.m;
  static const defaultPadding = EdgeInsets.all(SpacingConsts.m);

  final bool background;
  final EdgeInsetsGeometry padding;
  final double titleGutterButton;
  final bool? backButton;
  final String? title;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    Widget backgroundWidget(Widget child) {
      return background ? Background(child: child) : child;
    }

    void onBackClicked() {
      Navigator.of(context).pop();
    }

    final backButton = this.backButton ?? Navigator.of(context).canPop();

    return backgroundWidget(
      SafeArea(
        child: Padding(
          padding: padding,
          child: Column(
            children: [
              ...switch (title) {
                null => const [],
                String title => [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: titleGutterButton,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...(backButton
                              ? [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: SpacingConsts.s,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Clickable(
                                          onClicked: onBackClicked,
                                          child: const Icon(
                                              Icons.arrow_back_rounded),
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                              : const []),
                          Text(
                            title,
                            style: textTheme.titleLarge,
                          ),
                          ...(backButton ? const [Spacer()] : const []),
                        ],
                      ),
                    ),
                  ],
              },
              ...switch (child) {
                null => const [],
                Widget child => [
                    Expanded(
                      child: child,
                    ),
                  ],
              },
            ],
          ),
        ),
      ),
    );
  }
}
