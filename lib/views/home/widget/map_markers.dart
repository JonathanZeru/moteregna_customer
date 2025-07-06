import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

class MapMarkers extends StatelessWidget {
  final LatLng? startLocation;
  final LatLng? currentLocation;
  final LatLng? endLocation;
  final AnimationController pulseController;
  final bool isDark;

  const MapMarkers({
    required this.startLocation,
    required this.currentLocation,
    required this.endLocation,
    required this.pulseController,
    required this.isDark,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MarkerLayer(
      markers: [
        if (startLocation != null)
          Marker(
            point: startLocation!,
            width: 50,
            height: 50,
            child: _buildStartMarker(theme),
          ),
        if (currentLocation != null)
          Marker(
            point: currentLocation!,
            width: 70,
            height: 70,
            child: _buildCurrentLocationMarker(theme),
          ),
        if (endLocation != null)
          Marker(
            point: endLocation!,
            width: 50,
            height: 50,
            child: _buildEndMarker(theme),
          ),
      ],
    );
  }

  Widget _buildStartMarker(ThemeData theme) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: theme.colorScheme.tertiary.withOpacity(
                        0.5 + 0.3 * pulseController.value,
                      ),
                      blurRadius: 20 * pulseController.value,
                      spreadRadius: 5 * pulseController.value,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: theme.colorScheme.tertiary.withOpacity(
                        0.3 + 0.1 * pulseController.value,
                      ),
                      blurRadius: 10 * pulseController.value,
                      spreadRadius: 2 * pulseController.value,
                    ),
                  ],
          ),
          child: child,
        );
      },
      child: Tooltip(
        message: "Starting point of your delivery",
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiary,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: const Icon(
            FontAwesomeIcons.play,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentLocationMarker(ThemeData theme) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse
            Container(
              width: 70 * (0.7 + 0.3 * pulseController.value),
              height: 70 * (0.7 + 0.3 * pulseController.value),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withOpacity(
                  isDark
                      ? 0.2 * (1 - pulseController.value)
                      : 0.1 * (1 - pulseController.value),
                ),
              ),
            ),
            // Middle pulse
            Container(
              width: 50 * (0.8 + 0.2 * pulseController.value),
              height: 50 * (0.8 + 0.2 * pulseController.value),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withOpacity(
                  isDark
                      ? 0.3 * (1 - pulseController.value)
                      : 0.2 * (1 - pulseController.value),
                ),
              ),
            ),
            // Inner circle with icon
            Tooltip(
              message: "Your current location",
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary,
                  boxShadow: isDark
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.8),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.4),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                ),
                child: const Icon(
                  FontAwesomeIcons.motorcycle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEndMarker(ThemeData theme) {
    return Tooltip(
      message: "Delivery destination",
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.secondary,
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: theme.colorScheme.secondary.withOpacity(0.8),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: theme.colorScheme.secondary.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: const Icon(
          FontAwesomeIcons.flagCheckered,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}