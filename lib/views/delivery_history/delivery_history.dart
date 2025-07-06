import 'dart:ui';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/views/home/widget/cyber_card.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';
import 'package:gibe_market/utils/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;

class PackageHistoryScreen extends StatefulWidget {
  const PackageHistoryScreen({super.key});

  @override
  State<PackageHistoryScreen> createState() => _PackageHistoryScreenState();
}

class _PackageHistoryScreenState extends State<PackageHistoryScreen> with TickerProviderStateMixin {
  late final ThemeController _themeController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _glowController;

  final RxBool _isLoading = false.obs;
  final RxList<DeliveryRecord> _deliveries = <DeliveryRecord>[].obs;
  final RxString _selectedFilter = 'today'.obs;
  final box = GetStorage();
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _themeController = Get.put(ThemeController());

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _loadDeliveries();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _loadDeliveries() async {
  _isLoading.value = true;
  
  try {
    // Get motorist ID from storage
    final motorData = box.read('motorData');
    final userData = box.read('userData');
    String motoristId = '';
    
    if (motorData != null && motorData['id'] != null) {
      motoristId = motorData['id'].toString();
    } else if (userData != null && userData['id'] != null) {
      motoristId = userData['id'].toString();
    } else {
      motoristId = 'cm98d1ooa0002rzxr21gi35o7'; // Fallback ID
    }
    
    // Get access token
    final accessToken = box.read('accessToken');
    
    // Make API request
    final response = await http.get(
      Uri.parse('$apiBaseUrl/motorist/delivery/delivery-history?motoristId=$motoristId&page=1&data=15'),
      headers: accessToken != null ? {
        'Authorization': 'Bearer $accessToken',
      } : {},
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> deliveriesData = responseData['data'] as List<dynamic>;
      
      final List<DeliveryRecord> deliveries = deliveriesData.map((data) {
        // Parse values safely
        final String id = 'PKG-${_random.nextInt(9000) + 1000}';
        final String startTimeString = (data['startTime'] as String?) ?? DateTime.now().toIso8601String();
        final DateTime startTime = DateTime.tryParse(startTimeString) ?? DateTime.now();
        final double distance = (data['totalDistance'] is num) ? (data['totalDistance'] as num).toDouble() : 0.0;
        final double totalCost = (data['totalCost'] is num) ? (data['totalCost'] as num).toDouble() : 0.0;
        final String destination = data['destination']?.toString() ?? 'Unknown Destination';
        final double destinationLat = (data['destinationLat'] is num) ? (data['destinationLat'] as num).toDouble() : 9.03;
        final double destinationLong = (data['destinationLong'] is num) ? (data['destinationLong'] as num).toDouble() : 38.74;
        final DateTime endTime = data['endTime'] != null
            ? DateTime.tryParse(data['endTime']!.toString()) ?? startTime.add(Duration(minutes: _random.nextInt(45) + 15))
            : startTime.add(Duration(minutes: _random.nextInt(45) + 15));
        final double sourceLat = (data['sourceLat'] is num) ? (data['sourceLat'] as num).toDouble() : 9.03;
        final double sourceLong = (data['sourceLong'] is num) ? (data['sourceLong'] as num).toDouble() : 38.74;
        final double price = (data['totalCost'] is num) ? (data['totalCost'] as num).toDouble() : 0.0;
        final String statusString = data['status']?.toString() ?? 'PENDING';
        final String source = data['source']?.toString() ?? 'Unknown Source';
        final String customerPhone = data['customerPhone']?.toString() ?? '';
        
        return DeliveryRecord(
          id: id,
          date: startTime,
          startLocation: LatLng(sourceLat, sourceLong),
          endLocation: LatLng(destinationLat, destinationLong),
          distance: distance,
          duration: endTime.difference(startTime),
          price: price,
          status: _mapApiStatusToDeliveryStatus(statusString),
          routePoints: _generateRoutePoints(
            LatLng(sourceLat, sourceLong),
            LatLng(destinationLat, destinationLong),
          ),
          totalCost: totalCost,
          source: source,
          destination: destination,
          customerPhone: customerPhone,
        );
      }).toList();
      
      _deliveries.value = deliveries;
    } else {
      print('Failed to load deliveries: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      // Show error message to user
      Get.snackbar(
        'Error',
        'Failed to load delivery history. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      _deliveries.value = [];
    }
  } catch (e) {
    print('Error loading deliveries: $e');
    
    // Show error message to user
    Get.snackbar(
      'Network Error',
      'Unable to connect to server. Please check your internet connection.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
    
    _deliveries.value = [];
  } finally {
    _isLoading.value = false;
  }
}

  List<DeliveryRecord> _getFilteredDeliveries() {
    final now = DateTime.now();

    switch (_selectedFilter.value) {
      case 'today':
        final startOfDay = DateTime(now.year, now.month, now.day);
        return _deliveries.where((d) => d.date.isAfter(startOfDay)).toList();
      case 'this_week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        return _deliveries.where((d) => d.date.isAfter(startOfWeekDay)).toList();
      case 'all':
      default:
        return _deliveries.toList();
    }
  }

  double _getTotalEarnings(List<DeliveryRecord> deliveries) {
    return deliveries.fold(0.0, (sum, item) => sum + item.price);
  }

  double _getTotalDistance(List<DeliveryRecord> deliveries) {
    return deliveries.fold(0.0, (sum, item) => sum + item.distance);
  }

  int _getAverageDeliveryTime(List<DeliveryRecord> deliveries) {
    if (deliveries.isEmpty) return 0;
    return (deliveries.fold(0, (sum, item) => sum + item.duration.inMinutes) / deliveries.length).round();
  }

  List<LatLng> _generateRoutePoints(LatLng start, LatLng end) {
  final List<LatLng> points = [start];
  
  final latDiff = end.latitude - start.latitude;
  final lngDiff = end.longitude - start.longitude;
  
  final numPoints = 5 + (_random.nextInt(5));
  for (int i = 1; i <= numPoints; i++) {
    final ratio = i / (numPoints + 1);
    
    final latJitter = _random.nextDouble() * 0.002 * (i % 2 == 0 ? 1 : -1);
    final lngJitter = _random.nextDouble() * 0.002 * (i % 2 == 0 ? -1 : 1);
    
    points.add(LatLng(
      start.latitude + (latDiff * ratio) + latJitter,
      start.longitude + (lngDiff * ratio) + lngJitter,
    ));
  }
  
  points.add(end);
  return points;
}

DeliveryStatus _mapApiStatusToDeliveryStatus(String status) {
  switch (status.toUpperCase()) {
    case 'COMPLETED':
    case 'DELIVERED':
      return DeliveryStatus.completed;
    case 'PENDING':
    case 'IN_PROGRESS':
    case 'STARTED':
      return DeliveryStatus.inProgress;
    case 'CANCELLED':
    case 'FAILED':
      return DeliveryStatus.cancelled;
    default:
      return DeliveryStatus.inProgress;
  }
}

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
          child: Obx(() {
            final isDark = _themeController.isDarkMode;
            final theme = Theme.of(context);
            final filteredDeliveries = _getFilteredDeliveries();

            return Column(
              children: [
                // Header
                _buildHeader(theme, isDark),
                
                // Filter tabs
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: CyberCard(
                    isDark: isDark,
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        _buildFilterButton('Today', 'today', theme, isDark),
                        _buildFilterButton('This Week', 'this_week', theme, isDark),
                        _buildFilterButton('All', 'all', theme, isDark),
                      ],
                    ),
                  ),
                ),

                // Stats summary
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CyberCard(
                    isDark: isDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            AnimatedBuilder(
                              animation: _glowController,
                              builder: (context, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.primary.withOpacity(0.3 + 0.2 * _glowController.value),
                                        blurRadius: 10 + 5 * _glowController.value,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.chartPie,
                                    color: theme.colorScheme.primary,
                                    size: 16,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            NeonText(
                              text: _selectedFilter.value == 'today'
                                  ? "TODAY'S STATS"
                                  : _selectedFilter.value == 'this_week'
                                      ? "WEEK'S STATS"
                                      : "ALL TIME STATS",
                              color: theme.colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            const Spacer(),
                            AnimatedBuilder(
                              animation: _rotationController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _rotationController.value * 2 * 3.14159,
                                  child: Icon(
                                    FontAwesomeIcons.chartLine,
                                    color: theme.colorScheme.primary.withOpacity(0.7),
                                    size: 14,
                                  ),
                                );
                              },
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

                        // Stats grid
                        Row(
                          children: [
                            // Total deliveries
                            Expanded(
                              child: _buildStatItem(
                                theme,
                                FontAwesomeIcons.boxesStacked,
                                "PACKAGES",
                                NeonText(
                                  text: "${filteredDeliveries.length}",
                                  color: theme.colorScheme.tertiary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                isDark: isDark,
                              ),
                            ),

                            // Total earnings
                            Expanded(
                              child: _buildStatItem(
                                theme,
                                FontAwesomeIcons.moneyBillWave,
                                "EARNINGS",
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    NeonText(
                                      text: _getTotalEarnings(filteredDeliveries).toStringAsFixed(2),
                                      color: theme.colorScheme.secondary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Text(
                                      " ETB",
                                      style: GoogleFonts.orbitron(
                                        fontSize: 12,
                                        color: theme.colorScheme.secondary.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            // Total distance
                            Expanded(
                              child: _buildStatItem(
                                theme,
                                FontAwesomeIcons.route,
                                "DISTANCE",
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    NeonText(
                                      text: _getTotalDistance(filteredDeliveries).toStringAsFixed(2),
                                      color: theme.colorScheme.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Text(
                                      " KM",
                                      style: GoogleFonts.orbitron(
                                        fontSize: 12,
                                        color: theme.colorScheme.primary.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                isDark: isDark,
                              ),
                            ),

                            // Average time
                            Expanded(
                              child: _buildStatItem(
                                theme,
                                FontAwesomeIcons.stopwatch,
                                "AVG TIME",
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    NeonText(
                                      text: _getAverageDeliveryTime(filteredDeliveries).toString(),
                                      color: theme.colorScheme.tertiary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Text(
                                      " MIN",
                                      style: GoogleFonts.orbitron(
                                        fontSize: 12,
                                        color: theme.colorScheme.tertiary.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).animate().fadeIn().slideY(begin: -0.3, end: 0, duration: const Duration(milliseconds: 800)),
                  ),
                ),

                // Delivery list
                Expanded(
                  child: _isLoading.value
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.primary.withOpacity(0.3 + 0.2 * _pulseController.value),
                                          blurRadius: 20 + 10 * _pulseController.value,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: CircularProgressIndicator(
                                      color: theme.colorScheme.primary,
                                      strokeWidth: 3,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              NeonText(
                                text: "LOADING PACKAGE HISTORY...",
                                color: theme.colorScheme.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        )
                      : filteredDeliveries.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.boxOpen,
                                    size: 48,
                                    color: theme.primaryColor.withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 16),
                                  NeonText(
                                    text: _selectedFilter.value == 'today'
                                        ? "NO PACKAGES TODAY"
                                        : _selectedFilter.value == 'this_week'
                                            ? "NO PACKAGES THIS WEEK"
                                            : "NO PACKAGES FOUND",
                                    color: theme.colorScheme.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Start creating packages to see your history",
                                    style: GoogleFonts.orbitron(
                                      fontSize: 14,
                                      color: theme.primaryColor.withOpacity(0.5),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredDeliveries.length,
                              itemBuilder: (context, index) {
                                final delivery = filteredDeliveries[index];
                                return _buildDeliveryCard(delivery, theme, isDark, index);
                              },
                            )
                )
              ]
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadDeliveries,
        backgroundColor: theme.primaryColor,
        child: AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _isLoading.value ? _rotationController.value * 2 * 3.14159 : 0,
              child: const Icon(
                FontAwesomeIcons.arrowsRotate,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            NeonText(
              text: 'PACKAGE HISTORY',
              color: theme.primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Track your deliveries through the matrix',
              style: GoogleFonts.orbitron(
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

  Widget _buildFilterButton(String label, String value, ThemeData theme, bool isDark) {
    final isSelected = _selectedFilter.value == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          _selectedFilter.value = value;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.5),
                    width: 1,
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: isSelected
              ? NeonText(
                  text: label.toUpperCase(),
                  color: theme.colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                )
              : Text(
                  label.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: theme.primaryColor.withOpacity(0.7),
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    IconData icon,
    String label,
    Widget value, {
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.orbitron(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.primaryColor.withOpacity(0.7),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Center(child: value),
      ],
    );
  }

  Widget _buildDeliveryCard(DeliveryRecord delivery, ThemeData theme, bool isDark, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        // Navigate to package details
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: CyberCard(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with ID and date
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.5),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      FontAwesomeIcons.box,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NeonText(
                          text: delivery.id,
                          color: theme.colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        Text(
                          DateFormat('MMM dd, yyyy • hh:mm a').format(delivery.date),
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            color: theme.primaryColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(delivery.status, theme).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(delivery.status, theme).withOpacity(0.5),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getStatusColor(delivery.status, theme).withOpacity(0.2),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      _getStatusText(delivery.status).toUpperCase(),
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(delivery.status, theme),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Location details
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "FROM",
                          style: GoogleFonts.orbitron(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColor.withOpacity(0.5),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          delivery.source,
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    FontAwesomeIcons.arrowRight,
                    size: 12,
                    color: theme.colorScheme.primary.withOpacity(0.7),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "TO",
                          style: GoogleFonts.orbitron(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColor.withOpacity(0.5),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          delivery.destination,
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Delivery details
              Row(
                children: [
                  // Distance
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DISTANCE",
                          style: GoogleFonts.orbitron(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColor.withOpacity(0.5),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.route,
                              size: 12,
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(width: 6),
                            NeonText(
                              text: "${delivery.distance.toStringAsFixed(1)} KM",
                              color: theme.colorScheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Duration
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DURATION",
                          style: GoogleFonts.orbitron(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColor.withOpacity(0.5),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.stopwatch,
                              size: 12,
                              color: theme.colorScheme.tertiary,
                            ),
                            const SizedBox(width: 6),
                            NeonText(
                              text: "${delivery.duration.inMinutes} MIN",
                              color: theme.colorScheme.tertiary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Earnings
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "EARNINGS",
                          style: GoogleFonts.orbitron(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColor.withOpacity(0.5),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.moneyBill,
                              size: 12,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            NeonText(
                              text: "${delivery.price.toStringAsFixed(2)} ETB",
                              color: theme.colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Customer phone
              if (delivery.customerPhone.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CUSTOMER",
                      style: GoogleFonts.orbitron(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor.withOpacity(0.5),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.phone,
                          size: 12,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          delivery.customerPhone,
                          style: GoogleFonts.orbitron(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),

              // View details button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeonText(
                      text: "VIEW DETAILS",
                      color: theme.colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      FontAwesomeIcons.angleRight,
                      size: 12,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideY(
          begin: 0.1,
          end: 0,
          delay: Duration(milliseconds: 100 * index),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }

  Color _getStatusColor(DeliveryStatus status, ThemeData theme) {
    switch (status) {
      case DeliveryStatus.completed:
        return Colors.green;
      case DeliveryStatus.inProgress:
        return const Color(0xFF00FFFF);
      case DeliveryStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.completed:
        return "Delivered";
      case DeliveryStatus.inProgress:
        return "In Transit";
      case DeliveryStatus.cancelled:
        return "Cancelled";
    }
  }
}

enum DeliveryStatus {
  completed,
  inProgress,
  cancelled,
}

class DeliveryRecord {
  final String id;
  final DateTime date;
  final LatLng startLocation;
  final LatLng endLocation;
  final double distance;
  final double totalCost;
  final Duration duration;
  final double price;
  final DeliveryStatus status;
  final List<LatLng> routePoints;
  final String source;
  final String destination;
  final String customerPhone;

  DeliveryRecord({
    required this.id,
    required this.date,
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.duration,
    required this.totalCost,
    required this.price,
    required this.status,
    required this.routePoints,
    required this.source,
    required this.destination,
    required this.customerPhone,
  });
}
