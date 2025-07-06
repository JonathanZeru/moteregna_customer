// lib/views/about_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gibe_market/controllers/privacy_controller.dart';

class AboutScreen extends StatelessWidget {
  final PolicyTermsController controller = Get.put(PolicyTermsController());

  AboutScreen({super.key}) {
    controller.fetchAbout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
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
          itemCount: controller.aboutContent.length,
          itemBuilder: (context, index) {
            final about = controller.aboutContent[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      about.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      about.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last updated: ${about.updatedAt.toLocal().toString().split(' ')[0]}',
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