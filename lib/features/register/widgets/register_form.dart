import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/register/widgets/register_view_model.dart';
import 'package:tour_booking/models/register/register_request.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  DateTime? selectedBirthDate;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<RegisterViewModel>();

    final request = RegisterRequest(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      birthDate: selectedBirthDate!,
      phoneNumber: _phoneNumberController.text.trim(),
    );

    final result = await vm.register(request);

    if (result.isSuccess) {
      UIHelper.showSuccess(context, tr("register_success"));
      context.go("/email-confirmed");
    } else {
      if (vm.message != null) {
        UIHelper.showError(context, vm.message!);
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return tr("email_required");
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return tr("email_invalid");
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return tr("password_required");
    if (value.length < 9) return tr("password_too_short");

    final upper = RegExp(r'[A-Z]');
    final lower = RegExp(r'[a-z]');
    final digit = RegExp(r'\d');
    final special = RegExp(r'[^A-Za-z0-9]');

    final errors = <String>[];
    if (!upper.hasMatch(value)) errors.add(tr("password_must_include_upper"));
    if (!lower.hasMatch(value)) errors.add(tr("password_must_include_lower"));
    if (!digit.hasMatch(value)) errors.add(tr("password_must_include_digit"));
    if (!special.hasMatch(value))
      errors.add(tr("password_must_include_special"));

    return errors.isEmpty ? null : errors.join("\n");
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(labelText: tr("first_name")),
            validator: (value) => value!.isEmpty
                ? tr("first_name") + ' ' + tr("email_required").toLowerCase()
                : null,
          ),
          const SizedBox(height: AppSpacing.elementSpacing),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(labelText: tr("last_name")),
            validator: (value) => value!.isEmpty
                ? tr("last_name") + ' ' + tr("email_required").toLowerCase()
                : null,
          ),
          const SizedBox(height: AppSpacing.elementSpacing),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: tr("email")),
            validator: _validateEmail,
          ),
          const SizedBox(height: AppSpacing.elementSpacing),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: tr("password")),
            validator: _validatePassword,
          ),
          const SizedBox(height: AppSpacing.elementSpacing),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: tr("confirm_password")),
            validator: (value) {
              if (value != _passwordController.text) {
                return tr("passwords_do_not_match");
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.elementSpacing),
          IntlPhoneField(
            controller: _phoneNumberController,
            decoration: InputDecoration(
              labelText: tr('phone_number'),
              border: const OutlineInputBorder(),
            ),
            initialCountryCode: 'TR',
            disableLengthCheck: true,
            onChanged: (phone) {
              print(phone.completeNumber);
            },
            validator: (value) {
              if (value == null || value.number.isEmpty) {
                return tr('phone_required');
              }

              // Buraya kendi format/uzunluk kontrolünü eklersin
              if (value.number.length < 10 || value.number.length > 11) {
                return tr('invalid_phone_number');
              }

              return null;
            },
          ),
          const SizedBox(height: AppSpacing.elementSpacing),
          TextFormField(
            controller: _birthDateController,
            readOnly: true,
            decoration: InputDecoration(labelText: tr("birth_date")),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  selectedBirthDate = picked;
                  _birthDateController.text =
                      "${picked.day}/${picked.month}/${picked.year}";
                });
              }
            },
            validator: (value) =>
                selectedBirthDate == null ? tr("birth_date_required") : null,
          ),
          const SizedBox(height: AppSpacing.sectionSpacing),
          if (vm.validationErrors.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: vm.validationErrors
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        e,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: AppSpacing.sectionSpacing),
          vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(onPressed: _submit, child: Text(tr("register"))),
        ],
      ),
    );
  }
}
