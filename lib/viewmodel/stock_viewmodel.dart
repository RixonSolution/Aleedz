import 'dart:convert';
import 'package:aleedz/core/controllers/stock_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/brand_list_model.dart' show BrandListModel;
import 'package:aleedz/models/ros_label.dart';
import 'package:aleedz/models/stock_view_model.dart';
import 'package:aleedz/models/uer_permission.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/stock_summary_model.dart';

final stockModelProvider = ChangeNotifierProvider<StockViewModel>((ref) {
  return StockViewModel();
});

class StockViewModel extends ChangeNotifier {
  final StockController _stockController = StockController();
  List<ROSLabel> rosLabels = [];
  UserPermission? permission;
  List<StockListModel> stockViewList = [];

  int visitId = 0;

  Future<UserPermission?> loadStoredPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_permission');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      return UserPermission.fromJson(jsonMap);
    }
    return null;
  }

  Future<void> saveROSLabelsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final rosLabelJson = rosLabels.map((e) => e.toJson()).toList();
    await prefs.setString('rosLabels', jsonEncode(rosLabelJson));
  }

  Future<void> loadROSLabelsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('rosLabels');

    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      rosLabels = decoded.map((e) => ROSLabel.fromJson(e)).toList();
      notifyListeners();
    }
  }

  UserModel? user;

  BrandListModel? selectedBrand;

  void selectBrand(int storeId, BrandListModel? brand) async {
    loader = true;
    notifyListeners();
    selectedBrand = brand;
    notifyListeners();
    print("Selected Channel ID: ${brand?.brandId}");

    if (brand != null) {
      await checkSummary(storeId, brand.brandId, visitId);
    }
    loader = false;
    notifyListeners();
  }

  List<BrandListModel> brandList = [];

  List<Brand> brands = [];

  Future loadUser() async {
    // loader = true;
    notifyListeners();
    final store = StoreLocalData();

    user = await store.getUserFromPrefs();
    permission = await loadStoredPermissions();

    notifyListeners();

    if (user != null) {
      print('Welcome ${user!.teamMemberName}');
    } else {
      print('No user found in prefs');
    }
  }

  bool loader = false;

  Future<void> checkSummary(int storeId, int brandId, int visitId) async {
    loader = true;
    brands = [];
    await loadUser();
    notifyListeners();
    final response = await _stockController.stockSummary(
      storeId: storeId.toString(),
      branddId: brandId.toString(),
      token: user?.apiToken ?? '',
      visitId: visitId.toString(),
    );

    if (response != null && response["status"] == 200) {
      final List<Brand> brandList = List<Brand>.from(
        response['data']['data'].map((x) => Brand.fromJson(x)),
      );
      brands = brandList;
      loadUser();
      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future<void> stockView(
    int storeId,
    int brandId,
    int visitId,
    int productCateId,
    int inputTypeId,
  ) async {
    loader = true;
    stockViewList = [];
    notifyListeners();
    final response = await _stockController.stockView(
      storeId: storeId.toString(),
      branddId: brandId.toString(),
      token: user?.apiToken ?? '',
      visitId: visitId.toString(),
      teamMemberId: user?.teamMemberID.toString() ?? '',
      productCategoryId: productCateId.toString(),
      inputTypeId: inputTypeId.toString(),
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      stockViewList = data.map((e) => StockListModel.fromJson(e)).toList();
      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future<void> stockAdd(
    int storeId,
    int brandId,
    int visitId,
    int productId,
    int stock,
  ) async {
    loader = true;
    notifyListeners();
    final response = await _stockController.stockAdd(
      storeId: storeId.toString(),
      token: user?.apiToken ?? '',
      visitId: visitId.toString(),
      teamMemberId: user?.teamMemberID.toString() ?? '',
      productId: productId.toString(),
      stock: stock.toString(),
    );

    if (response != null && response["status"] == 200) {
      loader = false;
      notifyListeners();
    } else {
      debugPrint("stock add Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future<void> getBrandDropDown() async {
    final response = await _stockController.brandDropDown(
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      brandList = data.map((e) => BrandListModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  void clearDisplayPicture(String sId) {
    selectedBrand = null;

    notifyListeners();
  }
}
