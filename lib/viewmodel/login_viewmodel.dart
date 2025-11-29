import 'dart:convert';

import 'package:aleedz/core/controllers/auth_controller.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/language_model.dart';
import 'package:aleedz/models/uer_permission.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/%20login/login_view.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthController _authController = AuthController();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  UserPermission? userPermission;

  UserModel? user;

  bool isPasswordVisible = false;

  final StoreLocalData localData = StoreLocalData();

  void loadUser() async {
    final store = StoreLocalData();

    user = await store.getUserFromPrefs();

    if (user != null) {
      print('Welcome ${user!.teamMemberName}');
    } else {
      print('No user found in prefs');
    }
  }

  bool loader = false;

  Future<bool> onLogin(BuildContext context) async {
    loader = true;
    notifyListeners();

    try {
      final response = await _authController.loginUser(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
        deviceIMEIID: "",
      );

      if (response != null && response["status"] == 200) {
        final store = StoreLocalData();
        final dataList = response["data"]["data"];

        if (dataList != null && dataList.isNotEmpty) {
          final userData = UserModel.fromJson(dataList[0]);
          await store.saveUserToPrefs(userData);

          await requestUserPermission(
            context,
            userData.apiToken!,
            userData.teamMemberID!,
          );
          final labelsLoaded = await chooseLanguage(
            '1',
            language: false,
            showLoader: false,
          );
          if (!labelsLoaded) {
            AppSnackBar.showError(
              context,
              'Unable to load language data. Please try again.',
            );
            return false;
          }
          return true; // ✅ SUCCESS
        }
      }

      AppSnackBar.showError(context, 'Login failed. Please try again.');
      return false; // ❌ FAILURE
    } finally {
      loader = false;
      notifyListeners();
    }
  }

  Future<UserPermission?> loadStoredPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_permission');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      return UserPermission.fromJson(jsonMap);
    }
    return null;
  }

  Future<UserPermission?> requestUserPermission(
    BuildContext context,
    String token,
    int teamId,
  ) async {
    final response = await _authController.requestUserPermission(
      userTeamId: teamId,
      userToken: token.trim(),
    );

    if (response != null && response["status"] == 200) {
      final nestedData = response["data"];
      if (nestedData != null &&
          nestedData["data"] != null &&
          nestedData["data"].isNotEmpty) {
        final userPermission = UserPermission.fromJson(nestedData);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user_permission',
          jsonEncode(userPermission.toJson()),
        );

        return userPermission;
      } else {
        AppSnackBar.showError(context, 'No user data found.');
      }
    } else {
      AppSnackBar.showError(context, 'Permission error: ${response?['data']}');
    }

    return null;
  }

  Future<bool> chooseLanguage(
    String languageId, {
    bool language = true,
    bool showLoader = true,
  }) async {
    if (showLoader) {
      loader = true;
      notifyListeners();
    }

    final response = await _authController.choosLanguage(
      languageId: languageId,
    );

    if (showLoader) {
      loader = false;
      notifyListeners();
    }

    if (response != null && response["status"] == 200) {
      final nestedData = response["data"]['data'];
      if (nestedData is List && nestedData.isNotEmpty) {
        final List<LabelModel> labels =
            nestedData.map((e) => LabelModel.fromJson(e)).toList();
        await localData.saveLabelsToPrefs(labels);
        if (language == true) {
          NavigationService.navigateTo(LoginView());
        }
        return true;
      }
    }

    return false;
  }
}
