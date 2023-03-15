import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/services/auth_service.dart';
import 'package:timeofftracker/ui/view/login_view.dart';

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
        actions: [
          GestureDetector(
            onTap: () {
              ref.read(authServiceProvider).signOut().then((value) {
                context.go(LoginView.routeName);
              });
            },
            child: Image.asset(
              'assets/images/profile_picture.png',
              scale: 2,
            ),
          ),
        ],
      ),
      body: Center(child: Text(routeName)),
    );
  }
}
