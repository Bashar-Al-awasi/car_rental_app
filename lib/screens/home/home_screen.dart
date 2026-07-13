import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_coursess/core/constants/app_colors.dart';
import 'package:flutter_coursess/core/constants/global_state.dart';
import 'package:flutter_coursess/core/widgets/car_card.dart';
import 'package:flutter_coursess/models/car.dart';
import 'package:flutter_coursess/screens/details/car_details_screen.dart';
import 'package:flutter_coursess/core/theme/theme_notifier.dart';
import 'package:flutter_coursess/l10n/app_localizations.dart';
import 'package:flutter_coursess/core/localization/locale_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _pageController = PageController(initialPage: 0, viewportFraction: 0.85);
  int _carouselIndex = 0;
  Timer? _carouselTimer;
  static const String _allBrandValue = 'All';
  String _selectedBrand = _allBrandValue;
  String _searchQuery = "";

  final List<String> _brands = [_allBrandValue, "Honda", "Toyota", "Tesla", "Chevrolet", "Land Rover", "Ferrari"];

  // Default ads image fallbacks in case Firestore collection is empty
  final List<String> _defaultAds = [
    "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&q=80&w=800",
    "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&q=80&w=800",
    "https://images.unsplash.com/photo-1617788138017-80ad40651399?auto=format&fit=crop&q=80&w=800",
  ];

  @override
  void initState() {
    super.initState();
    _startCarouselTimer();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _startCarouselTimer() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _carouselIndex + 1;
        // Assume carousel has 4 items or length from Firebase.
        // We'll bounce back to 0 if it exceeds.
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate('location'),
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context).translate('city_name'),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
          actions: [
          // Theme toggler directly in header
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: () {
              themeNotifier.toggleTheme();
            },
          ),
          // Language selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.language_rounded),
            onSelected: (value) async {
              if (value == 'ar') {
                await localeNotifier.setLocale(const Locale('ar'));
              } else {
                await localeNotifier.setLocale(const Locale('en'));
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'ar', child: Text('العربية')),
            ],
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=150",
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: globalState,
          builder: (context, _) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Car type").snapshots(),
            builder: (context, snapshot) {
              List<Car> firebaseCars = [];
              if (snapshot.hasData && snapshot.data != null) {
                firebaseCars = snapshot.data!.docs.map((doc) => Car.fromFirestore(doc)).toList();
              }

              // Merge Firestore cars with local in-memory cars (filtering duplicates by model/id)
              final Map<String, Car> mergedCarsMap = {};
              // Add fallback mock cars first
              for (var car in globalState.cars) {
                mergedCarsMap[car.id] = car;
              }
              // Overwrite or append firebase cars
              for (var car in firebaseCars) {
                mergedCarsMap[car.id] = car;
              }
              
              final allCars = mergedCarsMap.values.toList();

              // Filter cars by brand & search query
              final filteredCars = allCars.where((car) {
                final matchBrand = _selectedBrand == "All" || car.brand.toLowerCase() == _selectedBrand.toLowerCase();
                final matchSearch = car.model.toLowerCase().contains(_searchQuery) || car.brand.toLowerCase().contains(_searchQuery);
                return matchBrand && matchSearch;
              }).toList();

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Greeting Text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).translate('welcome_back'),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context).translate('find_ride'),
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade(duration: 400.ms).slideX(begin: -0.1),
                      const SizedBox(height: 20),

                      // Search bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).translate('search_hint'),
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded),
                                    onPressed: () => _searchController.clear(),
                                  )
                                : const Icon(Icons.tune_rounded),
                          ),
                        ),
                      ).animate().fade(delay: 100.ms),
                      const SizedBox(height: 24),

                      // Horizontal Banner Ads (Firebase stream "car ads" or defaults)
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("car ads").snapshots(),
                        builder: (context, adsSnapshot) {
                          List<String> adsImages = [];
                          if (adsSnapshot.hasData && adsSnapshot.data != null && adsSnapshot.data!.docs.isNotEmpty) {
                            adsImages = adsSnapshot.data!.docs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return (data['Image'] ?? data['image'] ?? '').toString();
                            }).where((url) => url.isNotEmpty).toList();
                          }
                          
                          if (adsImages.isEmpty) {
                            adsImages = _defaultAds;
                          }

                          return SizedBox(
                            height: 180,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _carouselIndex = index % adsImages.length;
                                });
                              },
                              itemBuilder: (context, index) {
                                final realIndex = index % adsImages.length;
                                return AnimatedBuilder(
                                  animation: _pageController,
                                  builder: (context, child) {
                                    double value = 1.0;
                                    if (_pageController.position.haveDimensions) {
                                      value = _pageController.page! - index;
                                      value = (1 - (value.abs() * 0.15)).clamp(0.0, 1.0);
                                    }
                                    return Center(
                                      child: SizedBox(
                                        height: Curves.easeOut.transform(value) * 180,
                                        width: Curves.easeOut.transform(value) * 380,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        )
                                      ],
                                      image: DecorationImage(
                                        image: NetworkImage(adsImages[realIndex]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.6),
                                            Colors.transparent,
                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context).translate('summer_sale'),
                                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            AppLocalizations.of(context).translate('weekly_rentals_offer'),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ).animate().fade(delay: 200.ms),
                      const SizedBox(height: 12),
                      
                      // Carousel dots indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _carouselIndex == index ? 16 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _carouselIndex == index
                                  ? theme.colorScheme.primary
                                  : (isDark ? Colors.grey[700] : Colors.grey[300]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Brand Chips header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context).translate('popular_brands'),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedBrand = _allBrandValue;
                                });
                              },
                              child: Text(AppLocalizations.of(context).translate('clear')),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Brands scrollable chips list
                      SizedBox(
                        height: 48,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _brands.length,
                          itemBuilder: (context, index) {
                            final brand = _brands[index];
                            final isSelected = _selectedBrand == brand;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: FilterChip(
                                label: Text(
                              brand == _allBrandValue
                                  ? AppLocalizations.of(context).translate('all')
                                  : brand,
                            ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedBrand = brand;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                showCheckmark: false,
                                selectedColor: theme.colorScheme.primary,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.transparent
                                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                ),
                              ),
                            );
                          },
                        ),
                      ).animate().fade(delay: 250.ms),
                      const SizedBox(height: 20),

                      // Grid cars list
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${AppLocalizations.of(context).translate('available_cars')} (${filteredCars.length})",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (filteredCars.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                Icon(Icons.car_crash_outlined, size: 60, color: theme.colorScheme.primary.withOpacity(0.5)),
                                const SizedBox(height: 12),
                                Text(
                                  AppLocalizations.of(context).translate('no_cars_found'),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context).translate('no_cars_sub'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.64,
                          ),
                          itemCount: filteredCars.length,
                          itemBuilder: (context, index) {
                            final car = filteredCars[index];
                            return CarCard(
                              car: car,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CarDetailsScreen(car: car),
                                  ),
                                );
                              },
                              onFavoriteToggle: () {
                                globalState.toggleFavorite(car);
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          );
          },
        ),
      ),
    );
  }
}
