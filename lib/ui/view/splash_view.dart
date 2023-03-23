import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  static const routeName = '/splashView';

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_icon.png',
              scale: 3,
            ),
            Image.asset(
              'assets/images/logo_pepteam.png',
              scale: 3,
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
