import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/checkout/viewmodel/contact_info_viewmodel.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class ContactInfoScreen extends StatefulWidget {
  final void Function(
      String firstName, String lastName, String email, String phone)
      onContinue;

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
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Consumer<ContactInfoViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: context.colors.surfaceContainerHighest,
          appBar: CommonAppBar(title: tr('contact_info_title')),
          body: vm.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: context.colors.secondary,
                    strokeWidth: 2.5,
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  children: [
                    // Info banner
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      decoration: BoxDecoration(
                        color: context.colors.secondary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        border: Border.all(
                          color: context.colors.secondary.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(SolarIconsOutline.infoCircle,
                              color: context.colors.secondary, size: AppIconSize.ml, semanticLabel: 'Information'),
                          const SizedBox(width: AppSpacing.ms),
                          Expanded(
                            child: Text(
                              tr('contact_info_description'),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: context.colors.onSurfaceVariant,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Form inside bordered card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.ml),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.ml),
                        border: Border.all(color: context.colors.outline),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildField(
                              controller: vm.firstNameController,
                              label: tr('contact_first_name'),
                              icon: SolarIconsOutline.user,
                              validator: vm.validateFirstName,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSpacing.m),
                            _buildField(
                              controller: vm.lastNameController,
                              label: tr('contact_last_name'),
                              icon: SolarIconsOutline.user,
                              validator: vm.validateLastName,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSpacing.m),
                            _buildField(
                              controller: vm.emailController,
                              label: tr('contact_email'),
                              icon: SolarIconsOutline.letter,
                              validator: vm.validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSpacing.m),
                            _buildField(
                              controller: vm.phoneController,
                              label: tr('contact_phone'),
                              icon: SolarIconsOutline.phone,
                              validator: vm.validatePhone,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          // Sticky bottom button
          bottomNavigationBar: vm.isLoading
              ? null
              : Container(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerHighest,
                    border: Border(
                      top: BorderSide(color: context.colors.outline, width: 0.5),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.l,
                    AppSpacing.ms,
                    AppSpacing.l,
                    bottomPad > 0 ? bottomPad : AppSpacing.m,
                  ),
                  child: Semantics(
                    button: true,
                    label: 'Continue to payment',
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onContinue(
                            vm.firstName,
                            vm.lastName,
                            vm.email,
                            vm.phone,
                          );
                        }
                      },
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: context.colors.secondary,
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          tr('contact_continue_to_payment'),
                          style: AppTextStyles.labelLarge.copyWith(
                            color: context.colors.onSecondary,
                          ),
                        ),
                      ),
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
      style: AppTextStyles.labelLarge.copyWith(
        color: context.colors.onSurface,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: AppTextStyles.labelLarge.copyWith(
          color: context.ext.textLight,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, size: AppIconSize.ml, color: context.ext.textLight),
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: context.colors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: context.colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(
            color: context.colors.secondary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: context.colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: context.colors.error, width: 1.5),
        ),
        errorStyle: AppTextStyles.caption.copyWith(
          color: context.colors.error,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.ml, vertical: AppSpacing.m),
      ),
    );
  }
}
