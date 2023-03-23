import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:timeofftracker/ui/view/home_view.dart';
import 'package:timeofftracker/ui/widgets/custom_button.dart';

class ResultView extends ConsumerWidget {
  const ResultView({super.key});

  static const routeName = '/resultView';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox.square(
                dimension: MediaQuery.of(context).size.width,
                child: const RiveAnimation.asset('assets/rive/done.riv'),
              ),
              const Text(
                'İzin Talebiniz Başarıyla Oluşturuldu',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff5A67F6),
                    fontWeight: FontWeight.bold),
              ),
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
