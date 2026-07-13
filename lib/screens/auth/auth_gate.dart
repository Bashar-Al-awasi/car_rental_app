import 'package:flutter/material.dart';
import 'package:flutter_coursess/core/auth/auth_notifier.dart';
import 'package:flutter_coursess/screens/auth/login_screen.dart';
import 'package:flutter_coursess/screens/navigation/admin_navigation.dart';
import 'package:flutter_coursess/screens/navigation/customer_navigation.dart';
import 'package:flutter_coursess/screens/navigation/owner_navigation.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    AuthNotifier.instance.addListener(_onAuthChange);
    _initializeAuth();
  }

  @override
  void dispose() {
    AuthNotifier.instance.removeListener(_onAuthChange);
    super.dispose();
  }

  void _onAuthChange() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializeAuth() async {
    await AuthNotifier.instance.refreshCurrentUser();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = AuthNotifier.instance.currentUser;
    if (user == null) {
      return const LoginScreen();
    }

    if (user.isAdmin) {
      return const AdminNavigation();
    }

    if (user.isOwner) {
      return const OwnerNavigation();
    }

    return const CustomerNavigation();
  }
}
