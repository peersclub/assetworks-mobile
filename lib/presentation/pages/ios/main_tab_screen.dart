import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/ios18_theme.dart';
import 'dashboard/ios_dashboard_screen_tabs.dart';
import 'explore/ios_explore_screen.dart';
import 'create/ios_create_widget_screen.dart';
import 'notifications/ios_notifications_screen.dart';
import 'profile/ios_profile_screen.dart';
import '../../controllers/notifications_controller.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});
  
  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;
  late NotificationsController _notificationsController;
  
  final List<Widget> _screens = [
    const IOSDashboardScreenTabs(),
    const IOSExploreScreen(),
    const IOSCreateWidgetScreen(),
    const IOSNotificationsScreen(),
    const IOSProfileScreen(),
  ];
  
  @override
  void initState() {
    super.initState();
    _notificationsController = Get.put(NotificationsController());
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: iOS18Theme.background.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: iOS18Theme.separator,
            width: 0.5,
          ),
        ),
        currentIndex: _selectedIndex,
        onTap: (index) {
          iOS18Theme.selectionClick();
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0
                  ? CupertinoIcons.house_fill
                  : CupertinoIcons.house,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1
                  ? CupertinoIcons.compass_fill
                  : CupertinoIcons.compass,
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    iOS18Theme.accentBlue,
                    iOS18Theme.accentPurple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.plus,
                color: CupertinoColors.white,
                size: 18,
              ),
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(
                  _selectedIndex == 3
                      ? CupertinoIcons.bell_fill
                      : CupertinoIcons.bell,
                ),
                Obx(() {
                  final unreadCount = _notificationsController.unreadCount.value;
                  if (unreadCount > 0) {
                    return Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: iOS18Theme.accentRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 4
                  ? CupertinoIcons.person_fill
                  : CupertinoIcons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) => _screens[index],
        );
      },
    );
  }
}