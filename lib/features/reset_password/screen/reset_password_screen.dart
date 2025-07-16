import 'package:flutter/material.dart';

// Bu standart bir StatelessWidget, özel bir annotation'a gerek yok.
class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final String token;

  // Constructor ile gerekli parametreleri alıyoruz.
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Şifre Belirle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('E-posta adresi: $email'),
            const SizedBox(height: 20),
            // ... Yeni Şifre ve Yeni Şifre Tekrar input'ları ...
            // ... "Şifreyi Güncelle" butonu ...
            // Bu butonun onPressed fonksiyonunda API'ye istek atacaksın.
            // İstek atarken `email`, `token` ve yeni şifre input'undaki değeri kullanacaksın.
          ],
        ),
      ),
    );
  }
}
