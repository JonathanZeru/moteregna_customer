import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MotoristController extends GetxController {
  final box = GetStorage();
  final String apiBaseUrl = 'http://134.122.27.115:3001/api';
  
  // Observable variables
  final RxBool delivering = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdatingOnlineStatus = false.obs;
  final Rx<Map<String, dynamic>> motoristData = Rx<Map<String, dynamic>>({});
  final Rx<Map<String, dynamic>> userData = Rx<Map<String, dynamic>>({});
  
  // Computed properties for easy access
  bool get isOnline => motoristData.value['isOnline'] is bool ? motoristData.value['isOnline'] as bool : false;
  bool get isAvailable => motoristData.value['isAvailable'] is bool ? motoristData.value['isAvailable'] as bool : false;
  String get motoristId => motoristData.value['id']?.toString() ?? '';
  String get name => motoristData.value['name']?.toString() ?? '';
  String get email => motoristData.value['email']?.toString() ?? '';
  String get phone => motoristData.value['phone']?.toString() ?? '';
  String get address => motoristData.value['address']?.toString() ?? '';
  String get licenseNumber => motoristData.value['licenseNumber']?.toString() ?? '';
  String get vehicleModel => motoristData.value['vehicleModel']?.toString() ?? '';
  String get vehiclePlate => motoristData.value['vehiclePlate']?.toString() ?? '';
  String get vehicleYear => motoristData.value['vehicleYear']?.toString() ?? '';
  String get vehicleColor => motoristData.value['vehicleColor']?.toString() ?? '';
  String get status => motoristData.value['status']?.toString() ?? '';
  String get profilePhoto => motoristData.value['profilePhoto']?.toString() ?? '';
  String get licensePhoto => motoristData.value['licensePhoto']?.toString() ?? '';
  String get vehiclePhoto => motoristData.value['vehiclePhoto']?.toString() ?? '';
  String get businessPermitPhoto => motoristData.value['businessPermitPhoto']?.toString() ?? '';
  DateTime get registrationDate => DateTime.tryParse(motoristData.value['registrationDate']?.toString() ?? '') ?? DateTime.now();
  
  // User sub-object properties
  String get userId => userData.value['id']?.toString() ?? '';
  String get firstName => userData.value['firstName']?.toString() ?? '';
  String get middleName => userData.value['middleName']?.toString() ?? '';
  String get lastName => userData.value['lastName']?.toString() ?? '';
  String get gender => userData.value['gender']?.toString() ?? '';
  DateTime get birthdate => DateTime.tryParse(userData.value['birthdate']?.toString() ?? '') ?? DateTime.now();
  String get userProfile => userData.value['profile']?.toString() ?? '';
  bool? get isLoggedIn => userData.value['isLoggedIn'] as bool?;
  bool? get userStatus => userData.value['status'] as bool?;
  DateTime get createdAt => DateTime.tryParse(userData.value['createdAt']?.toString() ?? '') ?? DateTime.now();
  DateTime get updatedAt => DateTime.tryParse(userData.value['updatedAt']?.toString() ?? '') ?? DateTime.now();

  @override
  void onInit() {
    super.onInit();
    fetchMotoristData();
  }

 
Future<bool> fetchMotoristData() async {
  final motorId = getMotoristId();
  if (motorId == null) {
    print('Cannot fetch motorist data: Motorist ID is null');
    return false;
  }

  final accessToken = getAccessToken();
  if (accessToken == null) {
    print('Cannot fetch motorist data: Access token is null');
    return false;
  }

  isLoading.value = true;
  update();

  try {
    final response = await http.get(
      Uri.parse('$apiBaseUrl/customer/profile'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    print("response.body = = = = = = ${response.body} === = = = = == ");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      box.write('customerData', responseData);
      print('Motorist data fetched and stored successfully');
      return true;
    } else {
      print('Failed to fetch motorist data: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error fetching motorist data: $e');
    return false;
  } finally {
    isLoading.value = false;
    update();
  }
}

Future<bool> updateOnlineStatus(bool isOnline) async {
  final motorId = getMotoristId();
  if (motorId == null) {
    print('Cannot update online status: Motorist ID is null');
    return false;
  }

  final accessToken = getAccessToken();
  if (accessToken == null) {
    print('Cannot update online status: Access token is null');
    return false;
  }

  isUpdatingOnlineStatus.value = true;
  update();

  try {
    print({
        'motoristId': motorId,
        'isOnline': isOnline,
      });
    final response = await http.post(
      Uri.parse('$apiBaseUrl/motorist/isOnline'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'motoristId': motorId,
        'isOnline': isOnline,
      }),
    );
    print(response);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final updatedMotorist = responseData['motorist'];

      // Update the reactive variable
      motoristData.value['isOnline'] = updatedMotorist['isOnline'];

      // Update GetStorage with the new value
      final storedMotorData = box.read('motorData') ?? {};
      storedMotorData['isOnline'] = updatedMotorist['isOnline'];
      box.write('motorData', storedMotorData); // <- make sure you're writing to 'motorData'

      print('Online status updated successfully to: ${updatedMotorist['isOnline']}');
      return true;
    } else {
      print('Failed to update online status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error updating online status: $e');
    return false;
  } finally {
    isUpdatingOnlineStatus.value = false;
    update();
  }
}


  String? getMotoristId() {
    try {
       final box = GetStorage(); // Access GetStorage

    final userData = box.read('motorData');

    // Extract data from the stored userData
    final String userId = userData['id'].toString();
        return userId;
    } catch (e) {
      print('Error getting motorist ID: $e');
      return null;
    }
  }

  String? getAccessToken() {
    return box.read<String>('accessToken');
  }
}
