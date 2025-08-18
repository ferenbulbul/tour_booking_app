import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ödeme')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Butona basıldığında yapılacak işlem
            debugPrint("Ödeme tamamlandı");
          },
          child: const Text('Ödemeyi Tamamla', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
