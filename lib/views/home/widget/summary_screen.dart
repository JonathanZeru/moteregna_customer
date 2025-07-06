import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/views/home/widget/cyber_card.dart';
import 'package:gibe_market/views/home/widget/glowing_progress_indicator.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';

class SummaryScreen extends StatefulWidget {
  final LatLng startLocation;
  final LatLng endLocation;
  final double distance;
  final Duration duration;
  final List<LatLng> routePoints;
  final double initialPrice;
  final double pricePerKm;
  final double pricePerMinute;
  final String customerPhone;

  const SummaryScreen({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.duration,
    required this.routePoints,
    required this.initialPrice,
    required this.pricePerKm,
    required this.pricePerMinute,
    required this.customerPhone,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}
class _SummaryScreenState extends State<SummaryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final MapController _mapController = MapController();
  late final ThemeController _themeController;
  String startAddress = '';
  String destinationAddress = '';
 // Pricing constants
  double get totalPrice {
    final distanceKm = widget.distance;
    final timeMinutes = widget.duration.inMinutes.toDouble();
    return widget.initialPrice + 
           (distanceKm * widget.pricePerKm) + 
           (timeMinutes * widget.pricePerMinute);
  }

  double get distanceFare => widget.distance * widget.pricePerKm;
  double get timeFare => widget.duration.inMinutes * widget.pricePerMinute;
  @override
  void initState() {
    super.initState();
    _themeController = Get.find<ThemeController>();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Center map on route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.routePoints.isNotEmpty) {
        _fitBounds();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _fitBounds() async {
    await _getAddressFromLatLng(widget.startLocation.latitude, widget.startLocation.longitude, 1);
    await _getAddressFromLatLng(widget.endLocation.latitude, widget.endLocation.longitude, 2);
    if (widget.routePoints.length < 2) return;

    double minLat = widget.routePoints.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat = widget.routePoints.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    double minLng = widget.routePoints.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng = widget.routePoints.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

    // Add some padding
    minLat -= 0.01;
    maxLat += 0.01;
    minLng -= 0.01;
    maxLng += 0.01;

    _mapController.move(
      LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2),
      13.0,
    );
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude, int who) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = '${place.name}, ${place.street}, ${place.locality}, ${place.country}';
        if (who == 1) {
          setState(() {
            startAddress = address;
          });
        } else {
          setState(() {
            destinationAddress = address;
          });
        }
      }
    } catch (e) {
      print('Error fetching address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
// Calculate fare components
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      const Color(0xFF0A0E21).withOpacity(0.9),
                      const Color(0xFF0F1642).withOpacity(0.95),
                    ]
                  : [
                      const Color(0xFFE8F0FE).withOpacity(0.9),
                      const Color(0xFFF8F9FA).withOpacity(0.95),
                    ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(theme, isDark),
                _buildCustomerPhone(theme, isDark),
                // Map with route
                _buildMapSection(theme, isDark),
                // Summary details
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                       // Location details
                        _buildRouteDetails(theme, isDark),
                        const SizedBox(height: 16),
                        // Trip statistics
                        _buildMissionStats(theme, isDark),
                        const SizedBox(height: 16),
                        // Payment details
                        _buildPaymentDetails(theme, isDark, 170, distanceFare, timeFare),
                      ],
                    ),
                  ),
                ),
                // Bottom button
                _buildReturnButton(theme, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
Widget _buildCustomerPhone(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.phone,
            color: theme.colorScheme.primary,
            size: 16,
          ),
          const SizedBox(width: 10),
          Text(
            "customer".tr,
            style: GoogleFonts.orbitron(
              fontSize: 14,
              color: isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            widget.customerPhone,
            style: GoogleFonts.orbitron(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.secondary.withOpacity(isDark ? 0.2 : 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.secondary.withOpacity(isDark
                          ? 0.3 + 0.2 * _animationController.value
                          : 0.2 + 0.1 * _animationController.value),
                      blurRadius: isDark ? 10 : 5,
                      spreadRadius: isDark ? 1 : 0.5,
                    ),
                  ],
                ),
                child: Icon(
                  FontAwesomeIcons.checkCircle,
                  color: theme.colorScheme.secondary,
                  size: 24,
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isDark
                    ? NeonText(
                        text: "delivery_complete".tr,
                        color: theme.colorScheme.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                    : Text(
                        "delivery_complete".tr,
                        style: GoogleFonts.orbitron(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                Text(
                  "delivery_success_message".tr,
                  style: GoogleFonts.orbitron(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.7),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              FontAwesomeIcons.xmark,
              color: isDark
                  ? Colors.white.withOpacity(0.7)
                  : Colors.black.withOpacity(0.7),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(ThemeData theme, bool isDark) {
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CyberCard(
          padding: EdgeInsets.zero,
          isDark: isDark,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: widget.startLocation,
                initialZoom: 13,
                backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFE8F0FE),
              ),
              children: [
                TileLayer(
                  urlTemplate: isDark
                      ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                      : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                ),
                if (widget.routePoints.length > 1)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: widget.routePoints,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                        strokeWidth: 6.0,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.startLocation,
                      width: 30,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.tertiary,
                          boxShadow: isDark
                              ? [
                                  BoxShadow(
                                    color: theme.colorScheme.tertiary.withOpacity(0.8),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: theme.colorScheme.tertiary.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                        ),
                        child: const Icon(
                          FontAwesomeIcons.play,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                    Marker(
                      point: widget.endLocation,
                      width: 30,
                      height: 30,
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
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRouteDetails(ThemeData theme, bool isDark) {
    return CyberCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.locationDot,
                color: theme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 10),
              isDark
                  ? NeonText(
                      text: "route_details".tr,
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )
                  : Text(
                      "route_details".tr,
                      style: GoogleFonts.orbitron(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.1),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          _buildLocationRow(
            theme,
            FontAwesomeIcons.play,
            "start_point".tr,
            startAddress,
            theme.colorScheme.tertiary,
            isDark: isDark,
          ),
          const SizedBox(height: 15),
          _buildLocationRow(
            theme,
            FontAwesomeIcons.flagCheckered,
            "end_point".tr,
            destinationAddress,
            theme.colorScheme.secondary,
            isDark: isDark,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0, delay: const Duration(milliseconds: 200));
  }

  Widget _buildMissionStats(ThemeData theme, bool isDark) {
    return CyberCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.chartLine,
                color: theme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 10),
              isDark
                  ? NeonText(
                      text: "mission_stats".tr,
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )
                  : Text(
                      "mission_stats".tr,
                      style: GoogleFonts.orbitron(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.1),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          _buildStatRow(
            theme,
            FontAwesomeIcons.route,
            "distance".tr,
            "${widget.distance.toStringAsFixed(2)} ${'km'.tr}",
            theme.colorScheme.primary,
            isDark: isDark,
          ),
          const SizedBox(height: 15),
          _buildStatRow(
            theme,
            FontAwesomeIcons.stopwatch,
            "duration".tr,
            _formatDuration(widget.duration),
            theme.colorScheme.primary,
            isDark: isDark,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0, delay: const Duration(milliseconds: 300));
  }

Widget _buildPaymentDetails(ThemeData theme, bool isDark, double baseFare, double distanceFare, double timeFare) {
    return CyberCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.creditCard,
                color: theme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 10),
              isDark
                  ? NeonText(
                      text: "payment_details".tr,
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )
                  : Text(
                      "payment_details".tr,
                      style: GoogleFonts.orbitron(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.1),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          _buildPaymentRow(
            theme,
            "initial_price".tr,
            "${widget.initialPrice.toStringAsFixed(2)} ${'etb'.tr}",
            widget.initialPrice / totalPrice,
            theme.colorScheme.tertiary,
            isDark: isDark,
          ),
          const SizedBox(height: 15),
          _buildPaymentRow(
            theme,
            "distance_fare".tr,
            "${distanceFare.toStringAsFixed(2)} ${'etb'.tr}",
            distanceFare / totalPrice,
            theme.colorScheme.primary,
            subtitle: "${widget.pricePerKm} ${'etb'.tr} × ${widget.distance.toStringAsFixed(2)} ${'km'.tr}",
            isDark: isDark,
          ),
          const SizedBox(height: 15),
          _buildPaymentRow(
            theme,
            "time_fare".tr,
            "${timeFare.toStringAsFixed(2)} ${'etb'.tr}",
            timeFare / totalPrice,
            theme.colorScheme.secondary,
            subtitle: "${widget.pricePerMinute} ${'etb'.tr} × ${widget.duration.inMinutes} ${'minutes'.tr}",
            isDark: isDark,
          ),
          const SizedBox(height: 15),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.1),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Text(
                  "total_amount".tr,
                  style: GoogleFonts.orbitron(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                    letterSpacing: 1,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.secondary.withOpacity(isDark
                            ? 0.3 + 0.2 * _animationController.value
                            : 0.2 + 0.1 * _animationController.value),
                        width: 1,
                      ),
                      boxShadow: isDark
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.secondary.withOpacity(0.2 + 0.2 * _animationController.value),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: theme.colorScheme.secondary.withOpacity(0.1 + 0.1 * _animationController.value),
                                blurRadius: 5,
                                spreadRadius: 0.5,
                              ),
                            ],
                    ),
                    child: isDark
                        ? NeonText(
                            text: "${totalPrice.toStringAsFixed(2)} ${'etb'.tr}",
                            color: theme.colorScheme.secondary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            glowIntensity: 0.5 + 0.5 * _animationController.value,
                          )
                        : Text(
                            "${totalPrice.toStringAsFixed(2)} ${'etb'.tr}",
                            style: GoogleFonts.orbitron(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0, delay: const Duration(milliseconds: 400));
  }
  Widget _buildReturnButton(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: isDark ? 8 : 4,
            shadowColor: theme.colorScheme.secondary.withOpacity(isDark ? 0.5 : 0.3),
          ),
          child: Text(
            "return_to_dashboard".tr,
            style: GoogleFonts.orbitron(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: const Duration(milliseconds: 500)),
    );
  }

  Widget _buildLocationRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
    Color color, {
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  color: isDark
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
    Color color, {
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.orbitron(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
              letterSpacing: 1,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 1,
            shadows: isDark
                ? [
                    Shadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 5,
                    ),
                  ]
                : [],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(
    ThemeData theme,
    String label,
    String value,
    double progressValue,
    Color color, {
    String? subtitle,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.orbitron(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                      letterSpacing: 1,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: GoogleFonts.orbitron(
                        fontSize: 10,
                        color: isDark
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black.withOpacity(0.5),
                        letterSpacing: 0.5,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              value,
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1,
                shadows: isDark
                    ? [
                        Shadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 5,
                        ),
                      ]
                    : [],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GlowingProgressIndicator(
          value: progressValue,
          color: color,
          height: 4,
          isDark: isDark,
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}