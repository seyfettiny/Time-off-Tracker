import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/ui/view/error_view.dart';
import 'package:timeofftracker/ui/view/home_view.dart';
import 'package:timeofftracker/ui/view/login_view.dart';
import 'package:timeofftracker/ui/view/result_view.dart';
import 'package:timeofftracker/ui/view/signup_view.dart';
import 'package:timeofftracker/ui/view/splash_view.dart';
import 'package:timeofftracker/ui/view/timeoff_request_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: SplashView.routeName,
    errorBuilder: (context, state) {
      debugPrint(state.error.toString());
      return const ErrorView();
    },
    routes: [
      GoRoute(
        path: SplashView.routeName,
        builder: (context, state) => const SplashView(),
        redirect: (context, state) {
          if (FirebaseAuth.instance.currentUser != null) {
            return HomeView.routeName;
          } else {
            return LoginView.routeName;
          }
        },
      ),
      GoRoute(
        path: HomeView.routeName,
        builder: (context, state) => HomeView(),
      ),
      GoRoute(
        path: LoginView.routeName,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: SignupView.routeName,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const SignupView(),
        ),
      ),
      GoRoute(
        path: TimeOffRequestView.routeName,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const TimeOffRequestView(),
        ),
      ),
      GoRoute(
        path: ResultView.routeName,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const ResultView(),
        ),
      ),
    ],
  );
});
