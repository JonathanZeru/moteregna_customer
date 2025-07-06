import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';

class MapControls extends StatelessWidget {
  final double mapZoom;
  final LatLng? currentLocation;
  final Function(double) onZoomIn;
  final Function(double) onZoomOut;
  final Function() onCenterMap;

  const MapControls({
    super.key,
    required this.mapZoom,
    required this.currentLocation,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCenterMap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 120,
      right: 20,
      child: Column(
        children: [
          _buildMapControlButton(
            context,
            FontAwesomeIcons.plus,
            () {
              onZoomIn(mapZoom + 1);
            },
            tooltip: "Zoom in to see closer",
          ),
          const SizedBox(height: 10),
          _buildMapControlButton(
            context,
            FontAwesomeIcons.minus,
            () {
              onZoomOut(mapZoom - 1);
            },
            tooltip: "Zoom out to see more area",
          ),
          const SizedBox(height: 10),
          _buildMapControlButton(
            context,
            FontAwesomeIcons.locationCrosshairs,
            onCenterMap,
            tooltip: "Center map on your location",
          ),
        ],
      ),
    );
  }

  Widget _buildMapControlButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed, {
    String? tooltip,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Tooltip(
      message: tooltip ?? "Map control",
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(isDark ? 0.3 : 0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}