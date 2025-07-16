import 'package:aleedz/core/controllers/sale_controller.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/product_category_dp.dart';
import 'package:aleedz/models/sale_search_model.dart';
import 'package:aleedz/models/sale_view_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:aleedz/view/screens/sales/sale_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final saleModelProvider = ChangeNotifierProvider<SaleViewModel>((ref) {
  return SaleViewModel();
});

class SaleViewModel extends ChangeNotifier {
  final SaleController _saleController = SaleController();

  UserModel? user;

  BrandListModel? selectedBrand;
  ProductCategoryDP? selectedProductCategory;
  SaleSearchModel? selectedSaleSearch;

  List<BrandListModel> brandList = [];
  List<SaleListModel> saleList = [];

  List<ProductCategoryDP> productCategory = [];
  List<SaleSearchModel> saleSearch = [];

  bool loader = false;

  void selectBrand(int storeId, BrandListModel? brand) async {
    selectedBrand = brand;
    notifyListeners();
    print("Selected Channel ID: ${brand?.brandId}");
    if (brand != null) {
      await getProductCategoryDP(brandId: brand.brandId.toString());
    }
  }

  void selectProductCategory(int storeId, ProductCategoryDP? category) async {
    selectedProductCategory = category;
    notifyListeners();
    print("Selected Product ID: ${category?.productCategoryID}");
    if (category != null) {
      getModelSearch(
        storeId: storeId.toString(),
        brandId: selectedBrand?.brandId.toString(),
        productCateId: selectedProductCategory?.productCategoryID.toString(),
      );
    }
  }

  void selectSearchModel(SaleSearchModel? search) async {
    selectedSaleSearch = search;
    notifyListeners();
    print("Selected SearchModel ID: ${search?.productID}");
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
    final response = await _saleController.brandDropDown(
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

  Future<void> getProductCategoryDP({String brandId = '1'}) async {
    productCategory = [];
    selectedProductCategory = null;
    saleSearch = [];
    selectedSaleSearch = null;
    notifyListeners();

    final response = await _saleController.getProductCategory(
      token: user?.apiToken ?? '',
      brandId: brandId,
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      productCategory = data.map((e) => ProductCategoryDP.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("Product Category Error: ${response?['data']}");
    }
  }

  Future<void> getModelSearch({
    String? brandId,
    String? productCateId,
    String? storeId,
  }) async {
    saleSearch = [];
    selectedSaleSearch = null;
    notifyListeners();

    final response = await _saleController.getModelSearchDP(
      token: user?.apiToken ?? '',
      brandId: brandId ?? '',
      productCategoryId: productCateId ?? '',
      storeId: storeId ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      saleSearch = data.map((e) => SaleSearchModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("Sale Search  Error: ${response?['data']}");
    }
  }

  Future<void> addSale(
    context, {
    required String productCategoryId,
    required String storeId,
    required String saleCount,
    required String salePrice,
    required String saleDate,
    required String saleType,
  }) async {
    saleSearch = [];
    selectedSaleSearch = null;
    notifyListeners();

    final response = await _saleController.addSale(
      token: user?.apiToken ?? '',
      productCategoryId: productCategoryId,
      storeId: storeId,
      saleCount: saleCount,
      salePrice: salePrice,
      teamMemberId: user?.teamMemberID.toString() ?? '',
      saleDate: saleDate,
      saleType: saleType,
    );

    if (response != null && response["status"] == 200) {
      productCategory = [];
      selectedProductCategory = null;
      saleSearch = [];
      selectedSaleSearch = null;

      await saleView(context, storeId: storeId, saleDate: saleDate);

      notifyListeners();
    } else {
      debugPrint("Sale Search  Error: ${response?['data']}");
    }
  }

  Future<void> saleView(
    context, {
    required String storeId,
    required String saleDate,
  }) async {
    saleList = [];
    notifyListeners();

    final response = await _saleController.saleView(
      token: user?.apiToken ?? '',
      storeId: storeId,
      teamMemberId: user?.teamMemberID.toString() ?? '',
      saleDate: saleDate,
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      saleList = data.map((e) => SaleListModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("Sale List  Error: ${response?['data']}");
    }
  }

  Future<void> deleteSale(
    context, {
    required String storeId,
    required String saleId,
  }) async {
    saleList = [];
    notifyListeners();

    final response = await _saleController.removeSale(
      token: user?.apiToken ?? '',
      storeId: storeId,
      teamMemberId: user?.teamMemberID.toString() ?? '',
      saleId: saleId,
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'];
      // saleList = data.map((e) => SaleListModel.fromJson(e)).toList();
      // AppSnackBar.showSuccess(context, 'Sale removed.');

      notifyListeners();
    } else {
      debugPrint("Sale List  Error: ${response?['data']}");
    }
  }

  Future loadsale(context, String storeId, String saleDate) async {
    brandList = [];
    selectedBrand = null;

    productCategory = [];
    selectedProductCategory = null;
    saleSearch = [];
    selectedSaleSearch = null;
    loader = true;
    notifyListeners();
    await loadUser();
    await getBrandDropDown();
    saleView(context, storeId: storeId, saleDate: saleDate);

    loader = false;
    notifyListeners();
  }
}
