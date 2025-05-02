import 'dart:convert';
import 'package:aleedz/models/language_model.dart';
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

  Future<void> saveLabelsToPrefs(List<LabelModel> labels) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> labelJsonList =
        labels.map((label) => jsonEncode(label.toJson())).toList();
    await prefs.setStringList('label_list', labelJsonList);
  }

  Future<List<LabelModel>> getLabelsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList('label_list');

    if (jsonList != null) {
      // Convert the List of JSON strings back to LabelModel objects
      return jsonList.map((jsonString) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return LabelModel.fromJson(jsonMap);
      }).toList();
    } else {
      return [];
    }
  }
}
