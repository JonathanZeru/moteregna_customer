import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapMarkers extends StatelessWidget {
  final LatLng? startLocation;
  final LatLng? currentLocation;
  final LatLng? endLocation;
  final bool isDark;

  const MapMarkers({
    Key? key,
    this.startLocation,
    this.currentLocation,
    this.endLocation,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        if (startLocation != null)
          Marker(
            point: startLocation!,
            width: 40,
            height: 40,
            child: Icon(
              Icons.location_on,
              color: Colors.blue,
              size: 40,
            ),
          ),
        if (currentLocation != null)
          Marker(
            point: currentLocation!,
            width: 40,
            height: 40,
            child: Icon(
              Icons.my_location,
              color: Colors.green,
              size: 40,
            ),
          ),
        if (endLocation != null)
          Marker(
            point: endLocation!,
            width: 40,
            height: 40,
            child: Icon(
              Icons.flag,
              color: Colors.red,
              size: 40,
            ),
          ),
      ],
    );
  }
}
