import 'dart:convert';
import 'package:gibe_market/controllers/auth_controller.dart';
import 'package:gibe_market/model/package_model.dart';
import 'package:gibe_market/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ApiService {
  final AuthController _authController = Get.find<AuthController>();
  
  Future<dynamic> createPackage(Package package) async {
    final token = _authController.getToken();
    
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    print(package);
    
    final response = await http.post(
      Uri.parse('$apiBaseUrl/customer/createPackage'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(package.toJson()),
    );
    print(response.body);
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create package: ${response.body}');
    }
  }
  Future<dynamic> signUp(Map<String, dynamic> data) async {
    
    final response = await http.post(
      Uri.parse('$apiBaseUrl/customer/signup'),
      body: jsonEncode(data),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to sign up: ${response.body}');
      return false;
    }
  }
// Add this to your ApiService class
  Future<dynamic> getPackages() async {
    final token = _authController.getToken();

    if (token == null) {
      throw Exception('Authentication token not found');
    }
    print("token = $token");

    final response = await http.get(
      Uri.parse('$apiBaseUrl/customer/getPackages'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print("response = ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load packages: ${response.body}');
    }
  }
}
