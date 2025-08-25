import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/models/user_model.dart';
import 'api_service.dart';

class AuthService extends GetxService {
  final GetStorage _storage = GetStorage();
  final ApiService _apiService = Get.find<ApiService>();
  
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isAuthenticated = false.obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    final token = _storage.read('auth_token');
    if (token != null) {
      // Try to get user profile with stored token
      await getCurrentUser();
    }
  }
  
  Future<bool> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      
      final response = await _apiService.signIn(email, password);
      
      if (response != null && response['user'] != null) {
        currentUser.value = UserModel.fromJson(response['user']);
        isAuthenticated.value = true;
        
        // Store user data
        _storage.write('user_data', response['user']);
        
        return true;
      }
      
      return false;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<bool> signUp(String email, String password, String name) async {
    try {
      isLoading.value = true;
      
      final response = await _apiService.signUp(email, password, name);
      
      if (response != null && response['user'] != null) {
        currentUser.value = UserModel.fromJson(response['user']);
        isAuthenticated.value = true;
        
        // Store user data
        _storage.write('user_data', response['user']);
        
        return true;
      }
      
      return false;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> getCurrentUser() async {
    try {
      final userData = _storage.read('user_data');
      if (userData != null) {
        currentUser.value = UserModel.fromJson(userData);
        isAuthenticated.value = true;
      }
    } catch (e) {
      print('Get current user error: $e');
    }
  }
  
  void signOut() {
    currentUser.value = null;
    isAuthenticated.value = false;
    
    // Clear storage
    _storage.remove('auth_token');
    _storage.remove('user_data');
    
    // Navigate to auth screen
    Get.offAllNamed('/auth');
  }
}