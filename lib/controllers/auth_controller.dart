import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final GetStorage _storage = GetStorage();
  
  String? getToken() {
    return _storage.read('token');
  }
  
  bool isAuthenticated() {
    return getToken() != null;
  }
}
