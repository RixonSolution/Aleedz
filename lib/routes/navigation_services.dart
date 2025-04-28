import 'package:flutter/material.dart';

// Global navigator key for managing navigation globally
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Push a new screen
  static Future<void> navigateTo(Widget screen) async {
    await navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  // Replace the current screen with a new screen
  static Future<void> replaceWith(Widget screen) async {
    await navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  // Pop the current screen
  static void goBack() {
    navigatorKey.currentState?.pop();
  }

  // Reset to a specific screen and remove all previous screens
  static Future<void> resetTo(Widget screen) async {
    await navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }
}
