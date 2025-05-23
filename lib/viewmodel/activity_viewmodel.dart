import 'dart:io';
import 'package:aleedz/core/controllers/activity_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/activity_category_Id_model.dart';
import 'package:aleedz/models/activity_type_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityModelProvider = ChangeNotifierProvider<ActivityViewModel>((ref) {
  return ActivityViewModel();
});

class ActivityViewModel extends ChangeNotifier {
  final ActivityController _activityController = ActivityController();
  UserModel? user;
  bool loader = false;
  File? leftImage;
  List<ActivityModelType> activityType = [];
  List<ActivityCategoryModel> activityCategoryId = [];

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

  Future<void> getActivityType() async {
    activityType = [];
    notifyListeners();

    final response = await _activityController.activityType(
      token: user?.apiToken ?? '',
      divisionId: '1',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      activityType = data.map((e) => ActivityModelType.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future<void> getActivityCategoryId({
    required String divisionId,
    required String categoryTypeId,
  }) async {
    activityCategoryId = [];
    notifyListeners();

    final response = await _activityController.activityCategoryId(
      token: user?.apiToken ?? '',
      divisionId: divisionId,
      categoryTypeId: categoryTypeId,
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      activityCategoryId =
          data.map((e) => ActivityCategoryModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future loadActivity() async {
    loader = true;
    notifyListeners();
    await loadUser();
    await getActivityType();
    loader = false;
    notifyListeners();
  }
}
