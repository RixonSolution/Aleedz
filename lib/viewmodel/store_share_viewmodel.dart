import 'package:aleedz/core/controllers/store_share_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/brand_store_share_model.dart';
import 'package:aleedz/models/category_store_share_model.dart';
import 'package:aleedz/models/product_store_share_model.dart';
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

  List<BrandListModel> brandList = [];
  BrandListModel? selectedBrand;

  bool loader = false;

  void selectBrand(int storeId, BrandListModel? brand) async {
    loader = true;
    notifyListeners();
    selectedBrand = brand;
    notifyListeners();
    print("Selected Channel ID: ${brand?.brandId}");

    if (brand != null) {}
    loader = false;
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

  Future loadShare() async {
    brandShareList = [];
    categoryShareList = [];
    productShareList = [];
    loader = true;
    notifyListeners();
    await loadUser();
    await getBrandDropDown();
    await getBrandList();
    await getCategoryList();
    await getProductList();
    loader = false;
    notifyListeners();
  }
}
