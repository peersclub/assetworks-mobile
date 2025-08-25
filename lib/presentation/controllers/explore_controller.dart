import 'package:get/get.dart';
import '../../data/models/widget_model.dart';
import '../../services/api_service.dart';
import '../../core/utils/helpers.dart';
import '../../core/theme/ios18_theme.dart';

class ExploreController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  // All tab
  final RxList<WidgetModel> allWidgets = <WidgetModel>[].obs;
  final RxBool isLoadingAll = false.obs;
  final RxBool hasMoreAll = true.obs;
  final RxInt currentPageAll = 1.obs;
  
  // Trending tab
  final RxList<WidgetModel> trendingWidgets = <WidgetModel>[].obs;
  final RxBool isLoadingTrending = false.obs;
  
  // Following tab
  final RxList<WidgetModel> followingWidgets = <WidgetModel>[].obs;
  final RxBool isLoadingFollowing = false.obs;
  final RxBool hasMoreFollowing = true.obs;
  final RxInt currentPageFollowing = 1.obs;
  
  final int pageSize = 5;
  
  @override
  void onInit() {
    super.onInit();
    loadAllWidgets();
  }
  
  Future<void> loadAllWidgets({bool refresh = false}) async {
    if (isLoadingAll.value && !refresh) return;
    
    try {
      if (refresh) {
        currentPageAll.value = 1;
        hasMoreAll.value = true;
      }
      
      isLoadingAll.value = true;
      
      final widgets = await _apiService.getExploreWidgets(
        page: currentPageAll.value,
        limit: pageSize,
      );
      
      if (refresh) {
        allWidgets.value = widgets;
      } else {
        allWidgets.addAll(widgets);
      }
      
      // Check if there are more widgets to load
      hasMoreAll.value = widgets.length >= pageSize;
      
      if (widgets.isNotEmpty) {
        currentPageAll.value++;
      }
    } catch (e) {
      print('Error loading all widgets: $e');
      if (refresh || allWidgets.isEmpty) {
        showToast('Failed to load reports', isError: true);
      }
    } finally {
      isLoadingAll.value = false;
    }
  }
  
  Future<void> loadTrendingWidgets() async {
    if (isLoadingTrending.value) return;
    
    try {
      isLoadingTrending.value = true;
      
      final widgets = await _apiService.getTrendingWidgets();
      trendingWidgets.value = widgets;
      
    } catch (e) {
      print('Error loading trending widgets: $e');
      showToast('Failed to load trending reports', isError: true);
    } finally {
      isLoadingTrending.value = false;
    }
  }
  
  Future<void> loadFollowingWidgets({bool refresh = false}) async {
    if (isLoadingFollowing.value && !refresh) return;
    
    try {
      if (refresh) {
        currentPageFollowing.value = 1;
        hasMoreFollowing.value = true;
      }
      
      isLoadingFollowing.value = true;
      
      // For now, use explore widgets as placeholder
      // In production, this would call a specific endpoint for following feed
      final widgets = await _apiService.getExploreWidgets(
        page: currentPageFollowing.value,
        limit: pageSize,
      );
      
      if (refresh) {
        followingWidgets.value = widgets;
      } else {
        followingWidgets.addAll(widgets);
      }
      
      hasMoreFollowing.value = widgets.length >= pageSize;
      
      if (widgets.isNotEmpty) {
        currentPageFollowing.value++;
      }
    } catch (e) {
      print('Error loading following widgets: $e');
      if (refresh || followingWidgets.isEmpty) {
        showToast('Failed to load following feed', isError: true);
      }
    } finally {
      isLoadingFollowing.value = false;
    }
  }
  
  void switchToAll() {
    if (allWidgets.isEmpty) {
      loadAllWidgets();
    }
  }
  
  void switchToTrending() {
    if (trendingWidgets.isEmpty) {
      loadTrendingWidgets();
    }
  }
  
  void switchToFollowing() {
    if (followingWidgets.isEmpty) {
      loadFollowingWidgets();
    }
  }
  
  void loadMore() {
    // Load more for currently active tab
    if (!isLoadingAll.value && hasMoreAll.value) {
      loadAllWidgets();
    } else if (!isLoadingFollowing.value && hasMoreFollowing.value) {
      loadFollowingWidgets();
    }
  }
  
  Future<void> toggleSaveWidget(WidgetModel widget) async {
    try {
      iOS18Theme.lightImpact();
      
      bool success;
      if (widget.isSaved == true) {
        success = await _apiService.unsaveWidget(widget.id!);
        if (success) {
          _updateWidgetInLists(widget.copyWith(isSaved: false));
          showToast('Removed from saved');
        }
      } else {
        success = await _apiService.saveWidget(widget.id!);
        if (success) {
          _updateWidgetInLists(widget.copyWith(isSaved: true));
          showToast('Added to saved');
        }
      }
    } catch (e) {
      print('Error toggling save: $e');
      showToast('Failed to update save status', isError: true);
    }
  }
  
  void _updateWidgetInLists(WidgetModel updatedWidget) {
    // Update in all lists
    final allIndex = allWidgets.indexWhere((w) => w.id == updatedWidget.id);
    if (allIndex != -1) {
      allWidgets[allIndex] = updatedWidget;
    }
    
    final trendingIndex = trendingWidgets.indexWhere((w) => w.id == updatedWidget.id);
    if (trendingIndex != -1) {
      trendingWidgets[trendingIndex] = updatedWidget;
    }
    
    final followingIndex = followingWidgets.indexWhere((w) => w.id == updatedWidget.id);
    if (followingIndex != -1) {
      followingWidgets[followingIndex] = updatedWidget;
    }
  }
  
  Future<void> refreshAll() async {
    await loadAllWidgets(refresh: true);
  }
  
  Future<void> refreshTrending() async {
    await loadTrendingWidgets();
  }
  
  Future<void> refreshFollowing() async {
    await loadFollowingWidgets(refresh: true);
  }
}