import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/transport/screen/transport_vehicle_list_screen.dart';
import 'package:tour_booking/features/transport/screen/transport_summary_screen.dart';
import 'package:tour_booking/features/transport/transport_vehicle_list_viewmodel.dart';
import 'package:tour_booking/features/transport/transport_summary_viewmodel.dart';
import 'package:tour_booking/models/transport/search_vehicles_request/search_vehicles_request.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';

/// Transport-related routes.
List<RouteBase> transportRoutes() => [
      GoRoute(
        path: '/transport-vehicles',
        name: 'transportVehicles',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final request = TransportSearchVehiclesRequest.fromJson(
            args['request'] as Map<String, dynamic>,
          );
          return ChangeNotifierProvider(
            create: (_) => TransportVehicleListViewModel()
              ..searchVehicles(request),
            child: TransportVehicleListScreen(searchContext: args),
          );
        },
      ),
      GoRoute(
        path: '/transport-summary',
        name: 'transportSummary',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final vehicle = args['vehicle'] as TransportVehicle;
          return ChangeNotifierProvider(
            create: (_) => TransportSummaryViewModel()
              ..setContext(
                vehicle: vehicle,
                pickup: args['pickupAddress'] as String?,
                pLat: args['pickupLat'] as double?,
                pLng: args['pickupLng'] as double?,
                dropoff: args['dropoffAddress'] as String?,
                dLat: args['dropoffLat'] as double?,
                dLng: args['dropoffLng'] as double?,
                date: args['date'] != null
                    ? DateTime.parse(args['date'] as String)
                    : null,
                time: args['time'] as String?,
                distanceKm: args['clientDistanceKm'] as double?,
                durationMinutes: args['clientDurationMinutes'] as int?,
                routePolyline: args['routePolyline'] as String?,
              ),
            child: const TransportSummaryScreen(),
          );
        },
      ),
    ];
