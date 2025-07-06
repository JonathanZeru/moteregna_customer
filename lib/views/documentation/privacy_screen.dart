// lib/views/privacy_policy_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gibe_market/controllers/privacy_controller.dart';
class PrivacyPolicyScreen extends StatelessWidget {
  final PolicyTermsController controller = Get.put(PolicyTermsController());

  PrivacyPolicyScreen({super.key}) {
    controller.fetchPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.privacyPolicies.length,
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
        );
      }),
    );
  }
}