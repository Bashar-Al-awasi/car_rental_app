import 'package:flutter/material.dart';
import 'package:flutter_coursess/l10n/app_localizations.dart';
import 'package:flutter_coursess/screens/favorites/favorites_screen.dart';
import 'package:flutter_coursess/screens/home/home_screen.dart';
import 'package:flutter_coursess/screens/profile/profile_screen.dart';

class CustomerNavigation extends StatefulWidget {
  const CustomerNavigation({super.key});

  @override
  State<CustomerNavigation> createState() => _CustomerNavigationState();
}

class _CustomerNavigationState extends State<CustomerNavigation> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    FavoritesScreen(),
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
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: AppLocalizations.of(context).translate('home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline_rounded),
            selectedIcon: const Icon(Icons.favorite_rounded),
            label: AppLocalizations.of(context).translate('favorites'),
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
