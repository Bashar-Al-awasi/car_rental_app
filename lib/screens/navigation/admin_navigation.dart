import 'package:flutter/material.dart';
import 'package:flutter_coursess/l10n/app_localizations.dart';
import 'package:flutter_coursess/screens/admin/admin_panel_screen.dart';
import 'package:flutter_coursess/screens/profile/profile_screen.dart';
import 'package:flutter_coursess/screens/shop/shop_dashboard_screen.dart';

class AdminNavigation extends StatefulWidget {
  const AdminNavigation({super.key});

  @override
  State<AdminNavigation> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    AdminPanelScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: const Icon(Icons.admin_panel_settings_rounded),
            label: AppLocalizations.of(context).translate('admin_panel'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: AppLocalizations.of(context).translate('my_account'),
          ),
        ],
      ),
    );
  }
}
