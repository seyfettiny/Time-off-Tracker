import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/app/enums/user_type.dart';
import 'package:timeofftracker/app/extensions/toast_ext.dart';
import 'package:timeofftracker/models/user_model.dart';
import 'package:timeofftracker/services/firestore_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Ref _ref;

  AuthService(this._ref);

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signInWithEmail(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (error, stackTrace) {
      // TODO: Handle error message translation
      debugPrint(
          'Failed to sign in with email and password: $error $stackTrace');
      error.message.toString().showErrorToast();
      throw Exception('Failed to sign in with email and password');
    } on Exception catch (error, stackTrace) {
      debugPrint(
          'Failed to sign in with email and password: $error $stackTrace');
      error.toString().showErrorToast();
      throw Exception('Failed to sign in with email and password');
    }
  }

  Future<UserCredential> signUpWithEmail(
      {String? name, String? email, String? password}) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      await result.user!.updateDisplayName(name!);

      final firestoreService = _ref.read(firestoreServiceProvider);

      //TODO: How to decide if the user is manager or not?
      firestoreService.createUser(const UserModel(
        userType: UserType.employee,
        timeOffBalance: 24,
        timeOffRequestList: [], 
      ));

      return result;
    } on FirebaseAuthException catch (error, stackTrace) {
      debugPrint(
          'Failed to sign in with email and password: $error $stackTrace');
      error.message.toString().showErrorToast();
      throw Exception('Failed to sign up with email and password');
    } on Exception catch (error, stackTrace) {
      debugPrint(
          'Failed to sign up with email and password: $error $stackTrace');
      error.toString().showErrorToast();
      throw Exception('Failed to sign up with email and password');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return userCredential.user;
    } on FirebaseAuthException catch (error, stackTrace) {
      debugPrint('Failed to sign in with Google: $error $stackTrace');
      error.message.toString().showErrorToast();
      throw Exception('Failed to sign in with Google');
    } on Exception catch (error, stackTrace) {
      debugPrint('Failed to sign up with Google: $error $stackTrace');
      error.toString().showErrorToast();
      throw Exception('Failed to sign up with Google');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
