import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:intellicook_mobile/screens/nested/app_controller_health_screen.dart';
import 'package:intellicook_mobile/screens/nested/component_gallery.dart';
import 'package:intellicook_mobile/screens/nested/login_screen.dart';
import 'package:intellicook_mobile/screens/nested/register_screen.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class DevTools extends ConsumerWidget {
  const DevTools({super.key});

  static const screens = [
    ('App Controller Health Screen', AppControllerHealthScreen()),
    ('Login Screen', LoginScreen()),
    ('Register Screen', RegisterScreen()),
    ('Component Gallery', ComponentGallery()),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(appControllerProvider).isAuthenticated;

    return BackgroundScaffold(
      background: false,
      title: 'Dev Tools',
      child: Panel(
        child: ListView(
          children: [
            ...screens.expand(
              (screen) => [
                LabelButton(
                  label: screen.$1,
                  type: LabelButtonType.secondary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          body: screen.$2,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: SpacingConsts.m),
              ],
            ),
            ...switch (isAuthenticated) {
              false => [],
              _ => [
                  const Divider(),
                  const SizedBox(height: SpacingConsts.m),
                  LabelButton(
                    label: 'Logout',
                    type: LabelButtonType.primary,
                    onPressed: () {
                      ref
                          .read(appControllerProvider.notifier)
                          .setAccessToken(null);
                    },
                  ),
                ],
            }
          ],
        ),
      ),
    );
  }
}
