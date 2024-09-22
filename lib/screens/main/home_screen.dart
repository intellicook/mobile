import 'package:flutter/material.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BackgroundScaffold(
      background: false,
      title: 'Home',
      child: Panel(),
    );
  }
}
