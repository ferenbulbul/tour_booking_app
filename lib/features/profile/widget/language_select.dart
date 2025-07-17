import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LanguageButton(
          label: '🇹🇷 Türkçe',
          locale: const Locale('tr'),
          isSelected: currentLocale.languageCode == 'tr',
        ),
        const SizedBox(width: 16),
        _LanguageButton(
          label: '🇺🇸 English',
          locale: const Locale('en'),
          isSelected: currentLocale.languageCode == 'en',
        ),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final Locale locale;
  final bool isSelected;

  const _LanguageButton({
    required this.label,
    required this.locale,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        await context.setLocale(locale);
        context.go('/home');
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? Theme.of(context).primaryColor : null,
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      child: Text(label),
    );
  }
}
