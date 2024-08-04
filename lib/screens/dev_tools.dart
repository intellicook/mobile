import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/screens/app_controller_health_screen.dart';
import 'package:intellicook_mobile/screens/component_gallery.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class DevTools extends StatelessWidget {
  const DevTools({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      title: 'Dev Tools',
      child: Panel(
        child: ListView(
          children: [
            LabelButton(
              label: 'App Controller Health',
              type: LabelButtonType.secondary,
              onClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppControllerHealthScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: SpacingConsts.m),
            LabelButton(
              label: 'Component Gallery',
              type: LabelButtonType.secondary,
              onClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ComponentGallery(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
