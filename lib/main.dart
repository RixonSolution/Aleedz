import 'dart:convert';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/view/screens/store/display_audit_check_summary.dart';
import 'package:aleedz/view/screens/store/store_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/choose_language/choose_language_view.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LabelService().loadLabels();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user_model');

    if (userJson != null) {
      // If user data is found, navigate to the Dashboard screen
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      final user = UserModel.fromJson(userMap);
      return DashboardView(); // Pass the user to the Dashboard view
    } else {
      // If no user data is found, show the Choose Language screen
      return ChooseLanguageView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        // While loading, show a loading spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Center(
              child: CircularProgressIndicator(),
            ), // You can customize this loading UI
          );
        }

        // Once the initial route is determined, build the app
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aleedz',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.secondary,
            ),
            useMaterial3: true,
          ),
          navigatorKey: NavigationService.navigatorKey,
          home: snapshot.data!, // Use the determined initial screen

          routes: {
            '/choose-language': (context) => ChooseLanguageView(),
            '/dashboard': (context) => DashboardView(),
          },
        );
      },
    );
  }
}
