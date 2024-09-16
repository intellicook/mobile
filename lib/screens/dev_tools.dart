import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/screens/app_controller_health_screen.dart';
import 'package:intellicook_mobile/screens/component_gallery.dart';
import 'package:intellicook_mobile/screens/login_screen.dart';
import 'package:intellicook_mobile/screens/register_screen.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class DevTools extends StatelessWidget {
  const DevTools({super.key});

  static const screens = [
    ('App Controller Health Screen', AppControllerHealthScreen()),
    ('Login Screen', LoginScreen()),
    ('Register Screen', RegisterScreen()),
    ('Component Gallery', ComponentGallery()),
  ];

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      title: 'Dev Tools',
      child: Panel(
        child: ListView.separated(
          itemBuilder: (context, index) {
            final screen = screens[index];

            return LabelButton(
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
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: SpacingConsts.m,
          ),
          itemCount: screens.length,
        ),
      ),
    );
  }
}
