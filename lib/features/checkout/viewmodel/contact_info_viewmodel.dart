import 'package:flutter/material.dart';
import 'package:tour_booking/models/profile/profile_response.dart';
import 'package:tour_booking/services/tour/tour_service.dart';
import 'package:tour_booking/navigation/app_router.dart';

class ContactInfoViewModel extends ChangeNotifier {
  final TourService _tourService = TourService();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;
  bool isPrefilled = false;

  String get firstName => firstNameController.text.trim();
  String get lastName => lastNameController.text.trim();
  String get email => emailController.text.trim();
  String get phone => phoneController.text.trim();

  /// Kayıtlı (non-guest) kullanıcı ise profilden doldur
  Future<void> prefillFromProfile() async {
    if (splashViewModel.isGuest) return;

    isLoading = true;
    notifyListeners();

    try {
      final resp = await _tourService.getProfile();
      if (resp.isSuccess == true && resp.data != null) {
        final profile = resp.data!;
        _prefillFromProfileResponse(profile);
        isPrefilled = true;
      }
    } catch (_) {
      // Prefill başarısız — kullanıcı manuel doldursun
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _prefillFromProfileResponse(ProfileResponse profile) {
    // fullName "Ad Soyad" şeklinde gelebilir
    final parts = profile.fullName.split(' ');
    if (parts.isNotEmpty) {
      firstNameController.text = parts.first;
      if (parts.length > 1) {
        lastNameController.text = parts.sublist(1).join(' ');
      }
    }
    emailController.text = profile.email;
    phoneController.text = profile.phoneNumber;
  }

  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ad zorunludur';
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Soyad zorunludur';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'E-posta zorunludur';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Geçerli bir e-posta giriniz';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Telefon zorunludur';
    final digits = value.replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.length < 10) return 'Geçerli bir telefon numarası giriniz';
    return null;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
