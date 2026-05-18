import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solar_icons/solar_icons.dart';

/// Centralized password validation logic used across auth screens.
class PasswordValidator {
  PasswordValidator._();

  static final _upper = RegExp(r'[A-Z]');
  static final _lower = RegExp(r'[a-z]');
  static final _digit = RegExp(r'\d');
  static final _special = RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]{};:"\\|,.<>\/\?]');

  static final _fullRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{9,}$',
  );

  /// Returns true if password meets all requirements.
  static bool isValid(String password) {
    return password.length >= 9 &&
        _upper.hasMatch(password) &&
        _lower.hasMatch(password) &&
        _digit.hasMatch(password) &&
        _special.hasMatch(password);
  }

  /// Returns true if password matches full regex (single-check variant).
  static bool matchesFullRegex(String password) => _fullRegex.hasMatch(password);

  /// Validates password and returns localization key(s) on error, null on success.
  /// Keys are NOT translated — caller must call .tr() if needed.
  static String? validate(String? value) {
    if (value == null || value.isEmpty) return 'password_required';

    final pwd = value.trim();
    if (pwd.length < 9) return 'password_too_short';

    final errors = <String>[
      if (!_upper.hasMatch(pwd)) 'password_must_include_upper',
      if (!_lower.hasMatch(pwd)) 'password_must_include_lower',
      if (!_digit.hasMatch(pwd)) 'password_must_include_digit',
      if (!_special.hasMatch(pwd)) 'password_must_include_special',
    ];

    return errors.isEmpty ? null : errors.join('\n');
  }

  /// Validates password and returns already-translated error messages.
  static String? validateTranslated(String? value) {
    if (value == null || value.isEmpty) return tr('password_required');
    if (value.length < 9) return tr('password_too_short');

    final errors = <String>[
      if (!_upper.hasMatch(value)) tr('password_must_include_upper'),
      if (!_lower.hasMatch(value)) tr('password_must_include_lower'),
      if (!_digit.hasMatch(value)) tr('password_must_include_digit'),
      if (!_special.hasMatch(value)) tr('password_must_include_special'),
    ];

    return errors.isEmpty ? null : errors.join('\n');
  }

  /// Input formatter that only allows valid password characters.
  static final passwordInputFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[A-Za-z0-9!@#\$%\^&\*\(\)_\+\-=\[\]{};:"\\|,.<>\/?]'),
  );
}

/// Visual password rules checklist widget.
class PasswordRules extends StatelessWidget {
  final String password;
  const PasswordRules({super.key, required this.password});

  Widget _item(bool ok, String text) {
    return Row(
      children: [
        Icon(
          ok ? SolarIconsOutline.checkCircle : SolarIconsOutline.closeCircle,
          size: 16,
          color: ok ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: ok ? Colors.green : Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _item(password.length >= 9, tr('password_too_short')),
        _item(RegExp(r'[A-Z]').hasMatch(password), tr('password_must_include_upper')),
        _item(RegExp(r'[a-z]').hasMatch(password), tr('password_must_include_lower')),
        _item(RegExp(r'\d').hasMatch(password), tr('password_must_include_digit')),
        _item(
          RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]{};:"\\|,.<>\/\?]').hasMatch(password),
          tr('password_must_include_special'),
        ),
      ],
    );
  }
}
