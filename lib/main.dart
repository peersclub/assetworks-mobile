import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/theme/ios18_theme.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'presentation/pages/ios/main_tab_screen.dart';
import 'presentation/pages/ios/auth/ios_auth_screen.dart';
import 'presentation/pages/ios/profile/ios_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await GetStorage.init();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const AssetWorksApp());
}

class AssetWorksApp extends StatelessWidget {
  const AssetWorksApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GetCupertinoApp(
      title: 'AssetWorks',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: iOS18Theme.accentBlue,
        scaffoldBackgroundColor: iOS18Theme.background,
        textTheme: CupertinoTextThemeData(
          primaryColor: iOS18Theme.primaryLabel,
        ),
      ),
      initialBinding: InitialBinding(),
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/auth',
          page: () => const IOSAuthScreen(),
        ),
        GetPage(
          name: '/main',
          page: () => const MainTabScreen(),
        ),
        GetPage(
          name: '/profile',
          page: () {
            final args = Get.arguments as Map<String, dynamic>?;
            return IOSProfileScreen(userId: args?['userId']);
          },
        ),
      ],
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService());
    Get.put(AuthService());
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final authService = Get.find<AuthService>();
    await authService.getCurrentUser();
    
    if (authService.isAuthenticated.value) {
      Get.offAllNamed('/main');
    } else {
      Get.offAllNamed('/auth');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: iOS18Theme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    iOS18Theme.accentBlue,
                    iOS18Theme.accentPurple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                CupertinoIcons.chart_bar_square_fill,
                size: 60,
                color: CupertinoColors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'AssetWorks',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: iOS18Theme.primaryLabel,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AI-Powered Financial Analysis',
              style: TextStyle(
                fontSize: 16,
                color: iOS18Theme.secondaryLabel,
              ),
            ),
            const SizedBox(height: 48),
            const CupertinoActivityIndicator(radius: 16),
          ],
        ),
      ),
    );
  }
}