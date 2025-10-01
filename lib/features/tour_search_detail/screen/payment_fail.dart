import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentFailPage extends StatelessWidget {
  const PaymentFailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 100, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                "Ödeme Başarısız!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Ödemeniz alınamadı. Lütfen tekrar deneyin.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => context.go('/home'), // ana sayfa route
                child: const Text("Ana Sayfaya Dön"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
