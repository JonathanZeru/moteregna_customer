// lib/views/terms_conditions_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gibe_market/controllers/privacy_controller.dart';

class TermsConditionsScreen extends StatelessWidget {
  final PolicyTermsController controller = Get.put(PolicyTermsController());

  TermsConditionsScreen({super.key}) {
    controller.fetchTermsConditions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
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
          itemCount: controller.termsConditions.length,
          itemBuilder: (context, index) {
            final terms = controller.termsConditions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      terms.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      terms.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last updated: ${terms.updatedAt.toLocal().toString().split(' ')[0]}',
                      style: Theme.of(context).textTheme.bodySmall
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