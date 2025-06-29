import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/%20login/login_view.dart';
import 'package:aleedz/view/screens/training/training_list_view.dart';
import 'package:aleedz/view/screens/user_training/user_training_list_view.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutScreen extends ConsumerStatefulWidget {
  const LogoutScreen({super.key});

  @override
  ConsumerState<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends ConsumerState<LogoutScreen> {
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
                  NavigationService.resetTo(LoginView());
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

  List<Map<String, dynamic>> getMenuItems(BuildContext context) {
    return [
      {
        'title': 'My Profile',
        'icon': Icons.person,
        'onTap': () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => MyProfileScreen()),
          // );
        },
      },
      {
        'title': 'Change Password',
        'icon': Icons.lock,
        'onTap': () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
          // );
        },
      },
      {
        'title': 'Training',
        'icon': Icons.school,
        'onTap': () {
          NavigationService.navigateTo(UserTrainingListView());
        },
        'visible': true, // Control visibility
      },
      {
        'title': 'Logout',
        'icon': Icons.logout,
        'onTap': () {
          _showLogoutDialog(context);
        },
      },
    ];
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final notifier = ref.read(storeModelProvider.notifier);

    await notifier.getROSLabels();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeModelProvider);

    final menuItems = getMenuItems(context);
    return Scaffold(
      body:
          viewModel.loader
              ? Center(child: CircularProgressIndicator())
              : ListView(
                children:
                    menuItems
                        .where((item) => item['visible'] != false)
                        .map(
                          (item) => ListTile(
                            leading: Icon(item['icon'], color: Colors.blue),
                            title: Text(item['title']),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: item['onTap'],
                          ),
                        )
                        .toList(),
              ),
    );
  }
}
