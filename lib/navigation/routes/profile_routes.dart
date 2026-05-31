import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/features/profile/screen/language_screen.dart';
import 'package:tour_booking/features/profile/screen/legal_detail_screen.dart';
import 'package:tour_booking/features/profile/screen/permission_screen.dart';
import 'package:tour_booking/features/profile/screen/personal_info_screen.dart';
import 'package:tour_booking/features/profile/screen/update_phone_screen.dart';

/// Profile and settings related routes.
List<RouteBase> profileRoutes() => [
      GoRoute(
        path: '/settings/language',
        builder: (context, state) => const LanguageSettingsScreen(),
      ),
      GoRoute(
        path: '/update-phone',
        builder: (context, state) => const UpdatePhoneScreen(),
      ),
      GoRoute(
        path: '/personal-info',
        builder: (context, state) => const PersonalInfoScreen(),
      ),
      GoRoute(
        path: '/settings/permissions',
        name: 'permissionsSettings',
        builder: (context, state) => const PermissionsScreen(),
      ),
      GoRoute(
        path: '/legal/:type',
        name: 'legalDetail',
        builder: (context, state) {
          final type = state.pathParameters['type'] ?? '';
          late final String title;
          late final String content;
          switch (type) {
            case 'privacy-policy':
              title = tr('privacy_policy');
              content = tr('legal_privacy_policy_content');
              break;
            case 'kvkk':
              title = tr('kvkk_text');
              content = tr('legal_kvkk_content');
              break;
            case 'sales-agreement':
              title = tr('sales_agreement');
              content = tr('legal_sales_agreement_content');
              break;
            default:
              title = '';
              content = '';
          }
          return LegalDetailScreen(title: title, content: content);
        },
      ),
    ];
