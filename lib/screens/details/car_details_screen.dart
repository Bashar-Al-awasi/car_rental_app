import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_coursess/core/constants/app_colors.dart';
import 'package:flutter_coursess/core/constants/global_state.dart';
import 'package:flutter_coursess/core/widgets/custom_button.dart';
import 'package:flutter_coursess/core/widgets/glass_container.dart';
import 'package:flutter_coursess/models/car.dart';
import 'package:flutter_coursess/screens/booking/booking_screen.dart';
import 'package:flutter_coursess/l10n/app_localizations.dart';

class CarDetailsScreen extends StatefulWidget {
  final Car car;

  const CarDetailsScreen({super.key, required this.car});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  int _selectedDurationIndex = 0;
  late bool _isFavorite;

  // Rental options list
  // Rental options list (labels/descriptions localized at build time)
  final List<Map<String, dynamic>> _rentalPeriods = [
    {"key": "daily", "multiplier": 1.0, "descKey": "daily_desc"},
    {"key": "weekly", "multiplier": 0.85, "descKey": "weekly_desc"},
    {"key": "monthly", "multiplier": 0.70, "descKey": "monthly_desc"},
  ];

  @override
  void initState() {
    _isFavorite = widget.car.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Calculate rates dynamically based on the base price
    final double basePrice = widget.car.price;
    final List<double> calculatedPrices = [
      basePrice, // Daily rate
      basePrice * 6, // Weekly (approx 6x daily due to 15% discount)
      basePrice * 21, // Monthly (approx 21x daily due to 30% discount)
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background Color / Gradients
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark 
                      ? [AppColors.darkSurface, AppColors.darkBackground] 
                      : [AppColors.primaryLight, AppColors.lightBackground],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Custom Header Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: GlassContainer(
                          borderRadius: 12,
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).translate('details'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFavorite = !_isFavorite;
                                widget.car.isFavorite = _isFavorite;
                                globalState.toggleFavorite(widget.car);
                              });
                            },
                            child: GlassContainer(
                              borderRadius: 12,
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                _isFavorite ? Icons.favorite : Icons.favorite_border,
                                size: 20,
                                color: _isFavorite ? Colors.red : (isDark ? Colors.white : AppColors.lightTextPrimary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context).translate('link_copied')),
                                ),
                              );
                            },
                            child: GlassContainer(
                              borderRadius: 12,
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.share_outlined,
                                size: 20,
                                color: isDark ? Colors.white : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Hero Image Slider / Asset
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Car Identity
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.car.brand.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: theme.colorScheme.primary,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.car.model,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkBorder : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark ? Colors.white10 : AppColors.lightBorder,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: AppColors.ratingStar, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.car.rating.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).animate().fade().slideY(begin: 0.1),
                        const SizedBox(height: 12),
                        
                        // Listed by shop info
                        Row(
                          children: [
                            Icon(Icons.storefront_rounded, size: 16, color: theme.colorScheme.primary),
                            const SizedBox(width: 6),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('listed_by')
                                  .replaceFirst('{shop}', widget.car.shopName),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                        
                        // Big Center Car Display
                        Center(
                          child: Container(
                            height: 200,
                            margin: const EdgeInsets.symmetric(vertical: 24),
                            child: Hero(
                              tag: 'car-img-${widget.car.id}',
                              child: widget.car.images[0].startsWith('http')
                                  ? Image.network(
                                      widget.car.images[0],
                                      fit: BoxFit.scaleDown,
                                    )
                                  : Image.asset(
                                      widget.car.images[0],
                                      fit: BoxFit.scaleDown,
                                    ),
                            ),
                          ),
                        ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                        
                        // Specifications Section
                        Text(
                          AppLocalizations.of(context).translate('specifications'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Specs scroll view
                        SizedBox(
                          height: 110,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _buildSpecCard(AppLocalizations.of(context).translate('transmission'), widget.car.transmission, Icons.settings_input_component_rounded),
                              _buildSpecCard(AppLocalizations.of(context).translate('power_output'), widget.car.engine, Icons.offline_bolt_rounded),
                              _buildSpecCard(AppLocalizations.of(context).translate('fuel_type'), widget.car.fuel, Icons.local_gas_station_rounded),
                              _buildSpecCard(AppLocalizations.of(context).translate('seats_cap'), '${widget.car.seats} ${AppLocalizations.of(context).translate('adults')}', Icons.airline_seat_recline_extra_rounded),
                              _buildSpecCard(AppLocalizations.of(context).translate('performance'), widget.car.speed, Icons.speed_rounded),
                            ],
                          ),
                        ).animate().fade(delay: 200.ms),
                        
                        const SizedBox(height: 28),
                        
                        // Rental Price Selection
                        Text(
                          AppLocalizations.of(context).translate('rental_plans'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        Row(
                          children: List.generate(3, (index) {
                            final period = _rentalPeriods[index];
                            final isSelected = _selectedDurationIndex == index;
                            
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDurationIndex = index;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                                  child: Column(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context).translate(period["key"]),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "\$${calculatedPrices[index].toStringAsFixed(0)}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              color: isSelected ? Colors.white : theme.colorScheme.primary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            AppLocalizations.of(context).translate(period["descKey"]),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: isSelected ? Colors.white60 : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                ),
                              ),
                            );
                          }),
                        ).animate().fade(delay: 350.ms),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                
                // Bottom Rent action bar
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('total_estimated'),
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "\$${calculatedPrices[_selectedDurationIndex].toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      CustomButton(
                        text: AppLocalizations.of(context).translate('book_now'),
                        width: 180,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(
                                car: widget.car,
                                defaultRate: calculatedPrices[_selectedDurationIndex] / 
                                  (_selectedDurationIndex == 0 ? 1 : _selectedDurationIndex == 1 ? 7 : 30),
                                defaultType: AppLocalizations.of(context).translate(_rentalPeriods[_selectedDurationIndex]["key"]),
                                ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecCard(String title, String value, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
