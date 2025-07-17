import 'package:flutter/material.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'Doğa', 'description': 'Açıklama 1'},
      {'title': 'Tarih', 'description': 'Açıklama 2'},
      {'title': 'Fotoğrafçılık', 'description': 'Açıklama 3'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Kategoriler',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Tümünü Gör', style: TextStyle(color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: categories
              .map(
                (category) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCategoryCard(
                    category['title']!,
                    category['description']!,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // SOLDa logo
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          // SAĞDA başlık + açıklama
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
