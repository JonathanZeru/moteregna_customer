import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RoutePolyline extends StatelessWidget {
  final List<LatLng> routePoints;
  final bool isDark;

  const RoutePolyline({
    required this.routePoints,
    required this.isDark,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PolylineLayer(
      polylines: [
        Polyline(
          points: routePoints,
          color: theme.colorScheme.primary.withOpacity(0.7),
          strokeWidth: 6.0,
          borderColor: theme.colorScheme.primary.withOpacity(0.3),
          borderStrokeWidth: isDark ? 10.0 : 4.0,
        ),
      ],
    );
  }
}