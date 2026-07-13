import 'package:flutter/material.dart';
import 'package:flutter_coursess/core/auth/firebase_auth_service.dart';
import 'package:flutter_coursess/models/app_user.dart';

class AuthNotifier extends ValueNotifier<AppUser?> {
  AuthNotifier._internal() : super(null);

  static final AuthNotifier instance = AuthNotifier._internal();

  AppUser? get currentUser => value;
  bool get isSignedIn => value != null;

  Future<void> refreshCurrentUser() async {
    value = await FirebaseAuthService.instance.loadCurrentUser();
    notifyListeners();
  }

  Future<AppUser?> signIn(String email, String password) async {
    final user = await FirebaseAuthService.instance.signIn(email, password);
    value = user;
    notifyListeners();
    return user;
  }

  Future<AppUser?> signUp(String name, String email, String password, {String role = 'customer'}) async {
    final user = await FirebaseAuthService.instance.signUp(name, email, password, role: role);
    value = user;
    notifyListeners();
    return user;
  }

  Future<void> signOut() async {
    await FirebaseAuthService.instance.signOut();
    value = null;
    notifyListeners();
  }
}
