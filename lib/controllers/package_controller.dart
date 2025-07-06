import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gibe_market/views/package/package_list_screen.dart';
import 'package:latlong2/latlong.dart';
import '../model/package_model.dart';
import '../service/api_service.dart';
import '../utils/app_routes.dart';

class PackageController extends GetxController {
  final ApiService _apiService = ApiService();
  
  // Form fields
  final descriptionController = TextEditingController();
  final categoryIdController = TextEditingController(text: "cmc259rjq0000rzw7a42mrs9x");
  final weightController = TextEditingController();
  final quantityController = TextEditingController();
  final specialInstructionsController = TextEditingController();
  
  // Location data
  final Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  final Rx<LatLng?> dropoffLocation = Rx<LatLng?>(null);
  final RxString pickupAddress = "".obs;
  final RxString dropoffAddress = "".obs;
  
  // Map controller - using Rxn for reactive map controller
  final Rxn<MapController> mapController = Rxn<MapController>();
  final RxDouble mapZoom = 16.0.obs;
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isLocationLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize map controller
    mapController.value = MapController();
    getCurrentLocation();
    
    // Set default values for testing
    descriptionController.text = "Deliver documents to the client";
    weightController.text = "1.2";
    quantityController.text = "3";
    specialInstructionsController.text = "Handle with care";
  }
  
  @override
  void onClose() {
    descriptionController.dispose();
    categoryIdController.dispose();
    weightController.dispose();
    quantityController.dispose();
    specialInstructionsController.dispose();
    super.onClose();
  }
  
  Future<void> getCurrentLocation() async {
    isLocationLoading.value = true;
    try {
      Position position = await _determinePosition();
      currentLocation.value = LatLng(position.latitude, position.longitude);
      
      // Get address from coordinates
      String? address = await _getAddressFromLatLng(position.latitude, position.longitude);
      if (address != null) {
        pickupAddress.value = address;
      } else {
        pickupAddress.value = 'Current Location: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      }
      
      // Center map on current location
      if (currentLocation.value != null && mapController.value != null) {
        mapController.value!.move(currentLocation.value!, mapZoom.value);
      }
    } catch (e) {
      // Fallback to default location (Addis Ababa)
      currentLocation.value = const LatLng(9.03, 38.74);
      pickupAddress.value = 'Default Location: Addis Ababa, Ethiopia';
      
      Get.snackbar(
        'Location Error',
        'Using default location. Please enable location services for better accuracy.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLocationLoading.value = false;
    }
  }
  
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  
  Future<String?> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return '${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}';
      }
    } catch (e) {
      print('Error fetching address: $e');
    }
    return null;
  }
  
  void setDropoffLocation(LatLng location) async {
    dropoffLocation.value = location;
    
    // Show loading state for address
    dropoffAddress.value = "Getting address...";
    
    // Get address for the selected location
    String? address = await _getAddressFromLatLng(location.latitude, location.longitude);
    if (address != null) {
      dropoffAddress.value = address;
    } else {
      dropoffAddress.value = 'Selected Location: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}';
    }
  }
  
  void handleZoomIn() {
    mapZoom.value = (mapZoom.value + 1).clamp(4.0, 19.0);
    if (mapController.value != null) {
      LatLng center = mapController.value!.camera.center;
      mapController.value!.move(center, mapZoom.value);
    }
  }
  
  void handleZoomOut() {
    mapZoom.value = (mapZoom.value - 1).clamp(4.0, 19.0);
    if (mapController.value != null) {
      LatLng center = mapController.value!.camera.center;
      mapController.value!.move(center, mapZoom.value);
    }
  }
  
  void handleCenterMap() {
    if (currentLocation.value != null && mapController.value != null) {
      mapController.value!.move(currentLocation.value!, mapZoom.value);
    }
  }
  
  Future<dynamic> submitPackage(BuildContext context) async {
    // Validate form
    if (!validateForm()) {
      return;
    }
    
    isSubmitting.value = true;
    
    try {
      // Create package object
      final package = Package(
        description: descriptionController.text.trim(),
        categoryId: categoryIdController.text.trim(),
        weight: double.parse(weightController.text.trim()),
        quantity: int.parse(quantityController.text.trim()),
        specialInstructions: specialInstructionsController.text.trim(),
        pickupLocation: PackageLocation(
          latitude: currentLocation.value!.latitude,
          longitude: currentLocation.value!.longitude,
          address: pickupAddress.value,
        ),
        dropoffLocation: PackageLocation(
          latitude: dropoffLocation.value!.latitude,
          longitude: dropoffLocation.value!.longitude,
          address: dropoffAddress.value,
        ),
      );
      
      // Submit to API
      final response = await _apiService.createPackage(package);
      
      // Show success message with theme colors
      Get.snackbar(
        'Success',
        'Package created successfully! Tracking ID: ${response['id'] ?? 'N/A'}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
      
      // Reset form
      resetForm();
      
      // Navigate to package list
      Navigator.push(context, MaterialPageRoute(builder: (_) => PackageListScreen(isHomeFrom: true)));
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create package: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
  
  bool validateForm() {
    if (descriptionController.text.trim().isEmpty) {
      showError('Please enter a package description');
      return false;
    }
    
    if (descriptionController.text.trim().length < 5) {
      showError('Package description must be at least 5 characters');
      return false;
    }
    
    if (categoryIdController.text.trim().isEmpty) {
      showError('Please select a category');
      return false;
    }
    
    String weightText = weightController.text.trim();
    if (weightText.isEmpty) {
      showError('Please enter package weight');
      return false;
    }
    
    double? weight = double.tryParse(weightText);
    if (weight == null || weight <= 0) {
      showError('Please enter a valid weight (greater than 0)');
      return false;
    }
    
    if (weight > 50) {
      showError('Package weight cannot exceed 50kg');
      return false;
    }
    
    String quantityText = quantityController.text.trim();
    if (quantityText.isEmpty) {
      showError('Please enter package quantity');
      return false;
    }
    
    int? quantity = int.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      showError('Please enter a valid quantity (greater than 0)');
      return false;
    }
    
    if (quantity > 100) {
      showError('Package quantity cannot exceed 100 items');
      return false;
    }
    
    if (currentLocation.value == null) {
      showError('Unable to determine pickup location. Please try refreshing location.');
      return false;
    }
    
    if (dropoffLocation.value == null) {
      showError('Please select a dropoff location on the map');
      return false;
    }
    
    // Check if pickup and dropoff are too close (less than 100 meters)
    double distance = Geolocator.distanceBetween(
      currentLocation.value!.latitude,
      currentLocation.value!.longitude,
      dropoffLocation.value!.latitude,
      dropoffLocation.value!.longitude,
    );
    
    if (distance < 100) {
      showError('Dropoff location must be at least 100 meters away from pickup location');
      return false;
    }
    
    return true;
  }
  
  void showError(String message) {
    Get.snackbar(
      'Validation Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning, color: Colors.white),
    );
  }
  
  void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }
  
  void resetForm() {
    descriptionController.clear();
    weightController.clear();
    quantityController.clear();
    specialInstructionsController.clear();
    dropoffLocation.value = null;
    dropoffAddress.value = "";
  }
  
  // Additional helper methods
  void refreshLocation() {
    getCurrentLocation();
  }
  
  String getDistanceText() {
    if (currentLocation.value != null && dropoffLocation.value != null) {
      double distance = Geolocator.distanceBetween(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
        dropoffLocation.value!.latitude,
        dropoffLocation.value!.longitude,
      );
      
      if (distance < 1000) {
        return '${distance.toStringAsFixed(0)} meters';
      } else {
        return '${(distance / 1000).toStringAsFixed(2)} km';
      }
    }
    return 'Distance not calculated';
  }
  
  double? getEstimatedCost() {
    if (currentLocation.value != null && dropoffLocation.value != null) {
      double distance = Geolocator.distanceBetween(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
        dropoffLocation.value!.latitude,
        dropoffLocation.value!.longitude,
      );
      
      // Basic cost calculation: base rate + distance rate + weight rate
      double baseCost = 50.0; // Base delivery cost
      double distanceCost = (distance / 1000) * 15.0; // 15 ETB per km
      double weightCost = 0.0;
      
      if (weightController.text.isNotEmpty) {
        double? weight = double.tryParse(weightController.text);
        if (weight != null) {
          weightCost = weight * 5.0; // 5 ETB per kg
        }
      }
      
      return baseCost + distanceCost + weightCost;
    }
    return null;
  }
  
  // Method to clear all form data
  void clearAllData() {
    resetForm();
    currentLocation.value = null;
    pickupAddress.value = "";
    dropoffLocation.value = null;
    dropoffAddress.value = "";
  }
}
