import 'package:aleedz/core/controllers/price_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/price_list_model.dart';
import 'package:aleedz/models/price_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final priceModelProvider = ChangeNotifierProvider<PriceViewModel>((ref) {
  return PriceViewModel();
});

class PriceViewModel extends ChangeNotifier {
  final PriceController _priceController = PriceController();

  UserModel? user;
  List<PriceModel> brands = [];

  BrandListModel? selectedBrand;

  List<BrandListModel> brandList = [];

  List<PriceListModel> priceList = [];

  bool loader = false;

  void selectBrand(int storeId, BrandListModel? brand) async {
    selectedBrand = brand;
    notifyListeners();
    print("Selected Channel ID: ${brand?.brandId}");
    if (brand != null) {
      pricePromotion(storeId, brand.brandId!);
    }
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
    brandList = [];
    selectedBrand = null;

    notifyListeners();
    final response = await _priceController.brandDropDown(
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

  Future<void> pricePromotion(int storeId, int brandId) async {
    loader = true;
    brands = [];
    notifyListeners();
    final response = await _priceController.pricePromotion(
      storeId: storeId.toString(),
      branddId: brandId.toString(),
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final List<PriceModel> brandList = List<PriceModel>.from(
        response['data']['data'].map((x) => PriceModel.fromJson(x)),
      );
      brands = brandList;
      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future<void> pricePromotionList({
    required String brandId,
    required String productCategoryId,
    required String storeId,
    required String visiteId,
  }) async {
    loader = true;
    priceList = [];
    notifyListeners();
    final response = await _priceController.priceList(
      storeId: storeId.toString(),
      brandId: brandId.toString(),
      token: user?.apiToken ?? '',
      productCategoryId: productCategoryId,
      visiteId: visiteId,
    );

    if (response != null && response["status"] == 200) {
      final List<PriceListModel> priceModelList = List<PriceListModel>.from(
        response['data']['data'].map((x) => PriceListModel.fromJson(x)),
      );
      priceList = priceModelList;
      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future loadPriceData(int storeId, int brandId) async {
    loader = true;
    notifyListeners();
    await loadUser();
    await getBrandDropDown();
    await pricePromotion(storeId, brandId);
    loader = false;
    notifyListeners();
  }
}
