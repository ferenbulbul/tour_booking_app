import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/auth/login/widgets/login_view_model.dart';
import 'package:tour_booking/features/auth/login/widgets/social_login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ferah, açık gri bir arka plan rengi
      backgroundColor: const Color(0xFFF8F9FA),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo veya Başlık Alanı (Koyu renk metinlerle)
                const _CleanHeader(),
                const SizedBox(height: 40),

                // Beyaz, gölgeli modern kart tasarımı
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    // Premium hissettiren yumuşak gölge (Soft Shadow)
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const _CleanLoginForm(),
                ),

                const SizedBox(height: 30),

                // Sosyal Medya Girişi
                Text(
                  "Or continue with",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                const SocialLoginButtons(),

                const SizedBox(height: 30),

                // Kayıt Ol Alanı
                const _RegisterPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- HEADER WIDGET ---
class _CleanHeader extends StatelessWidget {
  const _CleanHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // İkon için tema rengini veya koyu bir renk kullanıyoruz
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.travel_explore,
            size: 48,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'welcome_title'.tr(),
          style: AppTextStyles.headlineSmall.copyWith(
            color: Colors.black87, // Koyu metin
            fontWeight: FontWeight.w800,
            fontSize: 28,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'welcome_subtitle'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.grey[600], // Gri alt metin
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// --- LOGIN FORM & LOGIC ---
class _CleanLoginForm extends StatefulWidget {
  const _CleanLoginForm();

  @override
  State<_CleanLoginForm> createState() => _CleanLoginFormState();
}

class _CleanLoginFormState extends State<_CleanLoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  void _login() async {
    final vm = Provider.of<LoginViewModel>(context, listen: false);
    FocusScope.of(context).unfocus();

    final result = await vm.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (result.isSuccess) {
      final roleString = result.data?.role;
      final role = UserRoleExtension.fromString(roleString);
      final data = result.data!;
      final bool emailConfirmed = data.emailConfirmed == true;
      final bool isFirstLogin = data.isFirstLogin == true;

      if (role == UserRole.driver) {
        if (isFirstLogin) {
          context.go('/change-password-driver');
        } else {
          context.go('/driver');
        }
      } else {
        if (!emailConfirmed) {
          context.go('/email-confirmed');
        } else {
          context.go('/home');
        }
      }
    } else {
      if (vm.message != null) {
        UIHelper.showError(context, vm.message!);
      }
      if (vm.validationErrors.isNotEmpty) {
        UIHelper.showValidationErrors(context, vm.validationErrors);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<LoginViewModel>().isLoading;
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // EMAIL INPUT
        _buildTextField(
          controller: _emailController,
          label: 'email'.tr(),
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),

        // PASSWORD INPUT
        _buildTextField(
          controller: _passwordController,
          label: 'password'.tr(),
          icon: Icons.lock_outline,
          isPassword: true,
          isObscure: _isObscure,
          onVisibilityToggle: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),

        // FORGOT PASSWORD
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push('/forgot-password'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
              padding: const EdgeInsets.only(right: 0, top: 8, bottom: 8),
            ),
            child: Text(
              'forgot_password'.tr(),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // LOGIN BUTTON
        ElevatedButton(
          onPressed: isLoading ? null : _login,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            elevation: 0, // Düz buton (Flat design)
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'login'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onVisibilityToggle,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? isObscure : false,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
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
        filled: true,
        fillColor: const Color(0xFFF3F4F6), // Çok açık gri input zemini
        // Kenarlıklar kaldırıldı, sadece zemin rengi ve radius
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
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
      ),
    );
  }
}

// --- REGISTER PROMPT ---
class _RegisterPrompt extends StatelessWidget {
  const _RegisterPrompt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'dont_have_account'.tr(),
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => context.push('/register'),
          child: Text(
            'create_account'.tr(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
