import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';

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
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,

      appBar: CommonAppBar(title: tr("my_favorites"), showBack: false),

      body: vm.isLoading
          ? const FavoriteSkeleton()
          : vm.favorites.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border,
              title: tr("no_favorites_title"),
              subtitle: tr("no_favorites_subtitle"),
            )
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: vm.favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
              itemBuilder: (_, i) {
                final fav = vm.favorites[i];

                return FavoriteCard(
                  id: fav.id,
                  imageUrl: fav.mainImage,
                  title: fav.title,
                  city: fav.cityName,
                  isFavorite: true,

                  // FAVORİDEN ÇIKARMA
                  onFavoriteToggle: () async {
                    final removedTitle = fav.title;

                    vm.toggleFavorite(fav.id);

                    // Premium SnackBar

                    UIHelper.showWarning(
                      context,
                      tr("removed_from_favorites", args: [removedTitle]),
                    );
                  },

                  onTap: () {
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
}
