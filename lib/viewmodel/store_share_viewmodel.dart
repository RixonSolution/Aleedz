import 'dart:io';

import 'package:aleedz/core/controllers/store_share_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/brand_store_share_model.dart';
import 'package:aleedz/models/category_store_share_model.dart';
import 'package:aleedz/models/product_store_share_model.dart';
import 'package:aleedz/models/store_share_element_type_model.dart';
import 'package:aleedz/models/store_share_summary_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storeShareModelProvider = ChangeNotifierProvider<StoreShareViewModel>((
  ref,
) {
  return StoreShareViewModel();
});

class StoreShareViewModel extends ChangeNotifier {
  final StoreShareController _shareController = StoreShareController();

  UserModel? user;
  List<BrandStoreShareModel> brandShareList = [];
  List<CategoryStoreShareModel> categoryShareList = [];
  List<ProductStoreShareModel> productShareList = [];
  List<StoreShareElementTypeModel> elementTypeList = [];
  List<StoreShareSummaryModel> summaryList = [];

  List<BrandListModel> brandList = [];
  BrandListModel? selectedBrand;

  bool loader = false;

  void selectBrand(int storeId, BrandListModel? brand) async {
    selectedBrand = brand;
    notifyListeners();
  }

  Future loadUser() async {
    final store = StoreLocalData();

    user = await store.getUserFromPrefs();
    notifyListeners();

    if (user != null) {
      print('Welcome ${user!.teamMemberName}');
    } else {
      print('No user found in prefs');
    }
  }

  Future<void> getBrandDropDown() async {
    final response = await _shareController.brandDropDown(
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

  Future<void> getBrandList() async {
    notifyListeners();

    final response = await _shareController.brandList(
      token: user?.apiToken ?? '',
      storeId: '0',
      teamMemberId: user?.teamMemberID.toString() ?? '',
      visitId: '1',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      brandShareList =
          data.map((e) => BrandStoreShareModel.fromJson(e)).toList();

      print(brandShareList);

      notifyListeners();
    } else {
      debugPrint("brand share list Error: ${response?['data']}");
    }
  }

  Future<void> getCategoryList() async {
    notifyListeners();

    final response = await _shareController.categoryList(
      token: user?.apiToken ?? '',
      storeId: '0',
      teamMemberId: user?.teamMemberID.toString() ?? '',
      visitId: '1',
      brandId: selectedBrand?.brandId.toString() ?? '0',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      categoryShareList =
          data.map((e) => CategoryStoreShareModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("training list Error: ${response?['data']}");
    }
  }

  Future<void> getProductList() async {
    notifyListeners();

    final response = await _shareController.productList(
      token: user?.apiToken ?? '',
      storeId: '0',
      teamMemberId: user?.teamMemberID.toString() ?? '',
      visitId: '1',
      brandId: selectedBrand?.brandId.toString() ?? '1',
      productCategoryId: '2',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      productShareList =
          data.map((e) => ProductStoreShareModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("training list Error: ${response?['data']}");
    }
  }

  Future<void> getElementTypeList() async {
    notifyListeners();

    final response = await _shareController.elementTypeList(
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final payload = response["data"];
      final rawList =
          payload is List ? payload : (payload is Map ? payload["data"] : null);

      if (rawList is List) {
        elementTypeList =
            rawList.map((e) => StoreShareElementTypeModel.fromJson(e)).toList();
      } else {
        elementTypeList = [];
      }

      notifyListeners();
    } else {
      debugPrint("store share element type Error: ${response?['data']}");
    }
  }

  Future loadShare() async {
    brandShareList = [];
    categoryShareList = [];
    productShareList = [];
    elementTypeList = [];
    loader = true;
    notifyListeners();
    await loadUser();
    await getBrandDropDown();
    await getElementTypeList();
    loader = false;
    notifyListeners();
  }

  Future<void> getStoreShareSummary({
    required String storeId,
    required String brandId,
    required String storeShareElementTypeId,
    required String storeShareElementId,
    required String visitId,
  }) async {
    if (user == null) {
      await loadUser();
    }
    loader = true;
    summaryList = [];
    notifyListeners();

    final response = await _shareController.storeShareSummary(
      token: user?.apiToken ?? '',
      storeId: storeId,
      brandId: brandId,
      storeShareElementTypeId: storeShareElementTypeId,
      storeShareElementId: storeShareElementId,
      visitId: visitId,
    );

    if (response != null && response["status"] == 200) {
      final payload = response["data"];
      final rawList =
          payload is List ? payload : (payload is Map ? payload["data"] : null);

      if (rawList is List) {
        summaryList =
            rawList.map((e) => StoreShareSummaryModel.fromJson(e)).toList();
      } else {
        summaryList = [];
      }
    } else {
      debugPrint("store share summary Error: ${response?['data']}");
    }

    loader = false;
    notifyListeners();
  }

  Future<bool> submitStoreShareAdd({
    required String storeId,
    required String storeShareElementId,
    required String brandId,
    required String visitId,
    required String count,
    File? storeShareImage,
  }) async {
    if (user == null) {
      await loadUser();
    }

    final response = await _shareController.storeShareAdd(
      token: user?.apiToken ?? '',
      storeId: storeId,
      storeShareElementId: storeShareElementId,
      brandId: brandId,
      teamMemberId: user?.teamMemberID.toString() ?? '0',
      visitId: visitId,
      count: count,
      storeShareImage: storeShareImage,
    );

    return response != null && response["status"] == 200;
  }
}
