import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/models/update_phone_number/update_phone_request.dart';
import 'package:flutter/material.dart' as ui;

class UpdatePhoneScreen extends StatefulWidget {
  const UpdatePhoneScreen({super.key});

  @override
  State<UpdatePhoneScreen> createState() => _UpdatePhoneScreenState();
}

class _UpdatePhoneScreenState extends State<UpdatePhoneScreen> {
  dynamic _selectedPhoneNumber;
  String oldCompleteNumber = "";
  String oldCountryCode = "";
  bool _phoneVerified = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final profile = context.read<ProfileViewModel>().profile;

    if (profile != null && oldCompleteNumber.isEmpty) {
      oldCompleteNumber = profile.phoneNumber.trim();
      _phoneVerified = profile.phoneNumberConfirmed;

      if (oldCompleteNumber.startsWith("+")) {
        final onlyDigits = oldCompleteNumber.substring(1);
        oldCountryCode = onlyDigits.substring(0, onlyDigits.length - 10);
      }
    }
  }

  /// Did the number change?
  bool get _isNumberChanged {
    if (_selectedPhoneNumber == null) return false;
    final newComplete = _selectedPhoneNumber.completeNumber;
    if (newComplete.isEmpty) return false;
    return newComplete != oldCompleteNumber;
  }

  /// Same number + not verified -> verification mode
  bool get _isVerifyMode {
    if (oldCompleteNumber.isEmpty) return false;
    if (_phoneVerified) return false;
    return !_isNumberChanged;
  }

  bool get isButtonEnabled {
    // Verification mode: number exists but not verified, number unchanged
    if (_isVerifyMode) return true;
    // Save mode: number has changed
    return _isNumberChanged;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: CommonAppBar(
        title: oldCompleteNumber.isEmpty
            ? tr("add_phone_number")
            : tr("update_phone_number"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Directionality(
              textDirection: ui.TextDirection.ltr,
              child: IntlPhoneField(
                invalidNumberMessage: tr("invalid_phone_number"),
                initialCountryCode: oldCountryCode.isEmpty ? "TR" : null,
                initialValue: oldCompleteNumber.isNotEmpty
                    ? oldCompleteNumber
                    : null,
                decoration: InputDecoration(
                  labelText: tr("phone_number"),
                ),
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.87),
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (phone) {
                  setState(() {
                    _selectedPhoneNumber = phone;
                  });
                },
                validator: (value) {
                  if (value == null || value.number.isEmpty) {
                    return tr("phone_required");
                  }
                  if (value.number.length < 7) {
                    return tr("phone_too_short");
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            PrimaryButton(
              text: _isVerifyMode ? tr("verify") : tr("save"),
              isLoading: vm.isLoading,
              onPressed: isButtonEnabled
                  ? () async {
                      if (_isVerifyMode) {
                        // Same number, not verified -> go directly to verification
                        context.push("/verify-phone");
                        return;
                      }

                      // Number changed -> save, then go to verification
                      final complete = _selectedPhoneNumber.completeNumber;
                      final country = _selectedPhoneNumber.countryCode;

                      final success = await vm.updatePhoneNumber(
                        UpdatePhoneRequestDto(
                          phoneNumber: complete,
                          countryCode: country,
                        ),
                      );

                      if (!mounted) return;
                      if (success) {
                        context.push("/verify-phone");
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
