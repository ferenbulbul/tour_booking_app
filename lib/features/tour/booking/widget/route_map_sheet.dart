import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/models/tour_detail_sub_items/tour_detail_sub_items.dart';

class RouteMapSheet extends StatefulWidget {
  final List<RoutePointItem> points;

  const RouteMapSheet({super.key, required this.points});

  @override
  State<RouteMapSheet> createState() => _RouteMapSheetState();
}

class _RouteMapSheetState extends State<RouteMapSheet> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  int _selectedIndex = 0;
  late PageController _pageController;
  bool _isPageAnimating = false;

  // Normal + selected icon cache (instance-level)
  final Map<int, BitmapDescriptor> _normalIcons = {};
  final Map<int, BitmapDescriptor> _selectedIcons = {};

  // Static cache to avoid regenerating icons across page visits
  static final Map<String, BitmapDescriptor> _globalIconCache = {};


  List<RoutePointItem> get _validPoints =>
      widget.points.where((p) => p.latitude != 0 && p.longitude != 0).toList();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.80);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _buildIcons();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mapController = null;
    super.dispose();
  }

  Color _pointColor(int pointType) {
    switch (pointType) {
      case 0:
        return context.colors.secondary;
      case 1:
        return context.ext.info;
      default:
        return context.ext.textLight;
    }
  }

  String _pointLabel(int pointType) {
    switch (pointType) {
      case 0:
        return tr("route_point_start");
      case 1:
        return tr("route_point_stop");
      default:
        return tr("route_point_pass");
    }
  }

  // -- Icon generation --

  Future<void> _buildIcons() async {
    final pts = _validPoints;

    // Build all icons in parallel using Future.wait
    final futures = <Future<void>>[];
    for (int i = 0; i < pts.length; i++) {
      final color = _pointColor(pts[i].pointType);
      futures.add(_buildIconPair(i, color));
    }
    await Future.wait(futures);

    if (mounted) _rebuildMarkers();
  }

  Future<void> _buildIconPair(int index, Color color) async {
    _normalIcons[index] = await _createPinMarker(index + 1, color, false);
    _selectedIcons[index] = await _createPinMarker(index + 1, color, true);
  }

  Future<BitmapDescriptor> _createPinMarker(
    int number,
    Color color,
    bool isSelected,
  ) async {
    // Check static cache first
    final cacheKey = '${color.toARGB32()}_${number}_$isSelected';
    final cached = _globalIconCache[cacheKey];
    if (cached != null) return cached;

    final double scale = isSelected ? 1.4 : 1.0;
    final double w = 80 * scale;
    final double h = 100 * scale;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final pinPath = Path();
    final cx = w / 2;
    final circleR = w / 2 - 4 * scale;
    final circleY = w / 2;

    // Top circle
    pinPath.addOval(
      Rect.fromCircle(center: Offset(cx, circleY), radius: circleR),
    );

    // Bottom pointed tip
    pinPath.moveTo(cx - circleR * 0.55, circleY + circleR * 0.75);
    pinPath.quadraticBezierTo(cx, h - 2 * scale, cx, h - 2 * scale);
    pinPath.quadraticBezierTo(
      cx, h - 2 * scale, cx + circleR * 0.55, circleY + circleR * 0.75,
    );
    pinPath.close();

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: isSelected ? 0.25 : 0.15)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, isSelected ? 5 : 3);
    canvas.save();
    canvas.translate(0, 2 * scale);
    canvas.drawPath(pinPath, shadowPaint);
    canvas.restore();

    // Pin fill
    canvas.drawPath(pinPath, Paint()..color = color);

    // Selected -> white outer ring
    if (isSelected) {
      final ringPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(Offset(cx, circleY), circleR, ringPaint);
    }

    // White inner circle
    final innerR = circleR - 6 * scale;
    canvas.drawCircle(Offset(cx, circleY), innerR, Paint()..color = Colors.white);

    // Number
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$number',
        style: TextStyle(
          color: color,
          fontSize: 32 * scale,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((w - textPainter.width) / 2, circleY - textPainter.height / 2),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(w.toInt(), h.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    final descriptor = BitmapDescriptor.bytes(
      bytes,
      width: isSelected ? 50 : 36,
      height: isSelected ? 62 : 45,
    );
    _globalIconCache[cacheKey] = descriptor;
    return descriptor;
  }

  // -- Marker management --

  void _rebuildMarkers() {
    final pts = _validPoints;
    final markers = <Marker>{};

    for (int i = 0; i < pts.length; i++) {
      final p = pts[i];
      final isSelected = i == _selectedIndex;
      final icon = isSelected
          ? (_selectedIcons[i] ?? _normalIcons[i])
          : _normalIcons[i];
      if (icon == null) continue;

      markers.add(Marker(
        markerId: MarkerId('${p.orderIndex}_${p.name}'),
        position: LatLng(p.latitude, p.longitude),
        icon: icon,
        anchor: const Offset(0.5, 1.0),
        zIndexInt: isSelected ? 1 : 0,
        onTap: () => _onMarkerTap(i),
      ));
    }

    setState(() => _markers = markers);
  }

  // -- Selection / navigation --

  void _onMarkerTap(int index) {
    if (_selectedIndex == index) return;

    _isPageAnimating = true;
    setState(() => _selectedIndex = index);
    _rebuildMarkers();

    _pageController
        .animateToPage(
          index,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        )
        .then((_) => _isPageAnimating = false);

    _animateToPoint(index);
  }

  void _onPageChanged(int index) {
    if (_isPageAnimating) return;
    setState(() => _selectedIndex = index);
    _rebuildMarkers();
    _animateToPoint(index);
  }

  /// Gently focus on the selected point.
  void _animateToPoint(int index) {
    final ctrl = _mapController;
    if (ctrl == null || !mounted) return;

    final pts = _validPoints;
    if (index < 0 || index >= pts.length) return;

    final target = LatLng(pts[index].latitude, pts[index].longitude);

    try {
      ctrl.animateCamera(
        CameraUpdate.newLatLngZoom(target, 16),
      );
    } catch (e) {
      debugPrint('_RouteMapSheetState._animateToPoint: $e');
    }
  }

  // -- Build --

  @override
  Widget build(BuildContext context) {
    final pts = _validPoints;

    if (pts.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: Center(child: Text(tr("route_point_not_found"))),
      );
    }

    final polylinePoints =
        pts.map((p) => LatLng(p.latitude, p.longitude)).toList();

    final firstPoint = pts.first;
    final bottomPad = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // MAP
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(firstPoint.latitude, firstPoint.longitude),
              zoom: 12,
            ),
            markers: _markers,
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: polylinePoints,
                color: context.colors.secondary,
                width: 3,
                patterns: [
                  PatternItem.dash(12),
                  PatternItem.gap(8),
                ],
              ),
            },
            onMapCreated: (ctrl) {
              _mapController = ctrl;
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) _animateToPoint(0);
              });
            },
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            padding: EdgeInsets.only(bottom: bottomPad + 130),
          ),

          // BOTTOM CARD LIST — horizontal scroll
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomPad + 12,
            height: 116,
            child: PageView.builder(
              controller: _pageController,
              itemCount: pts.length,
              clipBehavior: Clip.none,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final isActive = index == _selectedIndex;

                return AnimatedPadding(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(top: isActive ? 0 : AppSpacing.ml),
                  child: AnimatedScale(
                    scale: isActive ? 1.0 : 0.95,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: AnimatedOpacity(
                      opacity: isActive ? 1.0 : 0.6,
                      duration: const Duration(milliseconds: 250),
                      child: _buildPointCard(pts[index], index + 1),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointCard(RoutePointItem point, int number) {
    final color = _pointColor(point.pointType);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.ml),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Numbered circle
          Container(
            width: AppIconSize.xxxl,
            height: AppIconSize.xxxl,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '$number',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          // Name + type + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  point.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _pointLabel(point.pointType),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (point.description != null &&
                    point.description!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    point.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: context.colors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        tooltip: 'Back',
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios_new_rounded, size: AppIconSize.l, semanticLabel: 'Go back'),
        color: context.colors.onSurface,
      ),
      title: Text(
        tr("route_title"),
        style: AppTextStyles.titleSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colors.onSurface,
        ),
      ),
      centerTitle: true,
    );
  }
}
