import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/services/auth_service.dart';

final signupViewVMProvider =
    AsyncNotifierProvider<SignupViewVM, void>(SignupViewVM.new);

class SignupViewVM extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    final authService = ref.read(authServiceProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(authService.signUpWithEmail);
  }

  Future<void> signUpWithGoogle() async {
    final authService = ref.read(authServiceProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(authService.signInWithGoogle);
  }
}
