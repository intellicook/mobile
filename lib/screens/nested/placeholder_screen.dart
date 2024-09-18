import 'package:flutter/material.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BackgroundScaffold(
      child: Center(
        child: Text('Placeholder Screen'),
      ),
    );
  }
}
