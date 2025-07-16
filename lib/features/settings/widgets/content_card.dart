import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  // Bu kartın içine yerleştirilecek olan widget'ı dışarıdan alıyoruz.
  final Widget child;

  const ContentCard({
    super.key,
    required this.child, // 'child' parametresini zorunlu kılıyoruz.
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      // Dışarıdan gelen 'child' widget'ını buraya yerleştiriyoruz.
      // Bu sayede kartın içi tamamen dinamik hale geliyor.
      child: child,
    );
  }
}
