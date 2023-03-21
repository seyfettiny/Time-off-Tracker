import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  static const routeName = '/splashView';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Text(routeName);
  }
}
