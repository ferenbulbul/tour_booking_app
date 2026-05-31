import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/profile/profile_response.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/tour/tour_service.dart';
import 'package:tour_booking/navigation/app_router.dart';

class ContactInfoViewModel extends BaseViewModel {
  final TourService _tourService = ServiceLocator.instance.tourService;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = false;
  bool isPrefilled = false;

  /// Phone data from IntlPhoneField
  String _phoneCompleteNumber = '';
  String _initialPhone = '';

  String get firstName => firstNameController.text.trim();
  String get lastName => lastNameController.text.trim();
  String get email => emailController.text.trim();
  String get phone => _phoneCompleteNumber;
  String get initialPhone => _initialPhone;

  void setPhone(String completeNumber) {
    _phoneCompleteNumber = completeNumber;
  }

  /// Prefill from profile if user is registered (non-guest)
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
    } catch (e) {
      debugPrint('ContactInfoViewModel.prefillFromProfile: $e');
      // Prefill failed — user fills in manually
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _prefillFromProfileResponse(ProfileResponse profile) {
    // fullName may come as "FirstName LastName"
    final parts = profile.fullName.split(' ');
    if (parts.isNotEmpty) {
      firstNameController.text = parts.first;
      if (parts.length > 1) {
        lastNameController.text = parts.sublist(1).join(' ');
      }
    }
    emailController.text = profile.email;
    _initialPhone = profile.phoneNumber;
    _phoneCompleteNumber = profile.phoneNumber;
  }

  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) return tr('validation_first_name_required');
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) return tr('validation_last_name_required');
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return tr('validation_email_required');
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return tr('validation_email_invalid');
    return null;
  }

  String? validatePhone() {
    if (_phoneCompleteNumber.isEmpty) return tr('validation_phone_required');
    final digits = _phoneCompleteNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length < 10) return tr('validation_phone_invalid');
    return null;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
