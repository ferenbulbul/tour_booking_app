import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FakeSearchBar extends StatelessWidget {
  const FakeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Basınca tam ekran SearchLocationPage'e gitsin
        context.push('/search-location');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.black54),
            const SizedBox(width: 8),
            const Text(
              "Yer adı yaz (örn: Ayder)",
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
