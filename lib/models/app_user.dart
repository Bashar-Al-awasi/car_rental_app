enum UserRole { customer, owner, admin }

class AppUser {
  final String uid;
  final String name;
  final String email;
  final UserRole role;
  final List<String> ownedShopIds;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.ownedShopIds = const [],
  });

  bool get isOwner => role == UserRole.owner;
  bool get isCustomer => role == UserRole.customer;
  bool get isAdmin => role == UserRole.admin;

  factory AppUser.customer({required String uid, required String name, required String email}) {
    return AppUser(uid: uid, name: name, email: email, role: UserRole.customer);
  }

  factory AppUser.owner({required String uid, required String name, required String email, required List<String> ownedShopIds}) {
    return AppUser(uid: uid, name: name, email: email, role: UserRole.owner, ownedShopIds: ownedShopIds);
  }

  factory AppUser.fromMap(Map<String, dynamic> data) {
    final role = _parseRole(data['role']?.toString() ?? 'customer');
    final ownedShopIds = _parseOwnedShopIds(data['ownedShopIds']);
    return AppUser(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: role,
      ownedShopIds: ownedShopIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role.name,
      'ownedShopIds': ownedShopIds,
    };
  }

  AppUser copyWith({
    String? uid,
    String? name,
    String? email,
    UserRole? role,
    List<String>? ownedShopIds,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      ownedShopIds: ownedShopIds ?? this.ownedShopIds,
    );
  }

  static List<String> _parseOwnedShopIds(dynamic value) {
    if (value == null) return [];
    if (value is Iterable) {
      return value.whereType<String>().toList();
    }
    if (value is String) {
      return [value];
    }
    return [];
  }

  static UserRole _parseRole(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return UserRole.owner;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.customer;
    }
  }
}
