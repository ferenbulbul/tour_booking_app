import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<void> init(BuildContext context) async {
    // App was opened via link while closed
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null && context.mounted) {
      _handle(context, initialUri);
    }

    // Link received while app is open
    _sub = _appLinks.uriLinkStream.listen((uri) {
      _handle(context, uri);
    });
  }

  void dispose() {
    _sub?.cancel();
  }

  void _handle(BuildContext context, Uri uri) {
    // Expected format:
    // https://tourbooking.app/tour/123
    if (uri.pathSegments.isEmpty) return;

    if (uri.pathSegments.first == 'tour' && uri.pathSegments.length >= 2) {
      final id = uri.pathSegments[1];
      context.go('/tour/$id');
    }
  }
}
