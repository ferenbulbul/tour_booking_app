import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/home/detail_search_viewmodel.dart';
import 'package:tour_booking/features/home/screen/detail_search.dart';
import 'package:tour_booking/features/home/screen/home_screen.dart';
import 'package:tour_booking/features/home/screen/nearby_tourpoint.dart';
import 'package:tour_booking/features/home/screen/tour_search_by_tour_type.dart';
import 'package:tour_booking/features/home/screen/all_featured_screen.dart';
import 'package:tour_booking/features/tour/booking/payment_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/place_picker_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/screen/guides_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/payment_fail_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/payment_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/payment_success_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/place_picker_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/summary_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/tour_search_detail_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/vehicle_detail_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/vehicle_list_screen.dart';
import 'package:tour_booking/features/tour/search/screen/search.dart';
import 'package:tour_booking/features/tour/search_result/screen/tour_search_result.dart';
import 'package:tour_booking/models/vehicle_detail_request/vehicle_detail_request.dart';

/// Tour booking and search related routes.
List<RouteBase> tourRoutes() => [
      GoRoute(
        path: '/all-featured',
        name: 'allFeatured',
        builder: (context, state) => const AllFeaturedScreen(),
      ),
      GoRoute(
        path: '/search-results',
        name: 'searchResults',
        builder: (context, state) {
          final qp = state.uri.queryParameters;
          final type = int.tryParse(qp['type'] ?? '0') ?? 0;

          return TourSearchResultsScreen(
            type: type,
            regionId: qp['regionId'],
            cityId: qp['cityId'],
            districtId: qp['districtId'],
            regionName: qp['regionName'],
            cityName: qp['cityName'],
            districtName: qp['districtName'],
          );
        },
      ),
      GoRoute(
        path: '/search-detail',
        name: 'searchDetail',
        pageBuilder: (context, state) {
          final data = state.extra;

          late final String tourPointId;
          String? initialImage;
          String? heroTag;

          if (data is String) {
            tourPointId = data;
          } else if (data is Map<String, dynamic>) {
            tourPointId = data["id"] as String;
            initialImage = data["initialImage"] as String?;
            heroTag = data["heroTag"] as String?;
          } else {
            return MaterialPage(key: state.pageKey, child: const HomeScreen());
          }

          return MaterialPage(
            key: ValueKey('searchDetail_$tourPointId'),
            child: TourSearchDetailScreen(
              tourPointId: tourPointId,
              initialImage: initialImage,
              heroTag: heroTag,
            ),
          );
        },
      ),
      GoRoute(
        path: '/tour/:id',
        name: 'tourDetailDeepLink',
        pageBuilder: (context, state) {
          final tourPointId = state.pathParameters['id']!;
          return MaterialPage(
            key: ValueKey('tourDetail_$tourPointId'),
            child: TourSearchDetailScreen(tourPointId: tourPointId),
          );
        },
      ),
      GoRoute(
        path: '/vehicle-list',
        name: 'vehicleList',
        builder: (context, state) {
          return TourVehicleListScreen();
        },
      ),
      GoRoute(
        path: '/vehicle-detail',
        name: 'vehicleDetail',
        builder: (context, state) {
          final args = state.extra;
          if (args is! VehicleDetailRequest) {
            return const TourSearchDetailScreen(tourPointId: '');
          }
          return VehicleDetailScreen(args: args);
        },
      ),
      GoRoute(
        path: '/search-guide',
        name: 'searchGuide',
        builder: (context, state) {
          return GuidesScreen();
        },
      ),
      GoRoute(
        path: '/summary',
        name: 'summary',
        builder: (context, state) {
          return SummaryScreen();
        },
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) {
          final rawBookingId = state.extra;
          final bookingId = rawBookingId is String ? rawBookingId : '';
          if (bookingId.isEmpty) return const HomeScreen();
          return ChangeNotifierProvider(
            create: (_) => PaymentViewModel(),
            child: PaymentScreen(bookingId: bookingId),
          );
        },
      ),
      GoRoute(
        name: 'placePicker',
        path: '/place-picker',
        builder: (context, state) {
          final params = state.extra is Map
              ? Map<String, dynamic>.from(state.extra as Map)
              : <String, dynamic>{};

          final city = params['city'] as String? ?? '';
          final district = params['district'] as String? ?? '';

          return ChangeNotifierProvider(
            create: (_) => PlacePickerViewModel(city: city, district: district),
            child: PlacePickerScreen(city: city, district: district),
          );
        },
      ),
      GoRoute(
        path: '/search-location',
        name: 'searchLocation',
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => DetailSearchViewModel(),
            child: const DetailSearchScreen(),
          );
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const TourSearchScreen(),
      ),
      GoRoute(
        name: "nearbyPoints",
        path: "/nearby-points",
        builder: (context, state) => const NearbyPointsScreen(),
      ),
      GoRoute(
        path: '/tour-search-by-type',
        name: 'tourSearchByType',
        builder: (context, state) {
          final qp = state.uri.queryParameters;
          return TourSearchResultsByTourTypeScreen(
            tourTypeId: qp['tourTypeId'],
            tourTypeName: qp['tourTypeName'],
          );
        },
      ),
      GoRoute(
        path: '/payment-success',
        builder: (context, state) {
          final conversationId =
              state.extra is String ? state.extra as String : '';
          return PaymentSuccessScreen(conversationId: conversationId);
        },
      ),
      GoRoute(
        path: '/payment-fail',
        builder: (context, state) => const PaymentFailScreen(),
      ),
    ];
