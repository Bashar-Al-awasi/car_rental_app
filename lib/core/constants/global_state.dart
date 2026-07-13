import 'package:flutter/material.dart';
import 'package:flutter_coursess/models/car.dart';

class GlobalState extends ChangeNotifier {
  static final GlobalState _instance = GlobalState._internal();
  factory GlobalState() => _instance;
  GlobalState._internal() {
    // Initialize with standard local car database
    _carsList = _initMockCars();
  }

  late List<Car> _carsList;
  final List<Car> _favoritesList = [];

  List<Car> get cars => _carsList;
  List<Car> get favorites => _favoritesList;

  // Sync cars from Firestore if loaded
  void setCars(List<Car> newCars) {
    // Keep favorites status intact
    for (var car in newCars) {
      car.isFavorite = _favoritesList.any((fav) => fav.id == car.id);
    }
    _carsList = newCars;
    notifyListeners();
  }

  void addCar(Car car) {
    _carsList.insert(0, car);
    notifyListeners();
  }

  void removeCar(String carId) {
    _carsList.removeWhere((c) => c.id == carId);
    _favoritesList.removeWhere((c) => c.id == carId);
    notifyListeners();
  }

  void toggleFavorite(Car car) {
    if (_favoritesList.any((fav) => fav.id == car.id)) {
      _favoritesList.removeWhere((fav) => fav.id == car.id);
      car.isFavorite = false;
    } else {
      car.isFavorite = true;
      _favoritesList.add(car);
    }
    notifyListeners();
  }

  List<Car> _initMockCars() {
    return [
      Car(
        id: "land_rover_discovery",
        brand: "Land Rover",
        model: "Discovery Sport",
        price: 2580,
        condition: "Weekly",
        images: ["assets/images/land_rover_0.png", "assets/images/land_rover_1.png"],
        transmission: "Automatic",
        fuel: "Diesel",
        seats: "7",
        engine: "3.0L V6 Turbo",
        speed: "0-100 in 7.9s",
        rating: 4.8,
        shopId: "hertz",
        shopName: "Hertz Rent A Car",
      ),
      Car(
        id: "nissan_gtr",
        brand: "Nissan",
        model: "GT-R Nismo",
        price: 1100,
        condition: "Daily",
        images: ["assets/images/nissan_gtr_0.png", "assets/images/nissan_gtr_1.png"],
        transmission: "Automatic",
        fuel: "Petrol",
        seats: "4",
        engine: "3.8L V6 Twin-Turbo",
        speed: "0-100 in 2.8s",
        rating: 4.9,
        shopId: "local_deals",
        shopName: "Local Ride Bargains",
      ),
      Car(
        id: "chevrolet_camaro",
        brand: "Chevrolet",
        model: "Camaro SS",
        price: 3400,
        condition: "Weekly",
        images: ["assets/images/camaro_0.png", "assets/images/camaro_1.png"],
        transmission: "Automatic",
        fuel: "Petrol",
        seats: "4",
        engine: "6.2L V8",
        speed: "0-100 in 4.0s",
        rating: 4.7,
        shopId: "avis",
        shopName: "Avis Car Rental",
      ),
      Car(
        id: "ferrari_spider",
        brand: "Ferrari",
        model: "Spider 488",
        price: 4200,
        condition: "Weekly",
        images: ["assets/images/ferrari_spider_488_0.png", "assets/images/ferrari_spider_488_1.png"],
        transmission: "Automatic",
        fuel: "Petrol",
        seats: "2",
        engine: "3.9L Twin-Turbo V8",
        speed: "0-100 in 3.0s",
        rating: 4.9,
        shopId: "tesla_rent",
        shopName: "Tesla Drive Experience",
      ),
      Car(
        id: "acura_mdx",
        brand: "Acura",
        model: "MDX Type-S",
        price: 2200,
        condition: "Monthly",
        images: ["assets/images/acura_0.png", "assets/images/acura_1.png"],
        transmission: "Automatic",
        fuel: "Petrol",
        seats: "7",
        engine: "3.0L V6 Turbo",
        speed: "0-100 in 6.4s",
        rating: 4.6,
        shopId: "hertz",
        shopName: "Hertz Rent A Car",
      ),
      Car(
        id: "honda_civic",
        brand: "Honda",
        model: "Civic Sedan",
        price: 900,
        condition: "Daily",
        images: ["assets/images/honda_0.png"],
        transmission: "Manual",
        fuel: "Petrol",
        seats: "5",
        engine: "1.5L Turbo 4-Cyl",
        speed: "0-100 in 7.5s",
        rating: 4.5,
        shopId: "local_deals",
        shopName: "Local Ride Bargains",
      ),
    ];
  }
}

// Global instance of global state
final globalState = GlobalState();
