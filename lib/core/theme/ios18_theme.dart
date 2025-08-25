import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class iOS18Theme {
  // Background colors
  static Color get background => CupertinoColors.systemBackground;
  static Color get secondaryBackground => CupertinoColors.secondarySystemBackground;
  static Color get tertiaryBackground => CupertinoColors.tertiarySystemBackground;
  
  // Label colors
  static Color get primaryLabel => CupertinoColors.label;
  static Color get secondaryLabel => CupertinoColors.secondaryLabel;
  static Color get tertiaryLabel => CupertinoColors.tertiaryLabel;
  static Color get quaternaryLabel => CupertinoColors.quaternaryLabel;
  
  // Fill colors
  static Color get primaryFill => CupertinoColors.systemFill;
  static Color get secondaryFill => CupertinoColors.secondarySystemFill;
  static Color get tertiaryFill => CupertinoColors.tertiarySystemFill;
  static Color get quaternaryFill => CupertinoColors.quaternarySystemFill;
  
  // Separator
  static Color get separator => CupertinoColors.separator;
  static Color get opaqueSeparator => CupertinoColors.opaqueSeparator;
  
  // Accent colors
  static Color get accentBlue => CupertinoColors.systemBlue;
  static Color get accentGreen => CupertinoColors.systemGreen;
  static Color get accentRed => CupertinoColors.systemRed;
  static Color get accentOrange => CupertinoColors.systemOrange;
  static Color get accentYellow => CupertinoColors.systemYellow;
  static Color get accentPurple => CupertinoColors.systemPurple;
  static Color get accentPink => CupertinoColors.systemPink;
  static Color get accentTeal => CupertinoColors.systemTeal;
  static Color get accentIndigo => CupertinoColors.systemIndigo;
  
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
  
  // Text styles
  static TextStyle get largeTitle => const TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.37,
  );
  
  static TextStyle get title1 => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.36,
  );
  
  static TextStyle get title2 => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.35,
  );
  
  static TextStyle get title3 => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.38,
  );
  
  static TextStyle get headline => const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
  );
  
  static TextStyle get body => const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
  );
  
  static TextStyle get callout => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.32,
  );
  
  static TextStyle get subheadline => const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
  );
  
  static TextStyle get footnote => const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
  );
  
  static TextStyle get caption1 => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
  
  static TextStyle get caption2 => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.07,
  );
}