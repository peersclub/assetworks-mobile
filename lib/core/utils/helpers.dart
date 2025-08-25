import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../theme/ios18_theme.dart';

void showToast(String message, {bool isError = false}) {
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }
  
  Get.rawSnackbar(
    message: message,
    backgroundColor: isError ? CupertinoColors.systemRed : iOS18Theme.accentBlue,
    borderRadius: 12,
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    duration: const Duration(seconds: 2),
    animationDuration: const Duration(milliseconds: 300),
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInOut,
  );
}

class HapticHelper {
  // Haptic feedback
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }
  
  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }
  
  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }
  
  static void selectionClick() {
    HapticFeedback.selectionClick();
  }
}