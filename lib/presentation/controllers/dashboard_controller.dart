import 'package:get/get.dart';
import '../../data/models/widget_model.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../core/utils/helpers.dart';

enum DashboardTab { myReports, savedReports }

class DashboardController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();
  
  final RxBool isLoading = false.obs;
  final RxList<WidgetModel> myReports = <WidgetModel>[].obs;
  final RxList<WidgetModel> savedReports = <WidgetModel>[].obs;
  final Rx<DashboardTab> currentTab = DashboardTab.myReports.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadWidgets();
  }
  
  Future<void> loadWidgets() async {
    try {
      isLoading.value = true;
      
      // Load my reports (created by current user)
      final allWidgets = await _apiService.getDashboardWidgets();
      
      // Filter widgets based on author
      final currentUserId = _authService.currentUser.value?.id;
      if (currentUserId != null) {
        myReports.value = allWidgets
            .where((w) => w.authorId == currentUserId)
            .toList();
      } else {
        myReports.value = allWidgets;
      }
      
      // Load saved reports
      savedReports.value = await _apiService.getSavedWidgets();
      
    } catch (e) {
      print('Error loading dashboard widgets: $e');
      showToast('Failed to load reports', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
  
  void switchTab(DashboardTab tab) {
    if (currentTab.value == tab) return;
    
    iOS18Theme.selectionClick();
    currentTab.value = tab;
  }
  
  List<WidgetModel> get displayedWidgets {
    return currentTab.value == DashboardTab.myReports
        ? myReports
        : savedReports;
  }
  
  Future<void> toggleSaveWidget(WidgetModel widget) async {
    try {
      iOS18Theme.lightImpact();
      
      final widgetIndex = myReports.indexWhere((w) => w.id == widget.id);
      if (widgetIndex == -1) return;
      
      bool success;
      if (widget.isSaved == true) {
        success = await _apiService.unsaveWidget(widget.id!);
        if (success) {
          // Update widget state
          myReports[widgetIndex] = widget.copyWith(isSaved: false);
          // Remove from saved reports
          savedReports.removeWhere((w) => w.id == widget.id);
          showToast('Removed from saved');
        }
      } else {
        success = await _apiService.saveWidget(widget.id!);
        if (success) {
          // Update widget state
          final updatedWidget = widget.copyWith(isSaved: true);
          myReports[widgetIndex] = updatedWidget;
          // Add to saved reports
          if (!savedReports.any((w) => w.id == widget.id)) {
            savedReports.add(updatedWidget);
          }
          showToast('Added to saved');
        }
      }
    } catch (e) {
      print('Error toggling save: $e');
      showToast('Failed to update save status', isError: true);
    }
  }
  
  Future<void> deleteWidget(String widgetId) async {
    try {
      final success = await _apiService.deleteWidget(widgetId);
      
      if (success) {
        myReports.removeWhere((w) => w.id == widgetId);
        savedReports.removeWhere((w) => w.id == widgetId);
        showToast('Report deleted');
      } else {
        showToast('Failed to delete report', isError: true);
      }
    } catch (e) {
      print('Error deleting widget: $e');
      showToast('Failed to delete report', isError: true);
    }
  }
  
  Future<void> refresh() async {
    await loadWidgets();
  }
}