import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import '../data/models/widget_model.dart';
import '../data/models/user_model.dart';
import '../core/utils/helpers.dart';

class ApiService extends getx.GetxService {
  late Dio _dio;
  final GetStorage _storage = GetStorage();
  
  static const String baseUrl = 'https://app.assetworks.ai';
  static const String apiPath = '/api/v1';
  
  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }
  
  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _storage.read('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('REQUEST: ${options.method} ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
        handler.next(response);
      },
      onError: (error, handler) async {
        print('ERROR: ${error.response?.statusCode} ${error.requestOptions.path}');
        
        // Retry on 502 errors
        if (error.response?.statusCode == 502) {
          try {
            final clonedRequest = await _dio.request(
              error.requestOptions.path,
              options: Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              ),
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
            );
            return handler.resolve(clonedRequest);
          } catch (e) {
            handler.next(error);
          }
        } else {
          handler.next(error);
        }
      },
    ));
  }
  
  // Auth endpoints
  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      final response = await _dio.post('$apiPath/auth/signin', data: {
        'email': email,
        'password': password,
      });
      
      if (response.data['token'] != null) {
        _storage.write('auth_token', response.data['token']);
      }
      
      return response.data;
    } on DioException catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }
  
  Future<Map<String, dynamic>?> signUp(String email, String password, String name) async {
    try {
      final response = await _dio.post('$apiPath/auth/signup', data: {
        'email': email,
        'password': password,
        'name': name,
      });
      
      if (response.data['token'] != null) {
        _storage.write('auth_token', response.data['token']);
      }
      
      return response.data;
    } on DioException catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }
  
  // User endpoints
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('$apiPath/users/profile/$userId');
      return response.data;
    } on DioException catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }
  
  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('$apiPath/users/profile/update', data: data);
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }
  
  Future<Map<String, int>> getUserStats(String userId) async {
    try {
      final response = await _dio.get('$apiPath/users/stats/$userId');
      return Map<String, int>.from(response.data);
    } on DioException catch (e) {
      print('Get stats error: $e');
      return {};
    }
  }
  
  Future<bool> checkFollowing(String userId) async {
    try {
      final response = await _dio.get('$apiPath/users/profile/following/$userId');
      return response.data['isFollowing'] ?? false;
    } on DioException catch (e) {
      print('Check following error: $e');
      return false;
    }
  }
  
  Future<bool> followUser(String userId) async {
    try {
      final response = await _dio.post('$apiPath/users/profile/follow/$userId');
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      print('Follow user error: $e');
      return false;
    }
  }
  
  Future<bool> unfollowUser(String userId) async {
    try {
      final response = await _dio.delete('$apiPath/users/profile/follow/$userId');
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Unfollow user error: $e');
      return false;
    }
  }
  
  // Widget endpoints
  Future<List<WidgetModel>> getDashboardWidgets() async {
    try {
      final response = await _dio.get('$apiPath/widgets/dashboard');
      final List<dynamic> data = response.data['widgets'] ?? response.data ?? [];
      return data.map((json) => WidgetModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print('Get dashboard error: $e');
      return [];
    }
  }
  
  Future<List<WidgetModel>> getSavedWidgets() async {
    try {
      // Get all dashboard widgets and filter for saved ones
      final response = await _dio.get('$apiPath/widgets/dashboard');
      final List<dynamic> data = response.data['widgets'] ?? response.data ?? [];
      final widgets = data.map((json) => WidgetModel.fromJson(json)).toList();
      // Filter for saved widgets (you might need a flag for this)
      return widgets.where((w) => w.isSaved ?? false).toList();
    } on DioException catch (e) {
      print('Get saved widgets error: $e');
      return [];
    }
  }
  
  Future<List<WidgetModel>> getUserWidgets(String userId) async {
    try {
      final response = await _dio.get('$apiPath/widgets/user/$userId');
      final List<dynamic> data = response.data['widgets'] ?? response.data ?? [];
      return data.map((json) => WidgetModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print('Get user widgets error: $e');
      return [];
    }
  }
  
  Future<List<WidgetModel>> getExploreWidgets({int page = 1, int limit = 5}) async {
    try {
      final response = await _dio.get('$apiPath/widgets/explore', queryParameters: {
        'page': page,
        'limit': limit,
      });
      final List<dynamic> data = response.data['widgets'] ?? response.data ?? [];
      return data.map((json) => WidgetModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print('Get explore widgets error: $e');
      return [];
    }
  }
  
  Future<List<WidgetModel>> getTrendingWidgets() async {
    try {
      final response = await _dio.get('$apiPath/widgets/trending');
      final List<dynamic> data = response.data['widgets'] ?? response.data ?? [];
      return data.map((json) => WidgetModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print('Get trending widgets error: $e');
      return [];
    }
  }
  
  Future<bool> saveWidget(String widgetId) async {
    try {
      final response = await _dio.post('$apiPath/widgets/save/$widgetId', data: {
        'visibility': 'public',
      });
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      print('Save widget error: $e');
      return false;
    }
  }
  
  Future<bool> unsaveWidget(String widgetId) async {
    try {
      final response = await _dio.delete('$apiPath/widgets/save/$widgetId');
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Unsave widget error: $e');
      return false;
    }
  }
  
  Future<bool> likeWidget(String widgetId) async {
    try {
      final response = await _dio.post('$apiPath/widgets/like/$widgetId');
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      print('Like widget error: $e');
      return false;
    }
  }
  
  Future<bool> unlikeWidget(String widgetId) async {
    try {
      final response = await _dio.delete('$apiPath/widgets/like/$widgetId');
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Unlike widget error: $e');
      return false;
    }
  }
  
  Future<Map<String, dynamic>?> generateWidget({
    required String prompt,
    required String assetClass,
  }) async {
    try {
      final response = await _dio.post('$apiPath/widgets/generate', data: {
        'prompt': prompt,
        'assetClass': assetClass,
        'visibility': 'public',
      });
      return response.data;
    } on DioException catch (e) {
      print('Generate widget error: $e');
      return null;
    }
  }
  
  Future<bool> deleteWidget(String widgetId) async {
    try {
      final response = await _dio.delete('$apiPath/widgets/$widgetId');
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Delete widget error: $e');
      return false;
    }
  }
}