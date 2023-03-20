import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/ui/view/home_view.dart';
import 'package:timeofftracker/ui/widgets/custom_button.dart';

class ResultView extends ConsumerWidget {
  const ResultView({super.key});

  static const routeName = '/resultView';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(routeName),
              CustomButton(
                  onPressed: () {
                    context.go(HomeView.routeName);
                  },
                  title: 'Anasayfaya Dön'),
            ],
          ),
        ),
      ),
    );
  }
}
