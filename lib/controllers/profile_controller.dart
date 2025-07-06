// lib/controllers/change_password_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gibe_market/utils/config.dart';
import 'package:http/http.dart' as http;

class EditProfileController extends GetxController {
  final box = GetStorage();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = RxString('');
  final successMessage = RxString('');

 
String? getAccessToken() {
    return box.read<String>('accessToken');
  }
  Future<void> changePassword() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      // Validate inputs
      if (newPasswordController.text != confirmPasswordController.text) {
        throw Exception('New passwords do not match');
      }

      if (newPasswordController.text.length < 6) {
        throw Exception('New password must be at least 6 characters');
      }

      final response = await http.post(
        Uri.parse('$apiBaseUrl/customer/changePassword'),
        headers: {
          'Authorization': 'Bearer ${getAccessToken()}',
          // 'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'currentPassword': currentPasswordController.text,
          'newPassword': newPasswordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        successMessage.value = 'Password changed successfully';
        clearFields();
      } else {
        throw Exception(responseData['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}