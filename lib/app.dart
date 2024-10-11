import 'package:flutter/material.dart';
import 'package:intellicook_mobile/globals/auth.dart';
import 'package:intellicook_mobile/screens/nested/login_screen.dart';
import 'package:intellicook_mobile/widgets/high_level/background.dart';
import 'package:intellicook_mobile/widgets/high_level/nav_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/screen_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (accessToken == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: LoginScreen(),
            ),
          ),
        );
      }
    });

    return const Scaffold(
      body: Background(child: ScreenRouter()),
      bottomNavigationBar: NavBar(),
    );
  }
}
