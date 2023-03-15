import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const routeName = '/homeView';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/images/logo_icon.png',
          scale: 8,
        ),
        title: Image.asset(
          'assets/images/logo_pepteam.png',
          scale: 3,
        ),
        titleSpacing: -10,
      ),
      body: Center(child: Text(routeName)),
    );
  }
}
