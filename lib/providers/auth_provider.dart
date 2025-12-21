import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_note/firebase/auth_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
// ignore: deprecated_member_use_from_same_package
Stream<User?> authState(AuthStateRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}

@riverpod
class AuthAction extends _$AuthAction {
  late final AuthHelper _helper;

  @override
  void build() {
    _helper = AuthHelper();
  }

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _helper.signInWithEmailAndPassword(email, password);
  }

  Future<UserCredential> signUpWithEmail(String email, String password) {
    return _helper.signUpWithEmailAndPassword(email, password);
  }

  Future<UserCredential?> signInWithGoogle() {
    return _helper.signInWithGoogle();
  }

  Future<void> signOut() {
    return _helper.signOutWithGoogle();
  }
}
