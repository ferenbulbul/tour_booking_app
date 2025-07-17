import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LocalizationSetup {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
  }

  static EasyLocalization wrapWithLocalization(Widget child) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: child,
    );
  }
}
