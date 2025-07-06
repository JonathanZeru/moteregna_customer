// lib/controllers/policy_terms_controller.dart
import 'package:get/get.dart';
import 'package:gibe_market/model/about_mode.dart';
import 'package:gibe_market/model/privacy_model.dart';
import 'package:gibe_market/utils/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PolicyTermsController extends GetxController {
  final RxList<PolicyTerms> privacyPolicies = <PolicyTerms>[].obs;
  final RxList<PolicyTerms> termsConditions = <PolicyTerms>[].obs;
  final RxList<About> aboutContent = <About>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxString('');

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await http.get(
        Uri.parse('$apiBaseUrl/privacy-terms/getByType?type=privacy'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        privacyPolicies.assignAll(
          data.map((item) => PolicyTerms.fromJson(item as Map<String, dynamic>)).toList(),
        );
      } else {
        throw Exception('Failed to load privacy policy');
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTermsConditions() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await http.get(
        Uri.parse('$apiBaseUrl/privacy-terms/getByType?type=terms'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        termsConditions.assignAll(
          data.map((item) => PolicyTerms.fromJson(item as Map<String, dynamic>)).toList(),
        );
      } else {
        throw Exception('Failed to load terms and conditions');
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchAbout() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await http.get(
        Uri.parse('$apiBaseUrl/about/getAll'),
      );
      print(response.body);

      if (response.statusCode == 200) {
        final AboutResponse parsedResponse = 
            AboutResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        if (parsedResponse.success) {
          aboutContent.assignAll(parsedResponse.data);
        } else {
          throw Exception('Failed to load privacy policy');
        }
      } else {
        throw Exception('Failed to load privacy policy');
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

}