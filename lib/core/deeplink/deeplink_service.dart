import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<void> init(BuildContext context) async {
    // 1️⃣ App kapalıyken link ile açıldıysa
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handle(context, initialUri);
    }

    // 2️⃣ App açıkken link gelirse
    _sub = _appLinks.uriLinkStream.listen((uri) {
      _handle(context, uri);
    });
  }

  void dispose() {
    _sub?.cancel();
  }

  void _handle(BuildContext context, Uri uri) {
    // Beklenen format:
    // https://tourbooking.app/tour/123
    if (uri.pathSegments.isEmpty) return;

    if (uri.pathSegments.first == 'tour' && uri.pathSegments.length >= 2) {
      final id = uri.pathSegments[1];
      context.go('/tour/$id');
    }
  }
}
