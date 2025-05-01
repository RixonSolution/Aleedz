import 'dart:convert';
import 'package:aleedz/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreLocalData {
  Future<void> saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString('user_model', userJson);
  }

  Future<UserModel?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user_model');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserModel.fromJson(userMap);
    }
    return null;
  }
}
