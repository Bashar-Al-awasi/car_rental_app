import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_coursess/core/auth/auth_notifier.dart';
import 'package:flutter_coursess/core/constants/app_colors.dart';
import 'package:flutter_coursess/core/constants/global_state.dart';
import 'package:flutter_coursess/core/widgets/custom_button.dart';
import 'package:flutter_coursess/core/widgets/glass_container.dart';
import 'package:flutter_coursess/models/car.dart';
import 'package:flutter_coursess/models/shop.dart';
import 'package:flutter_coursess/screens/shop/add_edit_car_screen.dart';
import 'package:flutter_coursess/screens/shop/create_shop_screen.dart';
import 'package:flutter_coursess/l10n/app_localizations.dart';

class ShopDashboardScreen extends StatefulWidget {
  const ShopDashboardScreen({super.key});

  @override
  State<ShopDashboardScreen> createState() => _ShopDashboardScreenState();
}

class _ShopDashboardScreenState extends State<ShopDashboardScreen> {
  int _selectedShopIndex = 0;
  late List<Shop> _ownerShops;

  @override
  void initState() {
    super.initState();
    globalState.addListener(_onStateChange);
    _ownerShops = _loadOwnerShops();
  }

  @override
  void dispose() {
    globalState.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  List<Shop> _loadOwnerShops() {
    final currentUser = AuthNotifier.instance.currentUser;
    final ownedShopIds = currentUser?.ownedShopIds ?? [];
    if (ownedShopIds.isEmpty) {
      return [];
    }
    return localShopsList.where((shop) => ownedShopIds.contains(shop.id)).toList();
  }

  void _refreshOwnerShops() {
    setState(() {
      _ownerShops = _loadOwnerShops();
      if (_selectedShopIndex >= _ownerShops.length) {
        _selectedShopIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedShop = _ownerShops.isNotEmpty ? _ownerShops[_selectedShopIndex] : null;
    final shopCars = selectedShop == null
        ? []
        : globalState.cars.where((car) => car.shopId == selectedShop.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('shops_hub'), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (_ownerShops.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: () {
                _showInfoDialog(context);
              },
            ),
          IconButton(
            icon: const Icon(Icons.add_business_outlined),
            onPressed: () async {
              final createdShop = await Navigator.push<Shop>(
                context,
                MaterialPageRoute(builder: (_) => const CreateShopScreen()),
              );
              if (createdShop != null) {
                _refreshOwnerShops();
                setState(() {
                  _selectedShopIndex = _ownerShops.indexWhere((shop) => shop.id == createdShop.id);
                });
              }
            },
            tooltip: AppLocalizations.of(context).translate('create_new_shop'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Shop Brand Horizontal List selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                AppLocalizations.of(context).translate('select_car_rental_shop'),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _ownerShops.length,
                itemBuilder: (context, index) {
                  final shop = _ownerShops[index];
                  final isSelected = _selectedShopIndex == index;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedShopIndex = index;
                      });
                    },
                    child: Container(
                      width: 140,
                      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.primary 
                            : (isDark ? AppColors.darkSurface : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected 
                              ? Colors.transparent 
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? Colors.black26 : Colors.grey[100],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: shop.logo.startsWith('assets')
                                ? Image.asset(shop.logo, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.store, size: 16))
                                : Image.asset(shop.logo, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.store, size: 16)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shop.name.split(" ")[0],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: AppColors.ratingStar, size: 10),
                                    const SizedBox(width: 2),
                                    Text(
                                      shop.rating.toString(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white70 : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            if (selectedShop == null) ...[
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.storefront_outlined, size: 72, color: theme.colorScheme.primary.withOpacity(0.3)),
                        const SizedBox(height: 18),
                        Text(
                          AppLocalizations.of(context).translate('no_owned_shops'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context).translate('create_your_first_shop'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: AppLocalizations.of(context).translate('create_shop'),
                          width: 180,
                          height: 45,
                          onTap: () async {
                            final createdShop = await Navigator.push<Shop>(
                              context,
                              MaterialPageRoute(builder: (_) => const CreateShopScreen()),
                            );
                            if (createdShop != null) {
                              _refreshOwnerShops();
                              setState(() {
                                _selectedShopIndex = _ownerShops.indexWhere((shop) => shop.id == createdShop.id);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Shop summary Card details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedShop.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(selectedShop.address, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(selectedShop.phone, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            shopCars.length.toString(),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                          ),
                          Text(AppLocalizations.of(context).translate('cars_listed'), style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (selectedShop != null) ...[
              // Listed Cars Section header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('cars_by').replaceFirst('{shop}', selectedShop.name.split(" ")[0]),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditCarScreen(shop: selectedShop),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add_circle_outline_rounded, size: 18, color: theme.colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            AppLocalizations.of(context).translate('add_car'),
                            style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Scrollable listing details
              Expanded(
                child: shopCars.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_car_filled_outlined, size: 54, color: theme.colorScheme.primary.withOpacity(0.3)),
                            const SizedBox(height: 12),
                            Text(AppLocalizations.of(context).translate('no_cars_listed'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text(AppLocalizations.of(context).translate('list_your_first_car'), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: AppLocalizations.of(context).translate('list_new_car'),
                              width: 150,
                              height: 40,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEditCarScreen(shop: selectedShop),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: shopCars.length,
                        itemBuilder: (context, index) {
                          final car = shopCars[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                                    ),
                                    child: car.images[0].startsWith('http')
                                        ? Image.network(car.images[0], fit: BoxFit.contain)
                                        : Image.asset(car.images[0], fit: BoxFit.contain),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${car.brand} ${car.model}",
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "\$${car.price.toStringAsFixed(0)} / ${car.condition == 'Daily' ? AppLocalizations.of(context).translate('day') : car.condition == 'Weekly' ? AppLocalizations.of(context).translate('week') : AppLocalizations.of(context).translate('month')}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                    onPressed: () {
                                      _confirmDeleteListing(context, car);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).animate().fade(),
              ),
            ]
          ],
       ] ),
      ),
    );
  }

  void _confirmDeleteListing(BuildContext context, Car car) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('delete_listing'), style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(AppLocalizations.of(context).translate('delete_confirm').replaceFirst('{car}', '${car.brand} ${car.model}')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.of(context).translate('cancel')),
            ),
            TextButton(
              onPressed: () {
                globalState.removeCar(car.id);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context).translate('removed_from_listings').replaceFirst('{car}', '${car.brand} ${car.model}'))),
                );
              },
              child: Text(AppLocalizations.of(context).translate('delete'), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('multi_shop_system'), style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(AppLocalizations.of(context).translate('multi_shop_desc')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.of(context).translate('got_it')),
            ),
          ],
        );
      },
    );
  }
}
