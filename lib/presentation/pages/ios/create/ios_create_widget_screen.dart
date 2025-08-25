import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/ios18_theme.dart';
import '../../../controllers/create_widget_controller.dart';
import '../../../widgets/ios/ios_loader.dart';

class IOSCreateWidgetScreen extends StatefulWidget {
  const IOSCreateWidgetScreen({super.key});
  
  @override
  State<IOSCreateWidgetScreen> createState() => _IOSCreateWidgetScreenState();
}

class _IOSCreateWidgetScreenState extends State<IOSCreateWidgetScreen> {
  final CreateWidgetController _controller = Get.put(CreateWidgetController());
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<Map<String, dynamic>> assetClasses = [
    {'name': 'Stocks', 'icon': LucideIcons.trendingUp, 'color': CupertinoColors.systemBlue},
    {'name': 'Crypto', 'icon': LucideIcons.bitcoin, 'color': CupertinoColors.systemOrange},
    {'name': 'Forex', 'icon': LucideIcons.dollarSign, 'color': CupertinoColors.systemGreen},
    {'name': 'Commodities', 'icon': LucideIcons.barChart3, 'color': CupertinoColors.systemYellow},
    {'name': 'Indices', 'icon': LucideIcons.lineChart, 'color': CupertinoColors.systemPurple},
    {'name': 'Bonds', 'icon': LucideIcons.fileText, 'color': CupertinoColors.systemTeal},
    {'name': 'Real Estate', 'icon': LucideIcons.home, 'color': CupertinoColors.systemPink},
    {'name': 'ETFs', 'icon': LucideIcons.package, 'color': CupertinoColors.systemIndigo},
  ];
  
  final List<String> quickSuggestions = [
    'Market analysis for tech stocks',
    'Bitcoin price prediction',
    'EUR/USD technical analysis',
    'Gold market outlook',
    'S&P 500 performance review',
    'Treasury bond yields analysis',
    'Real estate market trends',
    'Top performing ETFs this month',
  ];
  
  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: iOS18Theme.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: iOS18Theme.background.withOpacity(0.5),
        border: null,
        middle: Text('Create Report'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(
            'Generate',
            style: TextStyle(
              color: iOS18Theme.accentBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: _controller.canGenerate.value ? _generateWidget : null,
        ),
      ),
      child: SafeArea(
        child: Obx(() {
          if (_controller.isGenerating.value) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IOSLoader(
                      message: _controller.generationStatus.value,
                      showProgress: _controller.generationProgress.value > 0,
                      progress: _controller.generationProgress.value,
                    ),
                    const SizedBox(height: 24),
                    CupertinoButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        _controller.cancelGeneration();
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          
          return CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Asset Class Selection
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Asset Class',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: iOS18Theme.primaryLabel,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: assetClasses.length,
                        itemBuilder: (context, index) {
                          final assetClass = assetClasses[index];
                          final isSelected = _controller.selectedAssetClass.value == assetClass['name'];
                          
                          return CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? assetClass['color'].withOpacity(0.15)
                                    : iOS18Theme.secondaryFill,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? assetClass['color']
                                      : iOS18Theme.separator,
                                  width: isSelected ? 2 : 0.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    assetClass['icon'],
                                    size: 28,
                                    color: isSelected
                                        ? assetClass['color']
                                        : iOS18Theme.secondaryLabel,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    assetClass['name'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected
                                          ? assetClass['color']
                                          : iOS18Theme.secondaryLabel,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              iOS18Theme.selectionClick();
                              _controller.selectedAssetClass.value = assetClass['name'];
                              _updateCanGenerate();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              // Prompt Input
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What would you like to analyze?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: iOS18Theme.primaryLabel,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CupertinoTextField(
                        controller: _promptController,
                        placeholder: 'Describe your analysis request...',
                        maxLines: 4,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: iOS18Theme.secondaryFill,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: iOS18Theme.separator,
                            width: 0.5,
                          ),
                        ),
                        style: TextStyle(
                          color: iOS18Theme.primaryLabel,
                          fontSize: 16,
                        ),
                        placeholderStyle: TextStyle(
                          color: iOS18Theme.tertiaryLabel,
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                          _updateCanGenerate();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              // Quick Suggestions
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Suggestions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: iOS18Theme.primaryLabel,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: quickSuggestions.map((suggestion) {
                          return CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: iOS18Theme.tertiaryFill,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                suggestion,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: iOS18Theme.primaryLabel,
                                ),
                              ),
                            ),
                            onPressed: () {
                              iOS18Theme.selectionClick();
                              _promptController.text = suggestion;
                              _updateCanGenerate();
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Advanced Options
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Advanced Options',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: iOS18Theme.primaryLabel,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: iOS18Theme.secondaryFill,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildOptionRow(
                              'Include Technical Analysis',
                              _controller.includeTechnicalAnalysis,
                              (value) => _controller.includeTechnicalAnalysis.value = value,
                            ),
                            Container(height: 0.5, color: iOS18Theme.separator),
                            _buildOptionRow(
                              'Include Fundamental Analysis',
                              _controller.includeFundamentalAnalysis,
                              (value) => _controller.includeFundamentalAnalysis.value = value,
                            ),
                            Container(height: 0.5, color: iOS18Theme.separator),
                            _buildOptionRow(
                              'Include Market Sentiment',
                              _controller.includeMarketSentiment,
                              (value) => _controller.includeMarketSentiment.value = value,
                            ),
                            Container(height: 0.5, color: iOS18Theme.separator),
                            _buildOptionRow(
                              'Include Price Predictions',
                              _controller.includePricePredictions,
                              (value) => _controller.includePricePredictions.value = value,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          );
        }),
      ),
    );
  }
  
  Widget _buildOptionRow(String title, RxBool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: iOS18Theme.primaryLabel,
            ),
          ),
          Obx(() => CupertinoSwitch(
            value: value.value,
            onChanged: onChanged,
            activeColor: iOS18Theme.accentBlue,
          )),
        ],
      ),
    );
  }
  
  void _updateCanGenerate() {
    _controller.canGenerate.value = 
        _controller.selectedAssetClass.value.isNotEmpty &&
        _promptController.text.trim().isNotEmpty;
  }
  
  void _generateWidget() async {
    if (!_controller.canGenerate.value) return;
    
    iOS18Theme.mediumImpact();
    
    final success = await _controller.generateWidget(
      prompt: _promptController.text.trim(),
      assetClass: _controller.selectedAssetClass.value,
    );
    
    if (success) {
      Get.back();
      Get.snackbar(
        'Success',
        'Report generated successfully!',
        backgroundColor: iOS18Theme.accentGreen.withOpacity(0.9),
        colorText: CupertinoColors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}