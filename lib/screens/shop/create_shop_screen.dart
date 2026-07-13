import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coursess/core/auth/auth_notifier.dart';
import 'package:flutter_coursess/core/auth/firebase_auth_service.dart';
import 'package:flutter_coursess/core/constants/app_colors.dart';
import 'package:flutter_coursess/core/widgets/custom_button.dart';
import 'package:flutter_coursess/core/widgets/custom_textfield.dart';
import 'package:flutter_coursess/models/shop.dart';

class CreateShopScreen extends StatefulWidget {
  const CreateShopScreen({super.key});

  @override
  State<CreateShopScreen> createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _logoController = TextEditingController();

  bool _isSaving = false;

  Future<void> _saveShop() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final logo = _logoController.text.trim().isEmpty ? 'assets/images/default_shop.png' : _logoController.text.trim();
    final ownerUid = AuthNotifier.instance.currentUser?.uid;
    final shopId = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');

    final newShop = Shop(
      id: shopId,
      name: name,
      logo: logo,
      rating: 4.5,
      address: address,
      email: email,
      phone: phone,
      ownerUid: ownerUid,
    );

    localShopsList.add(newShop);

    try {
      await FirebaseFirestore.instance.collection('shops').doc(shopId).set(newShop.toMap());
      if (ownerUid != null) {
        await FirebaseAuthService.instance.addShopToOwner(ownerUid, shopId);
        final currentUser = AuthNotifier.instance.currentUser;
        if (currentUser != null) {
          AuthNotifier.instance.value = currentUser.copyWith(
            ownedShopIds: [...currentUser.ownedShopIds, shopId],
          );
          AuthNotifier.instance.notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Failed to write shop to Firestore: $e');
    }

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop created successfully')),
      );
      Navigator.pop(context, newShop);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Shop'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Shop Name',
                  prefixIcon: Icons.storefront_outlined,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Shop name is required';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _addressController,
                  hintText: 'Address',
                  prefixIcon: Icons.location_on_outlined,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Address is required';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Contact Email',
                  prefixIcon: Icons.email_outlined,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Email is required';
                    if (!val.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  hintText: 'Phone',
                  prefixIcon: Icons.phone_outlined,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Phone is required';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _logoController,
                  hintText: 'Logo path or URL (optional)',
                  prefixIcon: Icons.image_outlined,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Create Shop',
                  isLoading: _isSaving,
                  onTap: _saveShop,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
