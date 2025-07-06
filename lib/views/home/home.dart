import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gibe_market/controllers/package_controller.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/views/home/widget/cyber_card.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';
import 'package:latlong2/latlong.dart';

class CreatePackageScreen extends StatelessWidget {
  final PackageController controller = Get.put(PackageController());
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[50]!,
              Colors.white,
              Colors.grey[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(theme),
              Expanded(
                child: _buildContent(context, theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            NeonText(
              text: 'CREATE PACKAGE',
              color: theme.primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Send your package to the future',
              style: TextStyle(
                color: theme.primaryColor.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return AnimationLimiter(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 600),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            _buildPackageDetailsForm(theme),
            const SizedBox(height: 20),
            _buildLocationSection(theme),
            const SizedBox(height: 20),
            _buildMapSection(context, theme),
            const SizedBox(height: 20),
            _buildSubmitButton(theme, context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageDetailsForm(ThemeData theme) {
    return CyberCard(
      isDark: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeonText(
            text: 'PACKAGE DETAILS',
            color: theme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          _buildFuturisticTextField(
            controller: controller.descriptionController,
            label: 'Package Description',
            icon: Icons.description,
            hint: 'What are you sending?',
            theme: theme,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFuturisticTextField(
                  controller: controller.weightController,
                  label: 'Weight (kg)',
                  icon: Icons.scale,
                  hint: '0.0',
                  theme: theme,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFuturisticTextField(
                  controller: controller.quantityController,
                  label: 'Quantity',
                  icon: Icons.inventory,
                  hint: '1',
                  theme: theme,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFuturisticTextField(
            controller: controller.specialInstructionsController,
            label: 'Special Instructions',
            icon: Icons.note,
            hint: 'Any special handling requirements?',
            theme: theme,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildFuturisticTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    required ThemeData theme,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        style: TextStyle(color: theme.primaryColor),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: theme.primaryColor),
          hintStyle: TextStyle(color: theme.primaryColor.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: theme.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildLocationSection(ThemeData theme) {
    return CyberCard(
      isDark: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeonText(
            text: 'DELIVERY LOCATIONS',
            color: theme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          _buildLocationTile(
            icon: Icons.location_on,
            title: 'Pickup Location',
            subtitle: controller.pickupAddress.value.isEmpty
                ? 'Getting your current location...'
                : controller.pickupAddress.value,
            color: theme.primaryColor,
            onTap: () => controller.getCurrentLocation(),
            isLoading: controller.isLocationLoading.value,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _buildLocationTile(
            icon: Icons.flag,
            title: 'Dropoff Location',
            subtitle: controller.dropoffAddress.value.isEmpty
                ? 'Tap on map to select dropoff location'
                : controller.dropoffAddress.value,
            color: theme.colorScheme.secondary,
            onTap: () {},
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required ThemeData theme,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Obx(() => Text(
          title == 'Pickup Location' 
            ? (controller.pickupAddress.value.isEmpty
                ? 'Getting your current location...'
                : controller.pickupAddress.value)
            : (controller.dropoffAddress.value.isEmpty
                ? 'Tap on map to select dropoff location'
                : controller.dropoffAddress.value),
          style: TextStyle(
            color: color.withOpacity(0.7),
          ),
        )),
        trailing: title == 'Pickup Location' 
          ? Obx(() => controller.isLocationLoading.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.refresh, color: color),
                  onPressed: onTap,
                ))
          : Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 16,
            ),
        onTap: title == 'Dropoff Location' ? null : onTap,
      ),
    );
  }

  Widget _buildMapSection(BuildContext context, ThemeData theme) {
    return CyberCard(
      isDark: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeonText(
            text: 'SELECT DROPOFF POINT',
            color: theme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Obx(() => FlutterMap(
                    mapController: controller.mapController.value,
                    options: MapOptions(
                      initialCenter: controller.currentLocation.value ?? const LatLng(9.03, 38.74),
                      initialZoom: controller.mapZoom.value,
                      backgroundColor: Colors.grey[100]!,
                      onTap: (tapPosition, point) => controller.setDropoffLocation(point),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                        subdomains: const ['a', 'b', 'c', 'd'],
                      ),
                      Obx(() => MarkerLayer(
                        markers: [
                          if (controller.currentLocation.value != null)
                            Marker(
                              point: controller.currentLocation.value!,
                              width: 40,
                              height: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.primaryColor.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          if (controller.dropoffLocation.value != null)
                            Marker(
                              point: controller.dropoffLocation.value!,
                              width: 40,
                              height: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.secondary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.secondary.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.flag,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                        ],
                      )),
                    ],
                  )),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Column(
                      children: [
                        _buildMapButton(Icons.add, controller.handleZoomIn, theme),
                        const SizedBox(height: 8),
                        _buildMapButton(Icons.remove, controller.handleZoomOut, theme),
                        const SizedBox(height: 8),
                        _buildMapButton(Icons.my_location, controller.handleCenterMap, theme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback onPressed, ThemeData theme) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.9),
        border: Border.all(
          color: theme.primaryColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.primaryColor, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme, BuildContext context) {
    return Obx(() => ElasticIn(
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [theme.primaryColor, theme.colorScheme.secondary],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: controller.isSubmitting.value ? null : () {
            controller.submitPackage(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: controller.isSubmitting.value
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Text(
                  'LAUNCH PACKAGE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    ));
  }

  void _showSuccessDialog(ThemeData theme) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: CyberCard(
          isDark: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [theme.primaryColor, theme.colorScheme.secondary],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.rocket_launch,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              NeonText(
                text: 'PACKAGE LAUNCHED!',
                color: theme.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your package is now in the delivery matrix',
                style: TextStyle(
                  color: theme.primaryColor.withOpacity(0.7),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [theme.primaryColor, theme.colorScheme.secondary],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'CONTINUE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
