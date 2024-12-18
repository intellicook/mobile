import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:intellicook_mobile/screens/nested/login_screen.dart';
import 'package:intellicook_mobile/widgets/high_level/background.dart';
import 'package:intellicook_mobile/widgets/high_level/nav_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/screen_router.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appController = ref.read(appControllerProvider);
      if (!appController.isAuthenticated) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: LoginScreen(),
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appControllerProvider);

    return const Scaffold(
      body: Background(child: ScreenRouter()),
      bottomNavigationBar: NavBar(),
    );
  }
}
