import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/ios18_theme.dart';
import '../../../controllers/explore_controller.dart';
import '../../../widgets/ios/ios_widget_card.dart';
import '../../../widgets/ios/ios_loader.dart';

class IOSExploreScreen extends StatefulWidget {
  const IOSExploreScreen({super.key});
  
  @override
  State<IOSExploreScreen> createState() => _IOSExploreScreenState();
}

class _IOSExploreScreenState extends State<IOSExploreScreen> with SingleTickerProviderStateMixin {
  final ExploreController _controller = Get.put(ExploreController());
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    _scrollController.addListener(_handleScroll);
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      iOS18Theme.selectionClick();
      switch (_tabController.index) {
        case 0:
          _controller.switchToAll();
          break;
        case 1:
          _controller.switchToTrending();
          break;
        case 2:
          _controller.switchToFollowing();
          break;
      }
    }
  }
  
  void _handleScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _controller.loadMore();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: iOS18Theme.background,
      child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              largeTitle: const Text('Explore'),
              backgroundColor: iOS18Theme.background.withOpacity(0.5),
              border: null,
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  CupertinoIcons.search,
                  color: iOS18Theme.primaryLabel,
                ),
                onPressed: () {
                  _showSearchSheet();
                },
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                tabController: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAllTab(),
            _buildTrendingTab(),
            _buildFollowingTab(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAllTab() {
    return Obx(() {
      if (_controller.isLoadingAll.value && _controller.allWidgets.isEmpty) {
        return Center(
          child: IOSLoader(
            message: 'Loading reports...',
          ),
        );
      }
      
      if (_controller.allWidgets.isEmpty) {
        return _buildEmptyState('No reports available', LucideIcons.fileText);
      }
      
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= _controller.allWidgets.length) {
                    return _controller.hasMoreAll.value
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          )
                        : const SizedBox.shrink();
                  }
                  
                  final widget = _controller.allWidgets[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      height: 180,
                      child: IOSWidgetCard(
                        widget: widget,
                        onTap: () => _navigateToWidget(widget),
                        onShareTap: () => _shareWidget(widget),
                        onBookmarkTap: () => _controller.toggleSaveWidget(widget),
                      ),
                    ),
                  );
                },
                childCount: _controller.allWidgets.length + 
                    (_controller.hasMoreAll.value ? 1 : 0),
              ),
            ),
          ),
        ],
      );
    });
  }
  
  Widget _buildTrendingTab() {
    return Obx(() {
      if (_controller.isLoadingTrending.value && _controller.trendingWidgets.isEmpty) {
        return Center(
          child: IOSLoader(
            message: 'Loading trending reports...',
          ),
        );
      }
      
      if (_controller.trendingWidgets.isEmpty) {
        return _buildEmptyState('No trending reports', LucideIcons.trendingUp);
      }
      
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final widget = _controller.trendingWidgets[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      height: 180,
                      child: IOSWidgetCard(
                        widget: widget,
                        onTap: () => _navigateToWidget(widget),
                        onShareTap: () => _shareWidget(widget),
                        onBookmarkTap: () => _controller.toggleSaveWidget(widget),
                      ),
                    ),
                  );
                },
                childCount: _controller.trendingWidgets.length,
              ),
            ),
          ),
        ],
      );
    });
  }
  
  Widget _buildFollowingTab() {
    return Obx(() {
      if (_controller.isLoadingFollowing.value && _controller.followingWidgets.isEmpty) {
        return Center(
          child: IOSLoader(
            message: 'Loading reports from people you follow...',
          ),
        );
      }
      
      if (_controller.followingWidgets.isEmpty) {
        return _buildEmptyState(
          'Follow users to see their reports here',
          LucideIcons.users,
        );
      }
      
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= _controller.followingWidgets.length) {
                    return _controller.hasMoreFollowing.value
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          )
                        : const SizedBox.shrink();
                  }
                  
                  final widget = _controller.followingWidgets[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      height: 180,
                      child: IOSWidgetCard(
                        widget: widget,
                        onTap: () => _navigateToWidget(widget),
                        onShareTap: () => _shareWidget(widget),
                        onBookmarkTap: () => _controller.toggleSaveWidget(widget),
                      ),
                    ),
                  );
                },
                childCount: _controller.followingWidgets.length + 
                    (_controller.hasMoreFollowing.value ? 1 : 0),
              ),
            ),
          ),
        ],
      );
    });
  }
  
  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: iOS18Theme.tertiaryLabel,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 17,
              color: iOS18Theme.secondaryLabel,
            ),
          ),
        ],
      ),
    );
  }
  
  void _navigateToWidget(widget) {
    // Navigate to widget detail
    iOS18Theme.selectionClick();
  }
  
  void _shareWidget(widget) {
    iOS18Theme.lightImpact();
    // Implement share functionality
  }
  
  void _showSearchSheet() {
    iOS18Theme.lightImpact();
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: iOS18Theme.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoSearchTextField(
                      placeholder: 'Search reports...',
                      autofocus: true,
                      onChanged: (value) {
                        // Implement search
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Search results will appear here',
                  style: TextStyle(
                    color: iOS18Theme.secondaryLabel,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  
  _TabBarDelegate({required this.tabController});
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: iOS18Theme.background,
      child: Container(
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: iOS18Theme.secondaryFill,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TabBar(
          controller: tabController,
          indicator: BoxDecoration(
            color: iOS18Theme.background,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: iOS18Theme.separator.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorPadding: const EdgeInsets.all(2),
          labelColor: iOS18Theme.primaryLabel,
          unselectedLabelColor: iOS18Theme.secondaryLabel,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Trending'),
            Tab(text: 'Following'),
          ],
        ),
      ),
    );
  }
  
  @override
  double get maxExtent => 60;
  
  @override
  double get minExtent => 60;
  
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}