import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/utils/app_routes.dart';
import 'package:gibe_market/views/home/widget/cyber_card.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

class NotificationDeliveryScreen extends StatefulWidget {
  const NotificationDeliveryScreen({super.key, this.notificationData});

  final Map<String, dynamic>? notificationData;

  @override
  State<NotificationDeliveryScreen> createState() => _NotificationDeliveryScreenState();
}

class _NotificationDeliveryScreenState extends State<NotificationDeliveryScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late final ThemeController _themeController;

  String _motoristPhone = '';
  String _motoristFullName = '';
  String _motoristProfilePic = '';

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

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    if (widget.notificationData != null) {
      _handleNotificationData(widget.notificationData!);
    }
  }

  void _handleNotificationData(Map<String, dynamic> data) {
    try {
      setState(() {
        _motoristPhone = data['motoristPhone']?.toString() ?? '+251-912-345-678';
        _motoristFullName = data['motoristFullName']?.toString() ?? 'Cyber Delivery Agent';
        _motoristProfilePic = data['motoristProfilePic']?.toString() ?? 'https://i.pravatar.cc/300';
      });
    } catch (e) {
      print('Error handling notification data: $e');
    }
  }

  void _callMotorist() async {
    HapticFeedback.mediumImpact();
    final status = await Permission.phone.request();
    if (status.isGranted) {
      final Uri url = Uri(scheme: 'tel', path: _motoristPhone);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        _showCyberSnackBar('Cannot establish quantum connection to $_motoristPhone');
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
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _rotationController.dispose();
    super.dispose();
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
                // Header with back button
                _buildHeader(theme),
                
                // Main content
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        child: CyberCard(
                          isDark: false,
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Animated Success Icon
                              _buildSuccessIcon(theme),
                              
                              const SizedBox(height: 20),
                              
                              // Success Message
                              NeonText(
                                text: 'DELIVERY ACCEPTED!',
                                color: Colors.green,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 8),
                              
                              Text(
                                'Package transmission successful',
                                style: GoogleFonts.orbitron(
                                  fontSize: 14,
                                  color: theme.primaryColor.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Agent Profile
                              _buildAgentProfile(theme),
                              
                              const SizedBox(height: 30),
                              
                              // Agent Info
                              _buildAgentInfo(theme),
                              
                              const SizedBox(height: 30),
                              
                              // Action Buttons
                              _buildActionButtons(theme),
                            ],
                          ),
                        ),
                      ),
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
            const SizedBox(width: 16),
            NeonText(
              text: 'DELIVERY STATUS',
              color: theme.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon(ThemeData theme) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF00FF88), Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.4 * _pulseAnimation.value),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              FontAwesomeIcons.checkCircle,
              size: 60,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAgentProfile(ThemeData theme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Rotating glow ring
        AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationController.value * 2 * 3.14159,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
            );
          },
        ),
        
        // Pulsing glow
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3 * _glowAnimation.value),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
            );
          },
        ),
        
        // Profile picture
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.primaryColor,
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              _motoristProfilePic,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(
                    FontAwesomeIcons.userAstronaut,
                    color: theme.primaryColor,
                    size: 40,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgentInfo(ThemeData theme) {
    return Column(
      children: [
        NeonText(
          text: 'DELIVERY AGENT',
          color: theme.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        Text(
          _motoristFullName,
          style: GoogleFonts.orbitron(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.primaryColor.withOpacity(0.3),
              width: 1,
            ),
            color: Colors.white.withOpacity(0.8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.satellite,
                color: theme.primaryColor,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                _motoristPhone,
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        // Call Button
        Expanded(
          child: Container(
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
              onPressed: _callMotorist,
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
                'CONNECT',
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Back to Home Button
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.colorScheme.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Get.offAllNamed('/mainScreen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: const Icon(
                FontAwesomeIcons.home,
                size: 16,
                color: Colors.white,
              ),
              label: Text(
                'HOME BASE',
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
