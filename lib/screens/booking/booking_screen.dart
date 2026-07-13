import 'package:flutter/material.dart';
import 'package:flutter_coursess/core/constants/app_colors.dart';
import 'package:flutter_coursess/core/widgets/custom_button.dart';
import 'package:flutter_coursess/l10n/app_localizations.dart';
import 'package:flutter_coursess/models/car.dart';

class BookingScreen extends StatefulWidget {
  final Car car;
  final double defaultRate;
  final String defaultType;

  const BookingScreen({
    super.key,
    required this.car,
    required this.defaultRate,
    required this.defaultType,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 4));
  String? _pickupLocation;
  String? _returnLocation;
  bool _includeInsurance = true;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate) || _endDate.isAtSameMomentAs(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final int rentDays = _endDate.difference(_startDate).inDays;
    final double baseRentCost = rentDays * widget.defaultRate;
    final double insuranceCost = _includeInsurance ? rentDays * 15.0 : 0.0;

    double discount = 0.0;
    if (rentDays >= 30) {
      discount = baseRentCost * 0.25;
    } else if (rentDays >= 7) {
      discount = baseRentCost * 0.15;
    }

    final double subtotal = baseRentCost + insuranceCost - discount;
    final double tax = subtotal * 0.08;
    final double grandTotal = subtotal + tax;

    final locations = [
      AppLocalizations.of(context).translate('loc_aden_airport'),
      AppLocalizations.of(context).translate('loc_tawahi'),
      AppLocalizations.of(context).translate('loc_crater'),
      AppLocalizations.of(context).translate('loc_al_mansoura'),
      AppLocalizations.of(context).translate('loc_mualla'),
    ];

    final currentPickup = _pickupLocation ?? locations[0];
    final currentReturn = _returnLocation ?? locations[0];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('complete_booking'), style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 90,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                              ),
                              child: widget.car.images[0].startsWith('http')
                                  ? Image.network(widget.car.images[0], fit: BoxFit.contain)
                                  : Image.asset(widget.car.images[0], fit: BoxFit.contain),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.car.brand.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    widget.car.model,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    AppLocalizations.of(context).translate('provided_by').replaceFirst('{shop}', widget.car.shopName),
                                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(AppLocalizations.of(context).translate('rental_duration'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectStartDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                borderRadius: BorderRadius.circular(16),
                                color: isDark ? AppColors.darkSurface : Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context).translate('pick_up_date'), style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month, size: 16, color: theme.colorScheme.primary),
                                      const SizedBox(width: 6),
                                      Text(
                                        "${_startDate.day}/${_startDate.month}/${_startDate.year}",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectEndDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                borderRadius: BorderRadius.circular(16),
                                color: isDark ? AppColors.darkSurface : Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context).translate('drop_off_date'), style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month, size: 16, color: theme.colorScheme.primary),
                                      const SizedBox(width: 6),
                                      Text(
                                        "${_endDate.day}/${_endDate.month}/${_endDate.year}",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(AppLocalizations.of(context).translate('pick_up_location'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: BorderRadius.circular(16),
                        color: isDark ? AppColors.darkSurface : Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: currentPickup,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: locations.map((String loc) {
                            return DropdownMenuItem<String>(
                              value: loc,
                              child: Text(loc, style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _pickupLocation = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(AppLocalizations.of(context).translate('return_location'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: BorderRadius.circular(16),
                        color: isDark ? AppColors.darkSurface : Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: currentReturn,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: locations.map((String loc) {
                            return DropdownMenuItem<String>(
                              value: loc,
                              child: Text(loc, style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _returnLocation = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SwitchListTile(
                      title: Text(AppLocalizations.of(context).translate('premium_collision'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text(AppLocalizations.of(context).translate('protection_desc').replaceFirst('{price}', '\$15.00'), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      value: _includeInsurance,
                      onChanged: (val) {
                        setState(() {
                          _includeInsurance = val;
                        });
                      },
                      activeColor: theme.colorScheme.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(height: 30),

                    Text(AppLocalizations.of(context).translate('fare_summary'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                    const SizedBox(height: 12),
                    _buildReceiptRow(AppLocalizations.of(context).translate('rental_rate').replaceFirst('{days}', rentDays.toString()), "\$${baseRentCost.toStringAsFixed(2)}"),
                    if (_includeInsurance)
                      _buildReceiptRow(AppLocalizations.of(context).translate('protection_cover').replaceFirst('{price}', '\$15.00'), "\$${insuranceCost.toStringAsFixed(2)}"),
                    if (discount > 0)
                      _buildReceiptRow(AppLocalizations.of(context).translate('duration_discount'), "-\$${discount.toStringAsFixed(2)}", isDiscount: true),
                    _buildReceiptRow(AppLocalizations.of(context).translate('local_sales_tax').replaceFirst('{rate}', '8.0%'), "\$${tax.toStringAsFixed(2)}"),
                    const Divider(height: 20),
                    _buildReceiptRow(AppLocalizations.of(context).translate('grand_total'), "\$${grandTotal.toStringAsFixed(2)}", isBold: true),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              ),
              child: CustomButton(
                text: AppLocalizations.of(context).translate('confirm_hold_ride'),
                onTap: () {
                  _showSuccessDialog(context, rentDays, grandTotal);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String title, String value, {bool isDiscount = false, bool isBold = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 15 : 13,
              color: isBold 
                  ? (theme.brightness == Brightness.dark ? Colors.white : AppColors.lightTextPrimary)
                  : Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 13,
              color: isDiscount 
                  ? AppColors.accent 
                  : (isBold ? theme.colorScheme.primary : (theme.brightness == Brightness.dark ? Colors.white : AppColors.lightTextPrimary)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, int days, double total) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        final theme = Theme.of(ctx);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withOpacity(0.15),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.accent,
                    size: 54,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context).translate('booking_confirmed'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context).translate('booking_reserved_for')
                      .replaceFirst('{car}', '${widget.car.brand} ${widget.car.model}')
                      .replaceFirst('{days}', days.toString())
                      .replaceFirst('{shop}', widget.car.shopName),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).translate('pickup_location_label'), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Expanded(
                      child: Text(
                        (_pickupLocation ?? AppLocalizations.of(context).translate('loc_aden_airport')).split(" (")[0],
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).translate('total_charged'), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      "\$${total.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: AppLocalizations.of(context).translate('done'),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
