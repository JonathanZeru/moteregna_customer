import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gibe_market/service/api_service.dart';
import 'package:gibe_market/utils/app_routes.dart';
import 'package:gibe_market/utils/network.dart';
import 'package:gibe_market/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class SignUpController extends GetxController {
  
  final ApiService _apiService = ApiService();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final faidaController = TextEditingController();
  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final RxInt currentStep = 0.obs;

  // Track previous step for animation direction
  // Image files
  final String apiUrl = 'http://134.122.27.115:3000/api/auth/signup';

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool validateStep(int step) {
    logger.e("Validating step = $step");
  return validatePersonalInfo();
  }

  bool validatePersonalInfo() {
    if (firstNameController.text.trim().isEmpty) {
      showErrorSnackbar('First name is required.');
      return false;
    }
    if (lastNameController.text.trim().isEmpty) {
      showErrorSnackbar('Last name is required.');
      return false;
    }
     if (phoneController.text.trim().isEmpty) {
      showErrorSnackbar('Phone number is required.');
      return false;
    }
    if (!GetUtils.isPhoneNumber(phoneController.text.trim())) {
      showErrorSnackbar('Please enter a valid phone number.');
      return false;
    }
      
    if (passwordController.text.trim().isEmpty) {
      showErrorSnackbar('Password is required.');
      return false;
    }
    if (passwordController.text.trim().length < 6) {
      showErrorSnackbar('Password must be at least 6 characters long.');
      return false;
    }
    if (confirmPasswordController.text.trim() !=
        passwordController.text.trim()) {
      showErrorSnackbar('Passwords do not match.');
      return false;
    }
   
    
    return true;
  }
  
  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Validation Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      borderRadius: 15,
      margin: EdgeInsets.all(10),
      borderColor: Colors.red.shade300,
      borderWidth: 1,
      boxShadows: [
        BoxShadow(
          color: Colors.red.withOpacity(0.5),
          blurRadius: 10,
          spreadRadius: 2,
        )
      ],
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      icon: Icon(
        FontAwesomeIcons.circleExclamation,
        color: Colors.white,
      ),
    );
  }

  void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      borderRadius: 15,
      margin: EdgeInsets.all(10),
      borderColor: Colors.green.shade300,
      borderWidth: 1,
      boxShadows: [
        BoxShadow(
          color: Colors.green.withOpacity(0.5),
          blurRadius: 10,
          spreadRadius: 2,
        )
      ],
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      icon: Icon(
        FontAwesomeIcons.circleCheck,
        color: Colors.white,
      ),
    );
  }

 Future<void> handleSignUp() async {
  if (isLoading.value) return;
  
  // Validate all steps before submitting
  if (!validatePersonalInfo()) {
    print("Validation failed. Exiting sign-up process.");
    return;
  }
  
  print("Starting the sign-up process...");
  
  isLoading.value = true;
  
  try {

    final response = await _apiService.signUp({
  "firstName": firstNameController.text.trim(),
  "lastName": lastNameController.text.trim(),
  "phone": phoneController.text.trim(),
  "password": passwordController.text.trim(),
      "address":faidaController.text.trim()
});
firstNameController.clear();
lastNameController.clear();
phoneController.clear();
passwordController.clear();
confirmPasswordController.clear();
faidaController.clear();
      
      // Show success message
      Get.snackbar(
        'Success',
        'Sign up successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
     Get.toNamed(AppRoutes.signIn);
  } catch (e) {
    logger.e("Error during sign up: $e");
    print("Error during sign-up: $e");
    showErrorSnackbar('An error occurred. Please try again.');
  } finally {
    isLoading.value = false;
    print("Sign-up process finished.");
  }
}


  @override
  void onClose() {
    // Dispose controllers
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}