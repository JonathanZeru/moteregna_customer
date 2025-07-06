// lib/views/privacy_policy_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:gibe_market/controllers/privacy_controller.dart';
import 'package:google_fonts/google_fonts.dart';
class SupportScreen extends StatelessWidget {
  final PolicyTermsController controller = Get.put(PolicyTermsController());

  SupportScreen({super.key}) {
    controller.fetchPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Screen'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return Column(
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity( 0.3),
                      blurRadius: 20,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: Center(
                    child: SizedBox(
                        child: Image.asset(
                          "assets/moteregna-logo.png",
                        )
                    )
                ),
              ).animate().fadeIn(duration: 600.ms).scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 600.ms,
                curve: Curves.easeOutBack,
              ),
            ),

            const SizedBox(height: 30),

            // App name
            Center(
              child:  Text(
                'app_name'.tr,
                style: GoogleFonts.orbitron(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(
              begin: -0.2,
              end: 0,
              delay: 300.ms,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),

            const SizedBox(height: 10),

            // Tagline
            Center(
              child: Text(
                'Customer App'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 4,
                ),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(
              begin: -0.2,
              end: 0,
              delay: 500.ms,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),
            Center(
              child:  Text(
                '0993888808'.tr,
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(
              begin: -0.2,
              end: 0,
              delay: 300.ms,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),
            Center(
              child:  Text(
                'brighttechnology3@gmail.com'.tr,
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(
              begin: -0.2,
              end: 0,
              delay: 300.ms,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),
            const SizedBox(height: 50),
            ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: controller.privacyPolicies.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final policy = controller.privacyPolicies[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          policy.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          policy.content,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Last updated: ${policy.updatedAt.toLocal().toString().split(' ')[0]}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}