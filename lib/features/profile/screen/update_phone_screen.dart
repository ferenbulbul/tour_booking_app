import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/models/update_phone_number/update_phone_request.dart';

class UpdatePhoneScreen extends StatefulWidget {
  const UpdatePhoneScreen({super.key});

  @override
  State<UpdatePhoneScreen> createState() => _UpdatePhoneScreenState();
}

class _UpdatePhoneScreenState extends State<UpdatePhoneScreen> {
  dynamic _selectedPhoneNumber;
  String oldCompleteNumber = "";
  String oldCountryCode = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final profile = context.read<ProfileViewModel>().profile;

    if (profile != null && oldCompleteNumber.isEmpty) {
      oldCompleteNumber = profile.phoneNumber.trim();

      // eski numara + ülke kodu ayrıştırma
      if (oldCompleteNumber.startsWith("+")) {
        final onlyDigits = oldCompleteNumber.substring(1);
        oldCountryCode = onlyDigits.substring(0, onlyDigits.length - 10);
      }
    }
  }

  bool get isButtonEnabled {
    if (_selectedPhoneNumber == null) return false;

    final newComplete = _selectedPhoneNumber.completeNumber;

    // boşsa disable
    if (newComplete.isEmpty) return false;

    // aynı numara ise disable
    if (newComplete == oldCompleteNumber) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          oldCompleteNumber.isEmpty
              ? tr("add_phone_number")
              : tr("update_phone_number"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            IntlPhoneField(
              initialCountryCode: oldCountryCode.isEmpty ? "TR" : null,
              initialValue: oldCompleteNumber.isNotEmpty
                  ? oldCompleteNumber
                  : null,
              decoration: InputDecoration(
                labelText: tr("phone_number"),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(
                color: Colors.black87,
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

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () async {
                        final complete = _selectedPhoneNumber.completeNumber;
                        final country = _selectedPhoneNumber.countryCode;

                        await vm.updatePhoneNumber(
                          UpdatePhoneRequestDto(
                            phoneNumber: complete,
                            countryCode: country,
                          ),
                        );

                        if (!mounted) return;
                        Navigator.pop(context);
                      }
                    : null,
                child: Text(tr("save")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
