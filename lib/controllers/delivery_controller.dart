// controllers/delivery_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:gibe_market/utils/network.dart';
import 'package:gibe_market/utils/utils.dart';
import 'package:gibe_market/utils/config.dart';

class DeliveryController extends GetxController {
  final RxString deliveryId = ''.obs;
  final RxDouble initialPrice = 0.0.obs;
  
  Future<void> startDelivery({
    required String motoristId,
    required String customerPhone,
    required String source,
    required double sourceLat,
    required double sourceLong,
    required String startTime,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/motorist/delivery/start'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'motoristId': motoristId,
          'customerPhone': customerPhone,
          'source': source,
          'sourceLat': sourceLat,
          'sourceLong': sourceLong,
          'startTime': startTime,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        deliveryId.value = responseData['deliveryId'] as String;
        initialPrice.value = (responseData['initialPrice'] as num?)?.toDouble() ?? 0.0;
        
        // Save to local storage
        // await storage.write('deliveryId', deliveryId.value);
        // await storage.write('initialPrice', initialPrice.value.toString());
      } else {
        throw Exception('Failed to start delivery');
      }
    } catch (e) {
      logger.e("Error starting delivery: $e");
      rethrow;
    }
  }

  Future<void> completeDelivery({
    required String deliveryId,
    required double totalDistance,
    required double totalCost,
    required String status,
    required String endTime,
    required String destination,
    required double destinationLat,
    required double destinationLong,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/motorist/delivery/complete'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'deliveryId': deliveryId,
          'totalDistance': totalDistance,
          'totalCost': totalCost,
          'status': status,
          'endTime': endTime,
          'destination': destination,
          'destinationLat': destinationLat,
          'destinationLong': destinationLong,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Clear local storage
        // await storage.remove('deliveryId');
        // await storage.remove('initialPrice');
        this.deliveryId.value = '';
        initialPrice.value = 0.0;
      } else {
        throw Exception('Failed to complete delivery');
      }
    } catch (e) {
      logger.e("Error completing delivery: $e");
      rethrow;
    }
  }
}