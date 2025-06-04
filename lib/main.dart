import 'dart:convert';
import 'package:aleedz/core/services/label_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/choose_language/choose_language_view.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await LabelService().loadLabels();
  await LabelService().loadBaseUrl();

  final initialScreen = await getInitialRoute();

  runApp(ProviderScope(child: MyApp(initialScreen: initialScreen)));
}

Future<Widget> getInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString('user_model');

  if (userJson != null) {
    final Map<String, dynamic> userMap = jsonDecode(userJson);
    final user = UserModel.fromJson(userMap);
    return DashboardView();
  } else {
    return ChooseLanguageView();
  }
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aleedz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.secondary,
          primary: AppColors.secondary,
          secondary: AppColors.secondary,
        ),
        useMaterial3: true,
      ),
      navigatorKey: NavigationService.navigatorKey,
      home: initialScreen,
      routes: {'/choose-language': (context) => ChooseLanguageView()},
    );
  }
}
