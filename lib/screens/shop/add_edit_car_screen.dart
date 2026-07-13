import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coursess/core/constants/app_colors.dart';
import 'package:flutter_coursess/core/constants/global_state.dart';
import 'package:flutter_coursess/core/widgets/custom_button.dart';
import 'package:flutter_coursess/core/widgets/custom_textfield.dart';
import 'package:flutter_coursess/models/car.dart';
import 'package:flutter_coursess/models/shop.dart';

class AddEditCarScreen extends StatefulWidget {
  final Shop shop;

  const AddEditCarScreen({super.key, required this.shop});

  @override
  State<AddEditCarScreen> createState() => _AddEditCarScreenState();
}

class _AddEditCarScreenState extends State<AddEditCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();
  final _engineController = TextEditingController();
  final _speedController = TextEditingController();
  final _imageController = TextEditingController();

  String _selectedBrand = "Honda";
  String _selectedCondition = "Daily";
  String _selectedTransmission = "Automatic";
  String _selectedFuel = "Petrol";
  String _selectedSeats = "5";

  bool _isSaving = false;

  final List<String> _brands = ["Honda", "Toyota", "Tesla", "Chevrolet", "Land Rover", "Ferrari", "Ford", "Nissan"];
  final List<String> _conditions = ["Daily", "Weekly", "Monthly"];
  final List<String> _transmissions = ["Automatic", "Manual"];
  final List<String> _fuels = ["Petrol", "Diesel", "Electric", "Hybrid"];
  final List<String> _seatsOptions = ["2", "4", "5", "7"];

  // A list of pre-configured clean mockup images corresponding to brands for quick listing demo
  final Map<String, String> _brandMockImages = {
    "Honda": "assets/images/honda_0.png",
    "Toyota": "assets/images/alfa_romeo_c4_0.png",
    "Tesla": "assets/images/tesla.jpg",
    "Chevrolet": "assets/images/camaro_0.png",
    "Land Rover": "assets/images/land_rover_0.png",
    "Ferrari": "assets/images/ferrari_spider_488_0.png",
    "Ford": "assets/images/ford_0.png",
    "Nissan": "assets/images/nissan_gtr_0.png",
  };

  void _saveListing() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final modelName = _modelController.text.trim();
      final priceVal = double.tryParse(_priceController.text.trim()) ?? 100.0;
      final engineVal = _engineController.text.trim().isEmpty ? "2.0L Turbo" : _engineController.text.trim();
      final speedVal = _speedController.text.trim().isEmpty ? "0-100 in 6.5s" : _speedController.text.trim();
      
      // Determine final image path
      String imgPath = _imageController.text.trim();
      if (imgPath.isEmpty) {
        imgPath = _brandMockImages[_selectedBrand] ?? "assets/images/honda_0.png";
      }

      final newCar = Car(
        id: "car_${DateTime.now().millisecondsSinceEpoch}",
        brand: _selectedBrand,
        model: modelName,
        price: priceVal,
        condition: _selectedCondition,
        images: [imgPath],
        transmission: _selectedTransmission,
        fuel: _selectedFuel,
        seats: _selectedSeats,
        engine: engineVal,
        speed: speedVal,
        rating: 4.8,
        shopId: widget.shop.id,
        shopName: widget.shop.name,
      );

      // 1. Add to local State Manager for immediate response
      globalState.addCar(newCar);

      // 2. Add to Firebase Firestore
      try {
        await FirebaseFirestore.instance.collection("Car type").add({
          "Name": "$_selectedBrand $modelName",
          "Type": _selectedBrand,
          "image": imgPath.startsWith('http') ? imgPath : '', // Only URL in firebase
          "price": priceVal,
          "condition": _selectedCondition,
          "transmission": _selectedTransmission,
          "fuel": _selectedFuel,
          "seats": _selectedSeats,
          "engine": engineVal,
          "speed": speedVal,
          "shopId": widget.shop.id,
          "shopName": widget.shop.name,
          "rating": 4.8,
        });
      } catch (e) {
        // Safe catch if Firebase is offline/missing credentials
        debugPrint("Firestore write failed, fallback to local memory state: $e");
      }

      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.accent,
            content: Text("Listing created for $modelName successfully!"),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _modelController.dispose();
    _priceController.dispose();
    _engineController.dispose();
    _speedController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("List Car • ${widget.shop.name.split(" ")[0]}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Form Header
                      const Text(
                        "List A New Car",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Fill in details to lease this car under ${widget.shop.name}",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 24),

                      // Brand dropdown
                      _buildLabel("CAR BRAND / MAKE"),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          borderRadius: BorderRadius.circular(16),
                          color: isDark ? AppColors.darkSurface : Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedBrand,
                            isExpanded: true,
                            items: _brands.map((String b) {
                              return DropdownMenuItem<String>(value: b, child: Text(b));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedBrand = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Model Name input
                      _buildLabel("MODEL NAME"),
                      CustomTextField(
                        controller: _modelController,
                        hintText: "e.g. Accord, Model Y, Camaro SS",
                        prefixIcon: Icons.drive_file_rename_outline_rounded,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return "Model name is required";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Price Input
                      _buildLabel("RENTAL RATE (USD)"),
                      CustomTextField(
                        controller: _priceController,
                        hintText: "e.g. 1500 (Base Price)",
                        prefixIcon: Icons.attach_money_rounded,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return "Rental rate is required";
                          if (double.tryParse(val.trim()) == null) return "Please enter a valid price";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Rent Condition Selection
                      _buildLabel("RENTAL CONTRACT PERIOD"),
                      Row(
                        children: List.generate(_conditions.length, (index) {
                          final cond = _conditions[index];
                          final isSel = _selectedCondition == cond;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedCondition = cond),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.primary : (isDark ? AppColors.darkSurface : Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: isSel ? Colors.transparent : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                                ),
                                child: Text(
                                  cond,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      // Split dropdowns: Transmission & Fuel
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("GEARBOX"),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                    borderRadius: BorderRadius.circular(14),
                                    color: isDark ? AppColors.darkSurface : Colors.white,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedTransmission,
                                      isExpanded: true,
                                      items: _transmissions.map((String t) {
                                        return DropdownMenuItem<String>(value: t, child: Text(t, style: const TextStyle(fontSize: 13)));
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _selectedTransmission = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("FUEL SYSTEM"),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                    borderRadius: BorderRadius.circular(14),
                                    color: isDark ? AppColors.darkSurface : Colors.white,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedFuel,
                                      isExpanded: true,
                                      items: _fuels.map((String f) {
                                        return DropdownMenuItem<String>(value: f, child: Text(f, style: const TextStyle(fontSize: 13)));
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _selectedFuel = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Seats selector
                      _buildLabel("PASSENGER CAPACITY SEATS"),
                      Row(
                        children: List.generate(_seatsOptions.length, (index) {
                          final option = _seatsOptions[index];
                          final isSel = _selectedSeats == option;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedSeats = option),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.primary : (isDark ? AppColors.darkSurface : Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: isSel ? Colors.transparent : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                                ),
                                child: Text(
                                  "$option Seats",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),

                      // Specifications Inputs
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("ENGINE SIZE"),
                                CustomTextField(
                                  controller: _engineController,
                                  hintText: "e.g. 2.0L Dual VVT",
                                  prefixIcon: Icons.offline_bolt_rounded,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("ACCELERATION SPEED"),
                                CustomTextField(
                                  controller: _speedController,
                                  hintText: "e.g. 0-100 in 6s",
                                  prefixIcon: Icons.speed_rounded,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Optional Custom Image URL
                      _buildLabel("CUSTOM CAR IMAGE URL (OPTIONAL)"),
                      CustomTextField(
                        controller: _imageController,
                        hintText: "Leave blank to use brand default image",
                        prefixIcon: Icons.link_rounded,
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              
              // Submit button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                ),
                child: CustomButton(
                  text: "Submit Listing",
                  isLoading: _isSaving,
                  onTap: _saveListing,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: Colors.grey),
      ),
    );
  }
}
