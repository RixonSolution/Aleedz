import 'dart:convert';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/view/screens/coverage_details/coverage_view.dart';
import 'package:aleedz/view/screens/coverage_details/google_map.dart';
import 'package:aleedz/view/screens/store/display_audit_check.dart';
import 'package:aleedz/view/screens/store/display_audit_check_summary.dart';
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Center(child: CircularProgressIndicator()),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aleedz',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.secondary,
              secondary: AppColors.secondary,
            ),
            useMaterial3: true,
          ),
          navigatorKey: NavigationService.navigatorKey,
          // home: DisplayAuditCheckSummary(
          //   storeName: 'XCITE JABRIYA EXPRESS',
          //   checkInTime: '10:59',
          //   storeId: 4,
          // ),
          // home: DisplayAuditCheck(
          //   storeName: 'XCITE JABRIYA EXPRESS',
          //   checkInTime: '10:59',
          //   storeId: 4,
          //   categoryId: 1,
          //   categoryName: 'B2C Headsets',
          //   lastUpdate: "/Date(1746601200000)/",
          // ),
          // home: CoverageView(),
          // home: GoogleMapScreen(),
          home: snapshot.data!,
          routes: {
            '/choose-language': (context) => ChooseLanguageView(),
            '/dashboard': (context) => DashboardView(),
          },
        );
      },
    );
  }
}
