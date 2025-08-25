import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/models/widget_model.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../core/utils/helpers.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();
  
  final RxBool isLoading = false.obs;
  final RxBool isOwnProfile = true.obs;
  final RxBool isFollowing = false.obs;
  
  final Rx<UserModel?> userProfile = Rx<UserModel?>(null);
  final RxList<WidgetModel> userWidgets = <WidgetModel>[].obs;
  final RxMap<String, int> profileStats = <String, int>{}.obs;
  
  String? _currentUserId;

  Future<void> loadProfile(String? userId) async {
    try {
      isLoading.value = true;
      
      // If no userId provided, load own profile
      _currentUserId = userId ?? _authService.currentUser.value?.id;
      isOwnProfile.value = userId == null || userId == _authService.currentUser.value?.id;
      
      if (_currentUserId == null) {
        showToast('Unable to load profile', isError: true);
        return;
      }
      
      // Load user profile
      final profileData = await _apiService.getUserProfile(_currentUserId!);
      if (profileData != null) {
        userProfile.value = UserModel.fromJson(profileData);
        
        // Check if following (for other users' profiles)
        if (!isOwnProfile.value) {
          isFollowing.value = await _apiService.checkFollowing(_currentUserId!);
        }
      }
      
      // Load user's widgets
      final widgets = await _apiService.getUserWidgets(_currentUserId!);
      userWidgets.value = widgets;
      
      // Load profile stats
      await loadProfileStats();
      
    } catch (e) {
      print('Error loading profile: $e');
      showToast('Failed to load profile', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadProfileStats() async {
    try {
      final stats = await _apiService.getUserStats(_currentUserId!);
      profileStats.value = {
        'widgetsCount': stats['widgetsCount'] ?? userWidgets.length,
        'followersCount': stats['followersCount'] ?? 0,
        'followingCount': stats['followingCount'] ?? 0,
      };
    } catch (e) {
      print('Error loading stats: $e');
      // Use fallback values
      profileStats.value = {
        'widgetsCount': userWidgets.length,
        'followersCount': 0,
        'followingCount': 0,
      };
    }
  }
  
  Future<void> toggleFollow() async {
    if (_currentUserId == null || isOwnProfile.value) return;
    
    try {
      iOS18Theme.lightImpact();
      
      bool success;
      if (isFollowing.value) {
        success = await _apiService.unfollowUser(_currentUserId!);
        if (success) {
          isFollowing.value = false;
          profileStats['followersCount'] = (profileStats['followersCount'] ?? 1) - 1;
          showToast('Unfollowed');
        }
      } else {
        success = await _apiService.followUser(_currentUserId!);
        if (success) {
          isFollowing.value = true;
          profileStats['followersCount'] = (profileStats['followersCount'] ?? 0) + 1;
          showToast('Following');
        }
      }
    } catch (e) {
      print('Error toggling follow: $e');
      showToast('Failed to update follow status', isError: true);
    }
  }
  
  Future<void> updateProfile({
    required String name,
    required String bio,
  }) async {
    try {
      isLoading.value = true;
      
      final success = await _apiService.updateUserProfile({
        'name': name,
        'bio': bio,
      });
      
      if (success) {
        // Update local profile
        if (userProfile.value != null) {
          userProfile.value = userProfile.value!.copyWith(
            name: name,
            bio: bio,
          );
        }
        
        // Update auth service user
        if (_authService.currentUser.value != null) {
          _authService.currentUser.value = _authService.currentUser.value!.copyWith(
            name: name,
            bio: bio,
          );
        }
        
        showToast('Profile updated');
      } else {
        showToast('Failed to update profile', isError: true);
      }
    } catch (e) {
      print('Error updating profile: $e');
      showToast('Failed to update profile', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
  
  void signOut() {
    _authService.signOut();
    Get.offAllNamed('/auth');
  }
}