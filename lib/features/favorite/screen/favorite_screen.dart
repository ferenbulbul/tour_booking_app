import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/features/favorite/widget/favorite_card.dart';
import 'package:tour_booking/features/favorite/widget/favorite_skeleton.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with RouteAware {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FavoriteViewModel>().fetchFavorites();
    });
  }

  @override
  void didPopNext() {
    context.read<FavoriteViewModel>().fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FavoriteViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: const CommonAppBar(title: "Favorilerim"),

      body: vm.isLoading
          ? FavoriteSkeleton()
          : vm.favorites.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: vm.favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) {
                final fav = vm.favorites[i];

                return FavoriteCard(
                  id: fav.id,
                  imageUrl: fav.mainImage,
                  title: fav.title,
                  city: fav.cityName,
                  isFavorite: true,

                  /// 🔥 Kalbe basınca favoriden çıkar
                  onFavoriteToggle: () async {
                    final removedTitle = fav.title;

                    // 🔥 Local olarak hemen kaldır
                    vm.removeFavoriteLocal(fav.id);

                    // 🔥 API isteği
                    vm.removeFavorite(fav.id);

                    // 🔥 Premium mini toast
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$removedTitle favorilerden kaldırıldı"),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.black87,
                        margin: const EdgeInsets.all(16),
                        duration: const Duration(seconds: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },

                  /// 🔥 Detaya git
                  onTap: () {
                    print("favorite main image ${fav.mainImage}");
                    context.pushNamed(
                      'searchDetail',
                      extra: {"id": fav.id, "initialImage": fav.mainImage},
                    );
                  },
                );
              },
            ),
    );
  }

  // 🟣 Premium Empty State
  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.black26),
            SizedBox(height: 12),
            Text(
              "Henüz favoriniz yok",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Beğendiğiniz turları favorilere ekleyin,\nkolayca erişin.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
