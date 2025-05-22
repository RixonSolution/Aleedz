import 'dart:convert';
import 'dart:io';
import 'package:aleedz/core/controllers/activity_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/uer_permission.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final activityModelProvider = ChangeNotifierProvider<ActivityViewModel>((ref) {
  return ActivityViewModel();
});

class ActivityViewModel extends ChangeNotifier {
  final ActivityController _activityController = ActivityController();
  UserModel? user;
  bool loader = false;
  File? leftImage;

  Future<UserPermission?> loadStoredPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_permission');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      return UserPermission.fromJson(jsonMap);
    }
    return null;
  }

  Future loadUser() async {
    loader = true;
    notifyListeners();
    final store = StoreLocalData();

    user = await store.getUserFromPrefs();

    notifyListeners();

    if (user != null) {
      print('Welcome ${user!.teamMemberName}');
    } else {
      print('No user found in prefs');
    }
  }
}
