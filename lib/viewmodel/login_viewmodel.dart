import 'package:aleedz/core/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthController _authController = AuthController();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loader = false;

  Future<void> onLogin() async {
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
        final dataList = response["data"]["data"];
        if (dataList != null && dataList.isNotEmpty) {
          final userData = dataList[0];
          final token = userData["api_token"];
          debugPrint("Login Success: Token: $token");
          // You can store token using SharedPreferences, GetStorage, etc.
        } else {
          debugPrint("Login Failed: Invalid credentials or response data");
        }
      } else {
        debugPrint("Login Error: ${response?['data']}");
      }
    }
  }
}
