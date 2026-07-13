import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_coursess/models/app_user.dart';

class FirebaseAuthService {
  FirebaseAuthService._internal();
  static final FirebaseAuthService instance = FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<AppUser?> loadCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    final data = doc.data() ?? {
      'name': firebaseUser.displayName ?? '',
      'email': firebaseUser.email ?? '',
      'role': 'customer',
      'ownedShopIds': [],
    };

    return AppUser.fromMap({
      'uid': firebaseUser.uid,
      'name': data['name'] ?? firebaseUser.displayName ?? '',
      'email': data['email'] ?? firebaseUser.email ?? '',
      'role': data['role'] ?? 'customer',
      'ownedShopIds': data['ownedShopIds'] ?? [],
    });
  }

  Future<AppUser?> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final user = result.user;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data() ?? {
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'role': 'customer',
      'ownedShopIds': [],
    };
    return AppUser.fromMap({
      'uid': user.uid,
      'name': data['name'] ?? user.displayName ?? '',
      'email': data['email'] ?? user.email ?? '',
      'role': data['role'] ?? 'customer',
      'ownedShopIds': data['ownedShopIds'] ?? [],
    });
  }

  Future<AppUser?> signUp(String name, String email, String password, {String role = 'customer'}) async {
    final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = result.user;
    if (user == null) return null;

    final userData = {
      'uid': user.uid,
      'name': name,
      'email': email,
      'role': role,
      'ownedShopIds': [],
    };

    await _firestore.collection('users').doc(user.uid).set(userData);

    return AppUser.fromMap(userData);
  }

  Future<void> addShopToOwner(String ownerUid, String shopId) async {
    final userDoc = _firestore.collection('users').doc(ownerUid);
    await userDoc.set(
      {'ownedShopIds': FieldValue.arrayUnion([shopId])},
      SetOptions(merge: true),
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
