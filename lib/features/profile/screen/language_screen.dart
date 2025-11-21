import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final current = context.locale.languageCode;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Dil Ayarları"),
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          _languageTile(
            context,
            title: "Türkçe",
            locale: const Locale("tr"),
            selected: current == "tr",
          ),

          _languageTile(
            context,
            title: "English",
            locale: const Locale("en"),
            selected: current == "en",
          ),
        ],
      ),
    );
  }

  Widget _languageTile(
    BuildContext context, {
    required String title,
    required Locale locale,
    required bool selected,
  }) {
    return InkWell(
      onTap: () async {
        await context.setLocale(locale);
        context.read<HomeViewModel>().init();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Uygulama dili '${title}' olarak değiştirildi."),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).primaryColor,
                size: 22,
              )
            else
              Icon(
                Icons.circle_outlined,
                color: Colors.grey.shade500,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
