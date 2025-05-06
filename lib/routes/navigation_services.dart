import 'package:flutter/material.dart';

// Global navigator key for managing navigation globally
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Push a new screen
  static Future<void> navigateTo(Widget screen) async {
    await navigatorKey.currentState?.push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0); // Right to left
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
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
