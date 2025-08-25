import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/ios18_theme.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../widgets/ios/ios_widget_card.dart';
import '../../../widgets/ios/ios_loader.dart';

class IOSDashboardScreenTabs extends StatefulWidget {
  const IOSDashboardScreenTabs({super.key});
  
  @override
  State<IOSDashboardScreenTabs> createState() => _IOSDashboardScreenTabsState();
}

class _IOSDashboardScreenTabsState extends State<IOSDashboardScreenTabs> {
  final DashboardController _controller = Get.put(DashboardController());
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: iOS18Theme.background,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Dashboard'),
            backgroundColor: iOS18Theme.background.withOpacity(0.5),
            border: null,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                CupertinoIcons.add_circled,
                color: iOS18Theme.accentBlue,
                size: 28,
              ),
              onPressed: () {
                Get.toNamed('/create');
              },
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () => _controller.refresh(),
          ),
          SliverToBoxAdapter(
            child: _buildTabBar(),
          ),
          Obx(() {
            if (_controller.isLoading.value) {
              return SliverFillRemaining(
                child: Center(
                  child: IOSLoader(
                    message: 'Loading reports...',
                  ),
                ),
              );
            }
            
            final widgets = _controller.displayedWidgets;
            
            if (widgets.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: _buildEmptyState(),
                ),
              );
            }
            
            return SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final widget = widgets[index];
                    return IOSWidgetCard(
                      widget: widget,
                      onTap: () => _navigateToWidget(widget),
                      onShareTap: () => _shareWidget(widget),
                      onBookmarkTap: () => _controller.toggleSaveWidget(widget),
                      compact: true,
                    );
                  },
                  childCount: widgets.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildTabBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(() => Container(
        decoration: BoxDecoration(
          color: iOS18Theme.secondaryFill,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  iOS18Theme.lightImpact();
                  _controller.switchTab(DashboardTab.myReports);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: _controller.currentTab.value == DashboardTab.myReports
                        ? iOS18Theme.background
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _controller.currentTab.value == DashboardTab.myReports
                        ? [
                            BoxShadow(
                              color: iOS18Theme.separator.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      'My Reports',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: _controller.currentTab.value == DashboardTab.myReports
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: _controller.currentTab.value == DashboardTab.myReports
                            ? iOS18Theme.primaryLabel
                            : iOS18Theme.secondaryLabel,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  iOS18Theme.lightImpact();
                  _controller.switchTab(DashboardTab.savedReports);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: _controller.currentTab.value == DashboardTab.savedReports
                        ? iOS18Theme.background
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _controller.currentTab.value == DashboardTab.savedReports
                        ? [
                            BoxShadow(
                              color: iOS18Theme.separator.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      'Saved Reports',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: _controller.currentTab.value == DashboardTab.savedReports
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: _controller.currentTab.value == DashboardTab.savedReports
                            ? iOS18Theme.primaryLabel
                            : iOS18Theme.secondaryLabel,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
  
  Widget _buildEmptyState() {
    return Obx(() {
      final isMyReports = _controller.currentTab.value == DashboardTab.myReports;
      
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isMyReports ? LucideIcons.fileText : CupertinoIcons.bookmark,
            size: 64,
            color: iOS18Theme.tertiaryLabel,
          ),
          const SizedBox(height: 16),
          Text(
            isMyReports ? 'No reports yet' : 'No saved reports',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: iOS18Theme.primaryLabel,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isMyReports
                ? 'Create your first report to get started'
                : 'Save reports to access them here',
            style: TextStyle(
              fontSize: 16,
              color: iOS18Theme.secondaryLabel,
            ),
            textAlign: TextAlign.center,
          ),
          if (isMyReports) ...[
            const SizedBox(height: 24),
            CupertinoButton(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iOS18Theme.accentBlue,
                      iOS18Theme.accentPurple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Create Report',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onPressed: () {
                Get.toNamed('/create');
              },
            ),
          ],
        ],
      );
    });
  }
  
  void _navigateToWidget(widget) {
    iOS18Theme.selectionClick();
    // Navigate to widget detail
  }
  
  void _shareWidget(widget) {
    iOS18Theme.lightImpact();
    // Implement share functionality
  }
}