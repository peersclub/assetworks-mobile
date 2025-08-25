import 'package:get/get.dart';
import '../../services/api_service.dart';
import '../../core/utils/helpers.dart';
import 'dashboard_controller.dart';

class CreateWidgetController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  final RxString selectedAssetClass = ''.obs;
  final RxBool canGenerate = false.obs;
  final RxBool isGenerating = false.obs;
  final RxString generationStatus = ''.obs;
  final RxDouble generationProgress = 0.0.obs;
  
  // Advanced options
  final RxBool includeTechnicalAnalysis = true.obs;
  final RxBool includeFundamentalAnalysis = true.obs;
  final RxBool includeMarketSentiment = false.obs;
  final RxBool includePricePredictions = false.obs;
  
  Future<bool> generateWidget({
    required String prompt,
    required String assetClass,
  }) async {
    try {
      isGenerating.value = true;
      generationStatus.value = 'Preparing your analysis...';
      generationProgress.value = 0.1;
      
      // Build enhanced prompt with options
      String enhancedPrompt = prompt;
      List<String> analysisTypes = [];
      
      if (includeTechnicalAnalysis.value) {
        analysisTypes.add('technical analysis');
      }
      if (includeFundamentalAnalysis.value) {
        analysisTypes.add('fundamental analysis');
      }
      if (includeMarketSentiment.value) {
        analysisTypes.add('market sentiment');
      }
      if (includePricePredictions.value) {
        analysisTypes.add('price predictions');
      }
      
      if (analysisTypes.isNotEmpty) {
        enhancedPrompt += '\n\nInclude: ${analysisTypes.join(', ')}';
      }
      
      // Simulate progress updates
      _updateProgress();
      
      // Call API to generate widget
      final result = await _apiService.generateWidget(
        prompt: enhancedPrompt,
        assetClass: assetClass.toLowerCase(),
      );
      
      if (result != null) {
        generationStatus.value = 'Report generated successfully!';
        generationProgress.value = 1.0;
        
        // Refresh dashboard to show new widget
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.loadWidgets();
        
        showToast('Report created successfully!');
        return true;
      } else {
        showToast('Failed to generate report', isError: true);
        return false;
      }
    } catch (e) {
      print('Error generating widget: $e');
      showToast('Failed to generate report', isError: true);
      return false;
    } finally {
      isGenerating.value = false;
      generationStatus.value = '';
      generationProgress.value = 0.0;
    }
  }
  
  void _updateProgress() {
    // Simulate progress updates
    Future.delayed(const Duration(milliseconds: 500), () {
      if (isGenerating.value) {
        generationStatus.value = 'Analyzing market data...';
        generationProgress.value = 0.3;
      }
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (isGenerating.value) {
        generationStatus.value = 'Processing indicators...';
        generationProgress.value = 0.5;
      }
    });
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (isGenerating.value) {
        generationStatus.value = 'Generating insights...';
        generationProgress.value = 0.7;
      }
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (isGenerating.value) {
        generationStatus.value = 'Finalizing report...';
        generationProgress.value = 0.9;
      }
    });
  }
  
  void cancelGeneration() {
    isGenerating.value = false;
    generationStatus.value = '';
    generationProgress.value = 0.0;
    showToast('Generation cancelled');
  }
}