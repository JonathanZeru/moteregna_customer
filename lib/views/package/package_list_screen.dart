import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/utils/app_routes.dart';
import 'package:gibe_market/views/home/widget/cyber_card.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';
import 'package:gibe_market/views/package/package_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../model/delivery_package.dart';
import '../../service/api_service.dart';

class PackageListScreen extends StatefulWidget {
  final bool isHomeFrom;
  const PackageListScreen({Key? key, required this.isHomeFrom}) : super(key: key);

  @override
  _PackageListScreenState createState() => _PackageListScreenState();
}

class _PackageListScreenState extends State<PackageListScreen> with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late final ThemeController _themeController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _glowController;

  List<Package> _packages = [];
  bool _isLoading = true;
  String _errorMessage = '';
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

    _loadPackages();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  
Future<void> _loadPackages() async {
  print("load packages");
  try {
    final response = await _apiService.getPackages();
    final List<dynamic> packageList = response['packages'];

    if (!mounted) return; // ✅ check if widget is still mounted

    setState(() {
      _packages = packageList.map((json) => Package.fromJson(json)).toList();
      _isLoading = false;
    });
  } catch (e) {
    if (!mounted) return; // ✅ check again in case of error

    setState(() {
      _errorMessage = e.toString();
      _isLoading = false;
    });
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

            return Column(
              children: [
                // Header
                _buildHeader(theme, isDark, widget.isHomeFrom),
                
                // Content
                Expanded(
                  child: _isLoading
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
                                text: "LOADING PACKAGES...",
                                color: theme.colorScheme.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        )
                      : _errorMessage.isNotEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.triangleExclamation,
                                    size: 48,
                                    color: Colors.red.withOpacity(0.7),
                                  ),
                                  const SizedBox(height: 16),
                                  NeonText(
                                    text: "ERROR DETECTED",
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _errorMessage,
                                    style: GoogleFonts.orbitron(
                                      fontSize: 14,
                                      color: theme.primaryColor.withOpacity(0.5),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _isLoading = true;
                                        _errorMessage = '';
                                      });
                                      _loadPackages();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    icon: const Icon(FontAwesomeIcons.arrowsRotate, color: Colors.white),
                                    label: Text(
                                      'RETRY',
                                      style: GoogleFonts.orbitron(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _packages.isEmpty
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
                                        text: "NO PACKAGES FOUND",
                                        color: theme.colorScheme.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Create your first package to get started",
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
                                  itemCount: _packages.length,
                                  itemBuilder: (context, index) {
                                    final package = _packages[index];
                                    return PackageListItem(
                                      package: package,
                                      isDark: isDark,
                                      theme: theme,
                                      index: index,
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        Get.to(() => PackageDetailScreen(package: package));
                                      },
                                    );
                                  },
                                ),
                ),
              ],
            );
          }),
        ),
      ) );
  }

  Widget _buildHeader(ThemeData theme, bool isDark, bool isHomeFrom) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            widget.isHomeFrom == true ? 
           Row(children: [
             GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Get.offAllNamed(AppRoutes.mainScreen);
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
            SizedBox(width: 16)
          
           ],)
             :SizedBox.shrink(),
               Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NeonText(
                    text: 'MY PACKAGES',
                    color: theme.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your delivery packages',
                    style: GoogleFonts.orbitron(
                      color: theme.primaryColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageListItem extends StatelessWidget {
  final Package package;
  final VoidCallback onTap;
  final bool isDark;
  final ThemeData theme;
  final int index;

  const PackageListItem({
    Key? key,
    required this.package,
    required this.onTap,
    required this.isDark,
    required this.theme,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CyberCard(
        isDark: false,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: theme.primaryColor.withOpacity(0.1),
          highlightColor: theme.primaryColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        FontAwesomeIcons.box,
                        color: theme.colorScheme.primary,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NeonText(
                        text: package.description ?? 'NO DESCRIPTION',
                        color: theme.colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(package.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(package.status).withOpacity(0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getStatusColor(package.status).withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        (package.status ?? 'N/A').toUpperCase(),
                        style: GoogleFonts.orbitron(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(package.status),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Package details
                Row(
                  children: [
                    // Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CATEGORY",
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
                                FontAwesomeIcons.tag,
                                size: 12,
                                color: theme.colorScheme.secondary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  package.category?.name ?? 'N/A',
                                  style: GoogleFonts.orbitron(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.secondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Weight
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "WEIGHT",
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
                                FontAwesomeIcons.weightHanging,
                                size: 12,
                                color: theme.colorScheme.tertiary,
                              ),
                              const SizedBox(width: 6),
                              NeonText(
                                text: "${package.weight?.toString() ?? 'N/A'} KG",
                                color: theme.colorScheme.tertiary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Quantity
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "QUANTITY",
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
                                FontAwesomeIcons.hashtag,
                                size: 12,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              NeonText(
                                text: package.quantity?.toString() ?? 'N/A',
                                color: theme.colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
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
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideY(
        begin: 0.1,
        end: 0,
        delay: Duration(milliseconds: 100 * index),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
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
}
