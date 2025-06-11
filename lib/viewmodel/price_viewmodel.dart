import 'package:aleedz/core/controllers/price_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final priceModelProvider = ChangeNotifierProvider<PriceViewModel>((ref) {
  return PriceViewModel();
});

class PriceViewModel extends ChangeNotifier {
  final PriceController _priceController = PriceController();

  UserModel? user;

  BrandListModel? selectedBrand;

  List<BrandListModel> brandList = [];

  bool loader = false;

  void selectBrand(int storeId, BrandListModel? brand) async {
    selectedBrand = brand;
    notifyListeners();
    print("Selected Channel ID: ${brand?.brandId}");
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
}
