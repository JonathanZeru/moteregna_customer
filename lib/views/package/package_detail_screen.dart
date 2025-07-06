import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/views/home/widget/cyber_card.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';
import 'package:gibe_market/utils/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../model/delivery_package.dart';

class PackageDetailScreen extends StatefulWidget {
  final Package package;

  const PackageDetailScreen({Key? key, required this.package}) : super(key: key);

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> with TickerProviderStateMixin {
  late final ThemeController _themeController;
  late AnimationController _pulseController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _themeController = Get.put(ThemeController());

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _callMotorist(String phoneNumber) async {
    HapticFeedback.mediumImpact();
    final status = await Permission.phone.request();
    if (status.isGranted) {
      final Uri url = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        _showCyberSnackBar('Cannot establish quantum connection to $phoneNumber');
      }
    } else {
      _showCyberSnackBar('Communication protocol access denied');
    }
  }

  void _showCyberSnackBar(String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.primaryColor, width: 1),
        ),
      ),
    );
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

            return Column(
              children: [
                // Header
                _buildHeader(theme),
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPackageInfoCard(theme, isDark),
                        const SizedBox(height: 16),
                        _buildCustomerInfoCard(theme, isDark),
                        const SizedBox(height: 16),
                        if (widget.package.status != 'PENDING')
                          Column(
                            children: [
                              _buildMotoristInfoCard(theme, isDark),
                              const SizedBox(height: 16),
                            ],
                          ),
                        _buildLocationCard(theme, isDark, 'PICKUP LOCATION', widget.package.pickupLocation),
                        const SizedBox(height: 16),
                        _buildLocationCard(theme, isDark, 'DROPOFF LOCATION', widget.package.dropoffLocation),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.8),
                  border: Border.all(
                    color: theme.primaryColor.withOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: theme.primaryColor,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NeonText(
                    text: 'PACKAGE DETAILS',
                    color: theme.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantum package information',
                    style: GoogleFonts.orbitron(
                      color: theme.primaryColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Status indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(widget.package.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getStatusColor(widget.package.status).withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getStatusColor(widget.package.status).withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                (widget.package.status ?? 'N/A').toUpperCase(),
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(widget.package.status),
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageInfoCard(ThemeData theme, bool isDark) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: CyberCard(
        isDark: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        FontAwesomeIcons.box,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                NeonText(
                  text: 'PACKAGE INFORMATION',
                  color: theme.colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Description', widget.package.description ?? 'N/A', theme),
            _buildDetailRow('Category', widget.package.category?.name ?? 'N/A', theme),
            _buildDetailRow('Weight', '${widget.package.weight ?? 'N/A'} kg', theme),
            _buildDetailRow('Quantity', widget.package.quantity?.toString() ?? 'N/A', theme),
            _buildDetailRow('Special Instructions', widget.package.specialInstructions ?? 'None provided', theme),
            _buildDetailRow('Created At', _formatDate(widget.package.createdAt) ?? 'N/A', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard(ThemeData theme, bool isDark) {
    return FadeInUp(
      duration: const Duration(milliseconds: 900),
      child: CyberCard(
        isDark: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.user,
                  color: theme.colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                NeonText(
                  text: 'CUSTOMER INFORMATION',
                  color: theme.colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Name', '${widget.package.customer?.firstName ?? ''} ${widget.package.customer?.lastName ?? ''}', theme),
            _buildDetailRow('Phone', widget.package.customer?.phone ?? 'N/A', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMotoristInfoCard(ThemeData theme, bool isDark) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: CyberCard(
        isDark: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.motorcycle,
                  color: theme.colorScheme.tertiary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                NeonText(
                  text: 'MOTOREGNA INFORMATION',
                  color: theme.colorScheme.tertiary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Profile image
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.tertiary,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.tertiary.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    '$imageBaseUrl${widget.package.motorist?.profile}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.colorScheme.tertiary.withOpacity(0.1),
                        child: Icon(
                          FontAwesomeIcons.userAstronaut,
                          color: theme.colorScheme.tertiary,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildDetailRow('Name', '${widget.package.motorist?.firstName ?? ''} ${widget.package.motorist?.lastName ?? ''}', theme),
            _buildDetailRow('Phone', widget.package.motorist?.phone ?? 'N/A', theme),
            _buildDetailRow('License Number', widget.package.motorist?.licenseNumber ?? 'N/A', theme),
            _buildDetailRow('Vehicle Plate', widget.package.motorist?.vehiclePlateNumber ?? 'N/A', theme),
            
            const SizedBox(height: 16),
            
            // Call button
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00FF88), Color(0xFF00CC66)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => _callMotorist(widget.package.motorist?.phone ?? '0991888808'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                icon: const Icon(
                  FontAwesomeIcons.satellite,
                  size: 16,
                  color: Colors.white,
                ),
                label: Text(
                  'CONNECT TO MOTOREGNA',
                  style: GoogleFonts.orbitron(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(ThemeData theme, bool isDark, String title, dynamic location) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1100),
      child: CyberCard(
        isDark: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  title.contains('PICKUP') ? FontAwesomeIcons.locationDot : FontAwesomeIcons.flag,
                  color: title.contains('PICKUP') ? theme.colorScheme.primary : theme.colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                NeonText(
                  text: title,
                  color: title.contains('PICKUP') ? theme.colorScheme.primary : theme.colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Name', location?.name ?? 'N/A', theme),
            _buildDetailRow('Address', location?.address ?? 'N/A', theme),
            _buildDetailRow('Coordinates', '${location?.latitude ?? 'N/A'}, ${location?.longitude ?? 'N/A'}', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.orbitron(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.primaryColor.withOpacity(0.7),
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.orbitron(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'IN_PROGRESS':
        return const Color(0xFF00FFFF);
      case 'DELIVERED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String? _formatDate(String? dateString) {
    if (dateString == null) return null;
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return dateString;
    }
  }
}
