import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gibe_market/controllers/motorist_controller.dart';
import 'package:gibe_market/utils/firebase_service.dart';
import 'package:gibe_market/utils/storages.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:gibe_market/utils/config.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final box = GetStorage();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> handleLogin() async {
    ConfigPreference.markAppLaunched();
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validate if email or password is empty
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both email and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Show loading state
    isLoading.value = true;

    try {
      print("body ");
      print({
          'phone': email,  // Mapping the email field to phone (based on the data you're sending)
          'password': password,
        });
      // Send the login request to the endpoint
      final response = await http.post(
        Uri.parse('$apiBaseUrl/customer/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': email,  // Mapping the email field to phone (based on the data you're sending)
          'password': password,
        }),
      );
      print(response.body);

      // Parse the response
      final responseData = json.decode(response.body);

      // If login is successful
      if (response.statusCode == 200) { 
        // Save the returned data in local storage
        box.write('token', responseData['token']);
        box.write('customerData', responseData['customer']); 
        ConfigPreference.storeAccessToken(responseData['token'].toString());
    Get.lazyPut<MotoristController>(() => MotoristController(), fenix: true);
  await FirebaseService().init();
        // Show success snackbar
        passwordController.clear();
        emailController.clear();
          
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to the home screen
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed('/mainScreen');
        });
      } else {
        // Show error if response status is not 200
        Get.snackbar(
          'Error',
          'Login failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle any errors during the request
      Get.snackbar(
        'Error',
        'An error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Hide the loading state
      isLoading.value = false;
    }
  }
}
