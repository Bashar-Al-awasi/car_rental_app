import 'package:flutter/material.dart';
import 'package:flutter_coursess/core/constants/app_colors.dart';
import 'package:flutter_coursess/core/widgets/glass_container.dart';
import 'package:flutter_coursess/l10n/app_localizations.dart';
import 'package:flutter_coursess/models/car.dart';

class CarCard extends StatefulWidget {
  final Car car;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;

  const CarCard({
    super.key,
    required this.car,
    required this.onTap,
    this.onFavoriteToggle,
  });

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  late bool _isFavorite;

  @override
  void initState() {
    _isFavorite = widget.car.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localizedBrand = AppLocalizations.of(context).translate(widget.car.brand.toLowerCase());
    final localizedModel = AppLocalizations.of(context).translate(widget.car.model.toLowerCase());
    final displayBrand = localizedBrand == widget.car.brand.toLowerCase() ? widget.car.brand : localizedBrand;
    final displayModel = localizedModel == widget.car.model.toLowerCase() ? widget.car.model : localizedModel;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8), // Compressed padding to prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container with Favorite badge & Shop Tag
              Expanded(
                flex: 11,
                child: Stack(
                  children: [
                    // Car Image
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isDark 
                              ? AppColors.darkBackground 
                              : AppColors.lightBackground,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Hero(
                          tag: 'car-img-${widget.car.id}',
                          child: widget.car.images[0].startsWith('http')
                              ? Image.network(
                                  widget.car.images[0],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.car_rental, size: 40, color: Colors.grey),
                                  ),
                                )
                              : Image.asset(
                                  widget.car.images[0],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.car_rental, size: 40, color: Colors.grey),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    
                    // Shop Name Tag
                    Positioned(
                      left: 6,
                      top: 6,
                      child: GlassContainer(
                        borderRadius: 6,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        color: AppColors.primary.withOpacity(0.85),
                        border: Border.all(color: Colors.white24, width: 0.5),
                        child: Text(
                          widget.car.shopName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Condition tag
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          AppLocalizations.of(context).translate(widget.car.condition.toLowerCase()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              
              // Details Section
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand & Favorite Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            displayBrand.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                              widget.car.isFavorite = _isFavorite;
                            });
                            if (widget.onFavoriteToggle != null) {
                              widget.onFavoriteToggle!();
                            }
                          },
                          child: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.grey,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    // Model Name
                    Text(
                      displayModel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // Transmission / Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.ratingStar, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              widget.car.rating.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            "${AppLocalizations.of(context).translate(widget.car.transmission.toLowerCase())} • ${widget.car.seats} ${AppLocalizations.of(context).translate('seats')}",
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Divider
                    Divider(
                      height: 4,
                      thickness: 0.5,
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                    
                    // Pricing
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "\$${widget.car.price.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                          "/${widget.car.condition == "Daily"
                              ? AppLocalizations.of(context).translate('day')
                              : widget.car.condition == "Weekly"
                                  ? AppLocalizations.of(context).translate('week')
                                  : AppLocalizations.of(context).translate('month')}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
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
      ),
    );
  }
}
