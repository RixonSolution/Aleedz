import 'dart:io';
import 'package:aleedz/core/controllers/activity_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/activity_category_Id_model.dart';
import 'package:aleedz/models/activity_type_model.dart';
import 'package:aleedz/models/market_activity_list.dart';
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
  List<MarketActivityList> marketActivityList = [];
  List<File> beforeActivityImages = [];

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
    loader = true;

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
      loader = false;

      notifyListeners();
    } else {
      loader = false;

      notifyListeners();
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future<void> removeActivity({
    required String activityId,
    required String activityTypeId,
  }) async {
    loader = true;

    notifyListeners();

    final response = await _activityController.removeActivity(
      token: user?.apiToken ?? '',
      activityId: activityId,
      activityTypeId: activityTypeId,
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'];
      // activityCategoryId =
      //     data.map((e) => ActivityCategoryModel.fromJson(e)).toList();
      // loader = false;

      notifyListeners();
      loader = false;
    } else {
      loader = false;

      notifyListeners();
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future<void> getMarketActivityList({
    required String storeId,
    required String activityCategoryId,
    required String activityTypeId,
    required String brandId,
  }) async {
    loader = true;
    marketActivityList = [];
    beforeActivityImages = [];
    notifyListeners();

    final response = await _activityController.activityList(
      token: user?.apiToken ?? '',
      storeId: storeId,
      activityCategoryId: activityCategoryId,
      activityTypeId: activityTypeId,
      brandId: brandId,
      teamMemberId: user?.teamMemberID.toString() ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      marketActivityList =
          data.map((e) => MarketActivityList.fromJson(e)).toList();
      loader = false;

      print(marketActivityList);

      notifyListeners();
    } else {
      loader = false;

      notifyListeners();
      debugPrint("activity list Error: ${response?['data']}");
    }
  }

  Future<void> marketActivityAdd({
    required String storeID,
    required String activityTypeId,
    required String activityCategoryId,
    required String brandId,
    required String activityDescription,
    required String statusId,
    required String quantity,
    required String deployementReason,
    List<File>? beforeActivityPictures, // ✅ Updated to accept list of images
  }) async {
    loader = true;
    notifyListeners();

    final response = await _activityController.marketActivityAdd(
      token: user?.apiToken ?? '',
      storeID: storeID.toString(),
      teamMemberId: user?.teamMemberID.toString() ?? '',
      beforeActivityPictures: beforeActivityPictures, // ✅ Updated
      activityTypeId: activityTypeId,
      activityCategoryId: activityCategoryId,
      brandId: brandId,
      activityDescription: activityDescription,
      statusId: statusId,
      quantity: quantity,
      deployementReason: deployementReason,
    );

    if (response != null && response["status"] == 200) {
      await getMarketActivityList(
        storeId: storeID,
        activityCategoryId: activityCategoryId,
        activityTypeId: activityTypeId,
        brandId: brandId,
      );
      loader = false;
      notifyListeners();
    } else {
      debugPrint("marketActivityAdd Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future loadActivity() async {
    beforeActivityImages = [];
    loader = true;
    notifyListeners();
    await loadUser();
    await getActivityType();
    loader = false;
    notifyListeners();
  }
}
