import 'dart:io';

import 'package:aleedz/core/controllers/store_share_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/brand_store_share_model.dart';
import 'package:aleedz/models/category_store_share_model.dart';
import 'package:aleedz/models/product_store_share_model.dart';
import 'package:aleedz/models/shelf_share_brand_summary_model.dart';
import 'package:aleedz/models/shelf_share_display_location_model.dart';
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

  List<CategoryStoreShareModel> shelfShareCategoryList = [];
  List<CategoryStoreShareModel> shelfShareCategorySummaryList = [];
  List<BrandStoreShareModel> shelfShareBrandList = [];
  List<ShelfShareBrandSummaryModel> shelfShareBrandSummaryList = [];
  List<ShelfShareDisplayLocationModel> shelfShareDisplayLocationList = [];
  CategoryStoreShareModel? selectedShelfShareCategory;
  ShelfShareBrandSummaryModel? selectedShelfShareBrandSummary;

  bool loader = false;

  int _currentYear() => DateTime.now().year;

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

  Future<void> getShelfShareCategoryDropdown() async {
    shelfShareCategoryList = [];
    final response = await _shareController.shelfShareCategoryDropdown(
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final payload = response["data"];
      final rawList =
          payload is List ? payload : (payload is Map ? payload["data"] : null);

      if (rawList is List) {
        shelfShareCategoryList =
            rawList.map((e) => CategoryStoreShareModel.fromJson(e)).toList();
      } else {
        shelfShareCategoryList = [];
      }

      notifyListeners();
    } else {
      debugPrint("shelf share category dropdown error: ${response?['data']}");
    }
  }

  Future<void> getShelfShareCategorySummary({
    required int storeId,
    required int productCategoryId,
    required int visitId,
  }) async {
    loader = true;
    shelfShareCategorySummaryList = [];
    notifyListeners();

    debugPrint(
      'shelf share category summary request: storeId=$storeId, productCategoryId=$productCategoryId, weekNo=0, visitId=$visitId',
    );

    final response = await _shareController.shelfShareCategorySummary(
      token: user?.apiToken ?? '',
      storeId: storeId.toString(),
      productCategoryId: productCategoryId.toString(),
      weekNo: '0',
      visitId: visitId.toString(),
    );

    if (response != null && response["status"] == 200) {
      final payload = response["data"];
      final rawList =
          payload is List ? payload : (payload is Map ? payload["data"] : null);

      if (rawList is List) {
        shelfShareCategorySummaryList =
            rawList.map((e) => CategoryStoreShareModel.fromJson(e)).toList();
      } else {
        shelfShareCategorySummaryList = [];
      }
    } else {
      debugPrint("shelf share category summary error: ${response?['data']}");
    }

    loader = false;
    notifyListeners();
  }

  Future<void> getShelfShareAllBrands() async {
    shelfShareBrandList = [];
    debugPrint('shelf share all brands request started');
    final response = await _shareController.shelfShareAllBrands(
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final payload = response["data"];
      final rawList =
          payload is List ? payload : (payload is Map ? payload["data"] : null);

      if (rawList is List) {
        shelfShareBrandList =
            rawList.map((e) => BrandStoreShareModel.fromJson(e)).toList();
      } else {
        shelfShareBrandList = [];
      }

      notifyListeners();
    } else {
      debugPrint("shelf share all brands error: ${response?['data']}");
    }
  }

  Future<void> getShelfShareBrandSummaryByCategory({
    required int storeId,
    required int productCategoryId,
    required int brandId,
    required int visitId,
  }) async {
    loader = true;
    shelfShareBrandSummaryList = [];
    shelfShareDisplayLocationList = [];
    notifyListeners();

    debugPrint(
      'shelf share brand summary request: storeId=$storeId, productCategoryId=$productCategoryId, brandId=$brandId, weekNo=0, visitId=$visitId',
    );

    final response = await _shareController.shelfShareBrandSummaryByCategory(
      token: user?.apiToken ?? '',
      storeId: storeId.toString(),
      productCategoryId: productCategoryId.toString(),
      brandId: brandId.toString(),
      weekNo: '0',
      visitId: visitId.toString(),
    );

    if (response != null && response["status"] == 200) {
      final payload = response["data"];
      final rawList =
          payload is List ? payload : (payload is Map ? payload["data"] : null);

      if (rawList is List) {
        shelfShareBrandSummaryList =
            rawList
                .map((e) => ShelfShareBrandSummaryModel.fromJson(e))
                .toList();
      } else {
        shelfShareBrandSummaryList = [];
      }
    } else {
      debugPrint("shelf share brand summary error: ${response?['data']}");
    }

    loader = false;
    notifyListeners();
  }

  Future<void> getShelfShareDisplayLocation(int shelfShareId) async {
    shelfShareDisplayLocationList = [];
    final response = await _shareController.shelfShareBrandDisplayLocation(
      token: user?.apiToken ?? '',
      shelfShareId: shelfShareId.toString(),
    );

    if (response != null && response["status"] == 200) {
      final payload = response["data"];
      final rawList =
          payload is List ? payload : (payload is Map ? payload["data"] : null);

      if (rawList is List) {
        shelfShareDisplayLocationList =
            rawList
                .map((e) => ShelfShareDisplayLocationModel.fromJson(e))
                .toList();
      } else {
        shelfShareDisplayLocationList = [];
      }

      notifyListeners();
    } else {
      debugPrint("shelf share display location error: ${response?['data']}");
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

  Future<int?> submitShelfShareAdd({
    required int storeId,
    required int productCategoryId,
    required int brandId,
    required int facingCount,
    required int stockCount,
    required int visitId,
  }) async {
    if (user == null) {
      await loadUser();
    }

    final response = await _shareController.shelfShareAdd(
      token: user?.apiToken ?? '',
      shelfShareId: '1',
      storeId: storeId.toString(),
      productCategoryId: productCategoryId.toString(),
      weekNo: '0',
      year: _currentYear().toString(),
      brandId: brandId.toString(),
      facingCount: facingCount.toString(),
      stockCount: stockCount.toString(),
      visitId: visitId.toString(),
      teamMemberId: user?.teamMemberID.toString() ?? '0',
    );

    if (response == null || response["status"] != 200) {
      return null;
    }

    final payload = response["data"];
    final rows =
        payload is List ? payload : (payload is Map ? payload["data"] : null);
    if (rows is List && rows.isNotEmpty) {
      final first = rows.first;
      final column1 = first is Map ? first['Column1'] : null;
      final shelfShareValue = int.tryParse(column1?.toString() ?? '');
      if (shelfShareValue != null) {
        return shelfShareValue;
      }
    }

    return null;
  }

  Future<bool> submitShelfShareStoreDisplayLocationAdd({
    required int shelfShareId,
    required int shelfShareDisplayLocationId,
    required bool isShelfShareDisplay,
    required int visitId,
    File? displayLocationImage,
  }) async {
    if (user == null) {
      await loadUser();
    }

    final response = await _shareController.shelfShareStoreDisplayLocationAdd(
      token: user?.apiToken ?? '',
      shelfShareId: shelfShareId.toString(),
      shelfShareDisplayLocationId: shelfShareDisplayLocationId.toString(),
      isShelfShareDisplay: isShelfShareDisplay ? '1' : '0',
      visitId: visitId.toString(),
      teamMemberId: user?.teamMemberID.toString() ?? '0',
      displayLocationImage: displayLocationImage,
    );

    return response != null && response["status"] == 200;
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
