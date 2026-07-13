import 'package:flutter/material.dart';
import 'package:flutter_coursess/core/auth/auth_notifier.dart';
import 'package:flutter_coursess/core/theme/theme_notifier.dart';
import 'package:flutter_coursess/screens/auth/login_screen.dart';
import 'package:flutter_coursess/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('my_account'), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Avatar Banner
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 54,
                        backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=300",
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    AuthNotifier.instance.currentUser?.name ?? 'Guest User',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AuthNotifier.instance.currentUser?.email ?? 'no-email@unknown.com',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Profile Settings List
            Text(AppLocalizations.of(context).translate('preferences'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: Colors.grey)),
            const SizedBox(height: 10),
            
            // Theme Mode Toggle
            Card(
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (context, currentMode, _) {
                  final isCurrentlyDark = currentMode == ThemeMode.dark;
                  return SwitchListTile(
                    secondary: Icon(
                      isCurrentlyDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(AppLocalizations.of(context).translate('dark_theme_mode'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      isCurrentlyDark ? AppLocalizations.of(context).translate('currently_dark') : AppLocalizations.of(context).translate('currently_light'),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    value: isCurrentlyDark,
                    onChanged: (val) {
                      themeNotifier.toggleTheme();
                    },
                    activeColor: theme.colorScheme.primary,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            Text(AppLocalizations.of(context).translate('settings'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: Colors.grey)),
            const SizedBox(height: 10),
            
            _buildProfileTile(context, AppLocalizations.of(context).translate('payment_methods'), AppLocalizations.of(context).translate('payment_methods_sub'), Icons.credit_card_rounded),
            _buildProfileTile(context, AppLocalizations.of(context).translate('my_rental_trips'), AppLocalizations.of(context).translate('my_rental_trips_sub'), Icons.car_rental_rounded),
            _buildProfileTile(context, AppLocalizations.of(context).translate('notifications'), AppLocalizations.of(context).translate('notifications_sub'), Icons.notifications_none_rounded),
            _buildProfileTile(context, AppLocalizations.of(context).translate('privacy_support'), AppLocalizations.of(context).translate('privacy_support_sub'), Icons.shield_outlined),
            
            const SizedBox(height: 28),
            
            // Logout Button
            Card(
              color: isDark ? const Color(0x1AFF5959) : const Color(0xFFFFECEC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark ? const Color(0x33FF5959) : const Color(0xFFFFD1D1),
                  width: 1,
                ),
              ),
              child: ListTile(
                onTap: () {
                  _showLogoutConfirmation(context);
                },
                leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: Text(
                  AppLocalizations.of(context).translate('log_out'),
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                trailing: const Icon(Icons.chevron_right_rounded, color: Colors.redAccent),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(BuildContext context, String title, String subtitle, IconData icon) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: () {},
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('log_out'), style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(AppLocalizations.of(context).translate('logout_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.of(context).translate('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: Text(AppLocalizations.of(context).translate('log_out'), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
