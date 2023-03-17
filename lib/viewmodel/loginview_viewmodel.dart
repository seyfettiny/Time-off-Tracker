import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/services/auth_service.dart';

final loginViewVMProvider =
    StateNotifierProvider.autoDispose((ref) => LoginViewVM(ref));

class LoginViewVM extends StateNotifier<bool> {
  final Ref _ref;

  LoginViewVM(this._ref) : super(false);

  bool get isLoading => state;

  Future<User> signInWithEmail(String email, String password) async {
    try {
      state = true;
      final authService = _ref.read(authServiceProvider);
      final user =
          await authService.signInWithEmail(email: email, password: password);
      if (user != null) {
        return user;
      } else {
        throw Exception('Failed to sign in with email and password');
      }
    } finally {
      state = false;
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      state = true;
      final authService = _ref.read(authServiceProvider);
      final user = await authService.signInWithGoogle();
      if (user != null) {
        return user;
      } else {
        throw Exception('Failed to sign in with Google');
      }
    } finally {
      state = false;
    }
  }
}
