class Shop {
  final String id;
  final String name;
  final String logo;
  final double rating;
  final String address;
  final String email;
  final String phone;
  final String? ownerUid;

  Shop({
    required this.id,
    required this.name,
    required this.logo,
    required this.rating,
    required this.address,
    required this.email,
    required this.phone,
    this.ownerUid,
  });

  // Factory constructor for mock items
  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      logo: map['logo'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      address: map['address'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      ownerUid: map['ownerUid']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'rating': rating,
      'address': address,
      'email': email,
      'phone': phone,
      'ownerUid': ownerUid,
    };
  }
}

// Global list of available shops for demo & registration
List<Shop> localShopsList = [
  Shop(
    id: "hertz",
    name: "Hertz Aden Rentals",
    logo: "assets/images/hertz.png",
    rating: 4.8,
    address: "Aden International Airport, Al-Mualla",
    email: "support@hertz-aden.com",
    phone: "+967 2 123 456",
  ),
  Shop(
    id: "avis",
    name: "Al-Mualla Car Hire",
    logo: "assets/images/avis.png",
    rating: 4.6,
    address: "Crater Road, Aden",
    email: "service@almualla-avis.com",
    phone: "+967 2 987 654",
  ),
  Shop(
    id: "tesla_rent",
    name: "Aden Electric Motors",
    logo: "assets/images/tesla.jpg",
    rating: 4.9,
    address: "Seaside Avenue, Khormaksar",
    email: "rentals@aden-electric.com",
    phone: "+967 2 555 010",
  ),
  Shop(
    id: "local_deals",
    name: "Wednes Car Deals",
    logo: "images/snap.jpg", // original snap image
    rating: 4.2,
    address: "Shihr Market, Aden",
    email: "info@wednes-aden.com",
    phone: "+967 2 444 333",
  ),
];
