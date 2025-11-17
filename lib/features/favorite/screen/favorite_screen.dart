import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/features/favorite/widget/favorite_card.dart';
import 'package:tour_booking/features/favorite/widget/favorite_sckeleton.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with RouteAware {
  @override
  void initState() {
    super.initState();

    // İlk yükleme
    Future.microtask(() {
      context.read<FavoriteViewModel>().fetchFavorites();
    });
  }

  // 🔥 Detay sayfasından dönülünce otomatik tekrar fetch
  @override
  void didPopNext() {
    context.read<FavoriteViewModel>().fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FavoriteViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      // 🔥 Premium AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          "Favorilerim",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      // 🔥 Gövde
      body: vm.isLoading
          ? FavoriteSkeleton()
          : vm.favorites.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: vm.favorites.length,
              itemBuilder: (_, i) {
                final fav = vm.favorites[i];

                return RepaintBoundary(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: FavoriteCard(
                      id: fav.id,
                      imageUrl: fav.mainImage,
                      title: fav.title,
                      city: fav.cityName,
                      isFavorite: true,

                      // 🔵 Kart tıklama → Detay
                      onTap: () => context.pushNamed(
                        'searchDetail',
                        extra: {"id": fav.id, "initialImage": fav.mainImage},
                      ),

                      // 🔴 Favoriyi kaldırma
                      onFavoriteToggle: () {
                        final removedItem = fav;
                        vm.removeFavoriteLocal(fav.id);
                        vm.removeFavorite(fav.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            content: Text(
                              "${fav.title} favorilerden kaldırıldı",
                              style: const TextStyle(color: Colors.white),
                            ),
                            action: SnackBarAction(
                              label: "Geri Al",
                              textColor: Colors.white,
                              onPressed: () {
                                vm.favorites.insert(i, removedItem);
                                vm.notifyListeners();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  // 🔥 Premium Empty State
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
              "Beğendiğiniz turları favorilere ekleyin \nkolayca erişin.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
