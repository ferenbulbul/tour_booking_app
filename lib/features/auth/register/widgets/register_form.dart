import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/auth/register/widgets/register_view_model.dart';
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
  final _phoneNumberController = TextEditingController();

  bool _isPasswordObscure = true;
  bool _isConfirmObscure = true;
  // IntlPhoneField'dan gelen dinamik telefon objesi
  dynamic _selectedPhoneNumber;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  /// Formu doğrular ve API'ye gönderir.
  Future<void> _submit() async {
    // Tüm form alanlarının validasyonunu çalıştır
    if (!_formKey.currentState!.validate()) return;

    // Telefon numarası null veya boşsa submit'i engelle
    if (_selectedPhoneNumber == null || (_selectedPhoneNumber.number.isEmpty)) {
      UIHelper.showError(context, tr('phone_required'));
      return;
    }

    final vm = context.read<RegisterViewModel>();
    FocusScope.of(context).unfocus();

    // *******************************************************************
    // GÖNDERİM KISMI: IntlPhoneField objesinden verilerin ayrıştırılması
    // *******************************************************************
    final request = RegisterRequest(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      // 1. phoneNumber (Zorunlu) = Tam uluslararası format (Örn: +905551234567)
      // 2. nationalNumber (Opsiyonel) = Sadece ulusal numara (Örn: 5551234567)
      phoneNumber: _selectedPhoneNumber.completeNumber,
      // 3. countryCode (Opsiyonel) = Ülke kodu, '+' olmadan (Örn: 90)
      countryCode: _selectedPhoneNumber.countryCode,
      // Diğer opsiyonel alanlar, API ihtiyacına göre doldurulabilir:
      deviceId: null,
      deviceModel: null,
    );
    // *******************************************************************

    final result = await vm.register(request);

    if (!mounted) return;

    if (result.isSuccess) {
      UIHelper.showSuccess(context, tr("register_success"));
      context.go("/email-confirmed");
    } else {
      if (vm.message != null) {
        UIHelper.showError(context, vm.message!);
      }
    }
  }

  // Validasyonlar
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return tr("email_required");
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return tr("email_invalid");
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return tr("password_required");
    }

    final password = value.trim();

    // Minimum uzunluk kontrolü
    if (password.length < 9) {
      return tr("password_too_short");
    }

    // Regex kurallarımız
    final upper = RegExp(r'[A-Z]');
    final lower = RegExp(r'[a-z]');
    final digit = RegExp(r'\d');
    final special = RegExp(r'[^A-Za-z0-9]');

    // Hata listesi
    final errors = <String>[];

    if (!upper.hasMatch(password)) {
      errors.add(tr("password_must_include_upper")); // A–Z
    }

    if (!lower.hasMatch(password)) {
      errors.add(tr("password_must_include_lower")); // a–z
    }

    if (!digit.hasMatch(password)) {
      errors.add(tr("password_must_include_digit")); // 0–9
    }

    if (!special.hasMatch(password)) {
      errors.add(tr("password_must_include_special")); // ! @ # $ %
    }

    return errors.isEmpty ? null : errors.join("\n");
  }

  // Telefon numarası validasyonu
  String? _validatePhoneNumber(dynamic phoneNumber) {
    if (phoneNumber == null || phoneNumber.number.isEmpty) {
      return tr('phone_required');
    }

    if (phoneNumber.number.length < 7) {
      return tr('phone_too_short_generic');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    final primaryColor = Theme.of(context).primaryColor;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ad ve Soyad Yan Yana
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _firstNameController,
                  label: tr("first_name"),
                  icon: Icons.person_outline,
                  validator: (v) => v!.isEmpty ? tr("required") : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _lastNameController,
                  label: tr("last_name"),
                  icon: Icons.person_outline,
                  validator: (v) => v!.isEmpty ? tr("required") : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _emailController,
            label: tr("email"),
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),

          // IntlPhoneField - Telefon Alanı
          IntlPhoneField(
            controller: _phoneNumberController,
            decoration: _buildInputDecoration(
              label: tr('phone_number'),
              primaryColor: primaryColor,
            ),
            initialCountryCode: 'TR',
            dropdownIconPosition: IconPosition.trailing,
            flagsButtonPadding: const EdgeInsets.only(left: 10),
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),

            onChanged: (phone) {
              setState(() {
                // Burada IntlPhoneField'dan gelen PhoneData objesi _selectedPhoneNumber'a atanır
                _selectedPhoneNumber = phone;
              });
            },

            validator: (value) => _validatePhoneNumber(value),
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _passwordController,
            label: tr("password"),
            icon: Icons.lock_outline,
            isPassword: true,
            isObscure: _isPasswordObscure,
            onVisibilityToggle: () =>
                setState(() => _isPasswordObscure = !_isPasswordObscure),
            validator: _validatePassword,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _confirmPasswordController,
            label: tr("confirm_password"),
            icon: Icons.lock_outline,
            isPassword: true,
            isObscure: _isConfirmObscure,
            onVisibilityToggle: () =>
                setState(() => _isConfirmObscure = !_isConfirmObscure),
            validator: (val) {
              if (val != _passwordController.text)
                return tr("passwords_do_not_match");
              return null;
            },
          ),

          // Backend Hataları
          if (vm.validationErrors.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: vm.validationErrors
                    .map(
                      (e) => Text(
                        "• $e",
                        style: TextStyle(
                          color: Colors.red.shade800,
                          fontSize: 13,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Register Button
          ElevatedButton(
            onPressed: vm.isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: vm.isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    tr("register"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // TextFormField'lar için ortak widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onVisibilityToggle,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final primaryColor = Theme.of(context).primaryColor;

    return TextFormField(
      controller: controller,
      obscureText: isPassword ? isObscure : false,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: primaryColor,
      decoration: _buildInputDecoration(
        label: label,
        primaryColor: primaryColor,
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 22),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey[400],
                  size: 22,
                ),
                onPressed: onVisibilityToggle,
              )
            : null,
      ),
    );
  }

  // InputDecoration Stili
  InputDecoration _buildInputDecoration({
    required String label,
    required Color primaryColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade300, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    );
  }
}
