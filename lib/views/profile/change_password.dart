import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gibe_market/controllers/profile_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  final EditProfileController controller = Get.put(EditProfileController());

  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Current Password Field
              TextFormField(
                controller: controller.currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              // New Password Field
              TextFormField(
                controller: controller.newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password (min 6 characters)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              // Confirm New Password Field
              TextFormField(
                controller: controller.confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              
              // Error Message
              if (controller.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              
              // Success Message
              if (controller.successMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    controller.successMessage.value,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              
              // Submit Button
              ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.changePassword(),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Change Password'),
              ),
            ],
          );
        }),
      ),
    );
  }
}