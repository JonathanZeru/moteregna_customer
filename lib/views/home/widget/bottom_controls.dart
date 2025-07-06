import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'animated_button.dart';

class BottomControls extends StatelessWidget {
  final bool isDark;
  final LatLng? startLocation;
  final bool isLoading;
  final VoidCallback showPhoneNumberDialog;
  final VoidCallback finishRide;

  const BottomControls({
    required this.isDark,
    required this.startLocation,
    required this.isLoading,
    required this.showPhoneNumberDialog,
    required this.finishRide,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedButton(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 60,
          isActive: startLocation != null,
          isLoading: isLoading,
          onPressed: isLoading
              ? null
              : (startLocation == null ? showPhoneNumberDialog : finishRide),
          startText: "start_delivery".tr,
          stopText: "finish_delivery".tr,
          startIcon: FontAwesomeIcons.play,
          stopIcon: FontAwesomeIcons.stop,
          startColor: Theme.of(context).colorScheme.tertiary,
          stopColor: Theme.of(context).colorScheme.secondary,
          isDark: isDark,
        ),
      ),
    );
  }
}