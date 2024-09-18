import 'package:flutter/material.dart';
import 'package:intellicook_mobile/widgets/high_level/background.dart';
import 'package:intellicook_mobile/widgets/high_level/nav_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/screen_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Background(child: ScreenRouter()),
      bottomNavigationBar: NavBar(),
    );
  }
}
