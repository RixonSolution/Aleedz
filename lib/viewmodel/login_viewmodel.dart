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

class LoginViewModel extends ChangeNotifier {
  final AuthController _authController = AuthController();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  Future<void> onLogin(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      loader = true;
      notifyListeners();

      const String deviceIMEIID = ""; // Replace with real IMEI logic

      final response = await _authController.loginUser(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
        deviceIMEIID: deviceIMEIID,
      );

      loader = false;
      notifyListeners();

      if (response != null && response["status"] == 200) {
        final store = StoreLocalData();

        final dataList = response["data"]["data"];
        if (dataList != null && dataList.isNotEmpty) {
          // final userData = dataList[0];
          // final token = userData["api_token"];
          // debugPrint("Login Success: Token: $token");
          final userData = UserModel.fromJson(dataList[0]);
          await store.saveUserToPrefs(userData);

          await requestUserPermission(
            context,
            userData.apiToken!,
            userData.teamMemberID!,
          );
          debugPrint("Login Success: Token: ${userData.apiToken}");
          AppSnackBar.showSuccess(context, 'Login successful!');
          NavigationService.navigateTo(DashboardView());

          // You can store token using SharedPreferences, GetStorage, etc.
        } else {
          AppSnackBar.showError(context, 'Login failed. Please try again.');
          debugPrint("Login Failed: Invalid credentials or response data");
        }
      } else {
        debugPrint("Login Error: ${response?['data']}");
      }
    }
  }

  Future<void> requestUserPermission(
    BuildContext context,
    String token,
    int teamId,
  ) async {
    loader = true;
    notifyListeners();

    final response = await _authController.requestUserPermission(
      userTeamId: teamId,
      userToken: token.trim(),
    );

    loader = false;
    notifyListeners();

    if (response != null && response["status"] == 200) {
      final nestedData = response["data"];
      if (nestedData != null &&
          nestedData["data"] != null &&
          nestedData["data"].isNotEmpty) {
        final userPermission = UserPermission.fromJson(nestedData);

        // for (var permission in userPermission.data!) {
        //   print(
        //     'Permission: ${permission.permissionID} - ${permission.permission}',
        //   );
        // }
      } else {
        AppSnackBar.showError(context, 'No user data found.');
      }
    } else {
      AppSnackBar.showError(context, 'Permission error: ${response?['data']}');
    }
  }

  Future<void> chooseLanguage(BuildContext context, String languageId) async {
    loader = true;
    notifyListeners();

    final response = await _authController.choosLanguage(
      languageId: languageId,
    );

    loader = false;
    notifyListeners();

    if (response != null && response["status"] == 200) {
      final nestedData = response["data"]['data'];
      final List<LabelModel> labels =
          (nestedData as List).map((e) => LabelModel.fromJson(e)).toList();
      await localData.saveLabelsToPrefs(labels);
      final List<LabelModel> savedLabels = await localData.getLabelsFromPrefs();

      NavigationService.navigateTo(LoginView());

      AppSnackBar.showSuccess(context, 'Language is set as English}');
    } else {}
  }
}
