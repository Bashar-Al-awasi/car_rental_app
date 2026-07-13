import 'package:flutter/material.dart';
import 'package:flutter_coursess/core/auth/auth_notifier.dart';
import 'package:flutter_coursess/core/constants/app_colors.dart';
import 'package:flutter_coursess/core/widgets/custom_button.dart';
import 'package:flutter_coursess/core/widgets/custom_textfield.dart';
// removed unused imports: flutter_animate, glass_container
import 'package:flutter_coursess/screens/auth/register_screen.dart';
import 'package:flutter_coursess/screens/navigation/admin_navigation.dart';
import 'package:flutter_coursess/screens/navigation/customer_navigation.dart';
import 'package:flutter_coursess/screens/navigation/owner_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final email = _usernameController.text.trim();
        final password = _passwordController.text.trim();
        final user = await AuthNotifier.instance.signIn(email, password);
        if (user != null && mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => user.isAdmin
                  ? const AdminNavigation()
                  : user.isOwner
                      ? const OwnerNavigation()
                      : const CustomerNavigation(),
            ),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(isDark ? 0.15 : 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(isDark ? 0.1 : 0.08),
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.directions_car_filled_outlined, color: Colors.white, size: 36),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Welcome back",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Sign in to continue to Drive Premium",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Styled pastel card
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black12, blurRadius: 18, offset: Offset(0, 8)),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // inner white fields
                                      Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: _usernameController,
                                              validator: (val) {
                                                if (val == null || val.trim().isEmpty) return 'Please enter your email';
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Email',
                                                prefixIcon: const Icon(Icons.mail_outline),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextFormField(
                                              controller: _passwordController,
                                              obscureText: _obscurePassword,
                                              validator: (val) {
                                                if (val == null || val.isEmpty) return 'Please enter your password';
                                                if (val.length < 4) return 'Password is too short';
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Password',
                                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                                suffixIcon: IconButton(
                                                  icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {},
                                          child: Text('Forgot password?', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      const SizedBox(height: 6),

                                      // Big Sign In button
                                      Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF6366F1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                          borderRadius: BorderRadius.circular(28),
                                          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.28), blurRadius: 18, offset: const Offset(0, 8))],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(28),
                                            onTap: _isLoading ? null : _handleLogin,
                                            child: Center(
                                              child: _isLoading
                                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                                  : const Text('Sign In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      // Google continue outlined
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(color: AppColors.lightBorder),
                                        ),
                                        child: TextButton(
                                          onPressed: () {},
                                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.login, color: AppColors.primary),
                                              const SizedBox(width: 12),
                                              Text('Continue with Google', style: TextStyle(color: AppColors.lightTextPrimary)),
                                              const SizedBox(width: 8),
                                              Icon(Icons.arrow_forward, color: AppColors.primary, size: 18),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 6,
                                children: [
                                  Text('Don\'t have an account?', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
                                    child: Text('Create account', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
