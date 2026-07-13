import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final String id;
  final String brand;
  final String model;
  final double price;
  final String condition;
  final List<String> images;
  final String transmission;
  final String fuel;
  final String seats;
  final String engine;
  final String speed;
  final double rating;
  final String shopId;
  final String shopName;
  bool isFavorite;

  Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.price,
    required this.condition,
    required this.images,
    this.transmission = "Automatic",
    this.fuel = "Petrol",
    this.seats = "5",
    this.engine = "2.0L Turbo",
    this.speed = "0-100 km/h in 6.5s",
    this.rating = 4.8,
    this.shopId = "default_shop",
    this.shopName = "Main Rental Shop",
    this.isFavorite = false,
  });

  // Factory constructor to safely parse Firestore snapshot with fallbacks
  factory Car.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Determine the name
    final fullName = data['Name'] ?? data['model'] ?? 'Unknown Car';
    final parts = fullName.toString().split(' ');
    final brand = parts.isNotEmpty ? parts[0] : (data['Type'] ?? 'Unknown');
    final model = parts.length > 1 ? parts.sublist(1).join(' ') : fullName;

    // Handle image URLs. Some documents might use 'image', 'Image', or custom fields.
    final List<String> imageList = [];
    if (data['image'] != null && data['image'].toString().isNotEmpty) {
      imageList.add(data['image'].toString());
    } else if (data['Image'] != null && data['Image'].toString().isNotEmpty) {
      imageList.add(data['Image'].toString());
    } else if (data['Honda'] != null && data['Honda'].toString().isNotEmpty) {
      imageList.add(data['Honda'].toString());
    } else {
      imageList.add('https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&q=80&w=600');
    }

    // Safely parse price
    double priceVal = 0.0;
    final rawPrice = data['price'];
    if (rawPrice != null) {
      if (rawPrice is num) {
        priceVal = rawPrice.toDouble();
      } else {
        priceVal = double.tryParse(rawPrice.toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      }
    }

    return Car(
      id: doc.id,
      brand: brand,
      model: model,
      price: priceVal > 0 ? priceVal : 1500.0,
      condition: data['condition'] ?? (priceVal > 3000 ? "Monthly" : priceVal > 1500 ? "Weekly" : "Daily"),
      images: imageList,
      transmission: data['transmission'] ?? "Automatic",
      fuel: data['fuel'] ?? "Petrol",
      seats: data['seats']?.toString() ?? "5",
      engine: data['engine'] ?? "2.0L Dual-VVT",
      speed: data['speed']?.toString() ?? "0-100 in 7.4s",
      rating: (data['rating'] as num?)?.toDouble() ?? 4.8,
      shopId: data['shopId'] ?? "main_shop",
      shopName: data['shopName'] ?? "Elite Car Hub",
      isFavorite: false,
    );
  }

  // Convert to Map for saving back to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'Name': '$brand $model',
      'Type': brand,
      'image': images.isNotEmpty ? images[0] : '',
      'price': price,
      'condition': condition,
      'transmission': transmission,
      'fuel': fuel,
      'seats': seats,
      'engine': engine,
      'speed': speed,
      'rating': rating,
      'shopId': shopId,
      'shopName': shopName,
    };
  }
}
