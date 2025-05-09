import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/choose_language/choose_language_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  Future<void> _showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.secondary,
            title: const Text(
              'Logout',
              style: TextStyle(color: AppColors.whiteColor),
            ),
            content: const Text(
              'Are you sure you want to logout?',
              style: TextStyle(color: AppColors.whiteColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Close dialog
                child: const Text(
                  'No',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
              TextButton(
                onPressed: () async {
                  // Clear SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  // Navigate to LoginScreen (replace this with your actual login screen route)
                  NavigationService.resetTo(ChooseLanguageView());
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show the dialog when this screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLogoutDialog(context);
    });

    return const Scaffold(
      body: Center(child: SizedBox()), // Empty blank screen
    );
  }
}
