import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/navigation/app_router.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with RouteAware {
  @override
  void initState() {
    super.initState();
    // İlk açılışta favorileri çek
    Future.microtask(() {
      print("FavoritePage: initState - fetchFavorites çağırılıyor");
      context.read<FavoriteViewModel>().fetchFavorites();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // RouteObserver'a abone ol
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      print("FavoritePage: globalRouteObserver'a abone olunuyor");
      globalRouteObserver.subscribe(this, modalRoute);
    } else {
      print("FavoritePage: ModalRoute PageRoute değil, abonelik atlandı");
    }
  }

  @override
  void dispose() {
    // RouteObserver'dan çık
    print("FavoritePage: globalRouteObserver'dan çıkılıyor");
    globalRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Sayfaya geri dönüldüğünde çağrılır
    print("FavoritePage: didPopNext tetiklendi, favoriler çekiliyor");
    context.read<FavoriteViewModel>().fetchFavorites();
  }

  @override
  void didPush() {
    print("FavoritePage: didPush tetiklendi");
    super.didPush();
  }

  @override
  void didPop() {
    print("FavoritePage: didPop tetiklendi");
    super.didPop();
  }

  @override
  void didPushNext() {
    print("FavoritePage: didPushNext tetiklendi");
    super.didPushNext();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FavoriteViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorilerim")),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.favorites.isEmpty
          ? const Center(
              child: Text(
                "Henüz favoriniz yok.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vm.favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final fav = vm.favorites[index];
                return InkWell(
                  onTap: () async {
                    print("searchDetail sayfasına gidiliyor, ID: ${fav.id}");
                    // searchDetail sayfasına git ve geri dönüşü bekle
                    await context.pushNamed(
                      'searchDetail',
                      extra: fav.id.toString(),
                    );
                    // Geri dönüldüğünde favorileri tekrar çek
                    print(
                      "FavoritePage: searchDetail'den geri dönüldü, favoriler çekiliyor",
                    );
                    context.read<FavoriteViewModel>().fetchFavorites();
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    clipBehavior: Clip.antiAlias,
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: fav.mainImage.isNotEmpty
                              ? fav.mainImage
                              : "https://via.placeholder.com/120",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey.shade200),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fav.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${fav.cityName} • ${fav.tourTypeName}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            weight: 90,
                          ),
                          onPressed: () {
                            final favId = fav.id;
                            final favTitle = fav.title;

                            context
                                .read<FavoriteViewModel>()
                                .removeFavoriteLocal(favId);

                            // 2. Backend isteği gönder
                            context.read<FavoriteViewModel>().removeFavorite(
                              favId,
                            );

                            // 3. Kullanıcıya bilgi ver
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "$favTitle favorilerden kaldırıldı",
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
