import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/services/auth_service.dart';

final signupViewVMProvider =
    StateNotifierProvider.autoDispose((ref) => SignupViewVM(ref));

class SignupViewVM extends StateNotifier<bool> {
  final Ref _ref;

  SignupViewVM(this._ref) : super(false);

  bool get isLoading => state;

  Future<UserCredential> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      state = true;
      final authService = _ref.read(authServiceProvider);
      final userCredential = await authService.signUpWithEmail(
        name: name,
        email: email,
        password: password,
      );
      return userCredential;
      
    } finally {
      state = false;
    }
  }

  Future<User> signUpWithGoogle() async {
    try {
      state = true;
      final authService = _ref.read(authServiceProvider);
      final user = await authService.signInWithGoogle();
      if (user != null) {
        return user;
      } else {
        throw Exception('Failed to sign up with Google');
      }
    } finally {
      state = false;
    }
  }
}
