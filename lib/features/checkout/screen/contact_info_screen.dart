import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/checkout/viewmodel/contact_info_viewmodel.dart';

class ContactInfoScreen extends StatefulWidget {
  final void Function(String firstName, String lastName, String email, String phone) onContinue;

  const ContactInfoScreen({super.key, required this.onContinue});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactInfoViewModel>().prefillFromProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactInfoViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: CommonAppBar(title: tr('contact_info_title')),
          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: AppColors.primary, size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  tr('contact_info_description'),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Form card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildField(
                                controller: vm.firstNameController,
                                label: tr('contact_first_name'),
                                icon: Icons.person_outline,
                                validator: vm.validateFirstName,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),
                              _buildField(
                                controller: vm.lastNameController,
                                label: tr('contact_last_name'),
                                icon: Icons.person_outline,
                                validator: vm.validateLastName,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),
                              _buildField(
                                controller: vm.emailController,
                                label: tr('contact_email'),
                                icon: Icons.email_outlined,
                                validator: vm.validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),
                              _buildField(
                                controller: vm.phoneController,
                                label: tr('contact_phone'),
                                icon: Icons.phone_outlined,
                                validator: vm.validatePhone,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Continue button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                widget.onContinue(
                                  vm.firstName,
                                  vm.lastName,
                                  vm.email,
                                  vm.phone,
                                );
                              }
                            },
                            child: Text(
                              tr('contact_continue_to_payment'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: AppColors.textSecondary),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
