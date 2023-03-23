import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeofftracker/ui/view/home_view.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  static const routeName = '/errorView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.go(HomeView.routeName);
        },
        child: const Center(
          child: Text('Something went wrong'),
        ),
      ),
    );
  }
}
