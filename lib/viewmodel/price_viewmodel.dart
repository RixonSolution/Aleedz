import 'dart:io';

import 'package:aleedz/core/controllers/price_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/price_list_model.dart';
import 'package:aleedz/models/price_model.dart';
import 'package:aleedz/models/product_price_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final priceModelProvider = ChangeNotifierProvider<PriceViewModel>((ref) {
  return PriceViewModel();
});

class PriceViewModel extends ChangeNotifier {
  final PriceController _priceController = PriceController();

  UserModel? user;
  List<PriceModel> brands = [];
  List<ProductPriceEntry> productEntries = [];

  BrandListModel? selectedBrand;

  List<BrandListModel> brandList = [];

  List<PriceListModel> priceList = [];

  bool loader = false;

  void selectBrand(int storeId, BrandListModel? brand, String visitId) async {
    selectedBrand = brand;
    notifyListeners();
    print("Selected Channel ID: ${brand?.brandId}");
    if (brand != null) {
      pricePromotion(storeId, brand.brandId, visitId);
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

  Future<String?> pickFromCamera(String direction) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      // Save or process the image if needed
      return image.path;
    }
    return null;
  }

  Future<String?> pickFromGallery(String direction) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Save or process the image if needed
      return image.path;
    }
    return null;
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

  Future<void> pricePromotion(
    int storeId,
    int brandId,
    String visitId, {
    bool showLoader = true,
  }) async {
    if (showLoader) {
      loader = true;
      notifyListeners();
    }
    brands = [];
    final response = await _priceController.pricePromotion(
      storeId: storeId.toString(),
      branddId: brandId.toString(),
      token: user?.apiToken ?? '',
      visiteId: visitId,
    );

    if (response != null && response["status"] == 200) {
      final List<PriceModel> brandList = List<PriceModel>.from(
        response['data']['data'].map((x) => PriceModel.fromJson(x)),
      );
      brands = brandList;
      if (showLoader) {
        loader = false;
      }
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      if (showLoader) {
        loader = false;
        notifyListeners();
      }
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
    productEntries = [];
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

      // Map each PriceListModel into a ProductPriceEntry
      productEntries =
          priceModelList.map((item) {
            return ProductPriceEntry(
              token: user?.apiToken ?? '',
              productId: item.productID?.toString() ?? '',
              storeId: item.storeID?.toString() ?? '',
              price: item.price?.toString() ?? '0',
              promotion: item.promotion?.toString() ?? '',
              priceTagPictureId: item.piceTagPictureID?.toString() ?? '',
              teamMemberId: item.teamMemberID?.toString(),
              netPrice: item.netPrice?.toString() ?? '0',
              installment3Month: item.installment3Month?.toString() ?? '0',
              installment6Month: item.installment6Month?.toString() ?? '0',
              installment12Month: item.installment12Month?.toString() ?? '0',
              isOutOfStock: item.isOutOFStock?.toString() == '1',
              visitId: item.visitID?.toString() ?? '',
              priceImage: null, // or add logic to map if you have image path
            );
          }).toList();

      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  void updateProductEntry({
    required String productId,
    required String storeId,
    required String visitId,
    required String token,
    required String? teamMemberId,
    String? price,
    String? netPrice,
    String? promotion,
    String? imagePath,
    bool? isOutOfStock,
    String? installment3Month,
    String? installment6Month,
    String? installment12Month,
    String? priceTagPictureId,
  }) {
    final index = productEntries.indexWhere((e) => e.productId == productId);

    if (index != -1) {
      final existing = productEntries[index];
      productEntries[index] = ProductPriceEntry(
        token: token,
        productId: productId,
        storeId: storeId,
        visitId: visitId,
        teamMemberId: teamMemberId,
        price: price ?? existing.price,
        netPrice: netPrice ?? existing.netPrice,
        promotion: promotion ?? existing.promotion,
        priceTagPictureId: priceTagPictureId ?? '1',
        installment3Month: installment3Month ?? '1',
        installment6Month: installment6Month ?? '1',
        installment12Month: installment12Month ?? '1',
        isOutOfStock: isOutOfStock ?? existing.isOutOfStock,
        priceImage: imagePath ?? existing.priceImage,
      );
    } else {
      productEntries.add(
        ProductPriceEntry(
          token: token,
          productId: productId,
          storeId: storeId,
          visitId: visitId,
          teamMemberId: teamMemberId,
          price: price ?? '',
          netPrice: netPrice ?? '',
          promotion: promotion ?? '',
          priceTagPictureId: priceTagPictureId.toString(),
          installment3Month: installment3Month ?? '0',
          installment6Month: installment6Month ?? '0',
          installment12Month: installment12Month ?? '0',
          isOutOfStock: isOutOfStock ?? false,
          priceImage: imagePath,
        ),
      );
    }
  }

  Map<String, TextEditingController> priceControllers = {};

  Future<void> priceSubmit({
    required String productId,
    required String storeID,
    required String price,
    required String promotion,
    required String priceTagPictureId,
    required String netPrice,
    required String installment3Month,
    required String installment6Month,
    required String installment12Month,
    required String isOutOfStock,
    required String visitId,
    File? checkInImgFile,
  }) async {
    notifyListeners();
    final response = await _priceController.priceSubmit(
      token: user?.apiToken ?? '',
      productId: productId,
      storeID: storeID,
      price: price,
      promotion: promotion,
      priceTagPictureId: priceTagPictureId,
      teamMemberId: user?.teamMemberID.toString() ?? '',
      netPrice: netPrice,
      installment3Month: installment3Month,
      installment6Month: installment6Month,
      installment12Month: installment12Month,
      isOutOfStock: isOutOfStock,
      visitId: visitId,
      checkInImgFile: checkInImgFile,
    );

    if (response != null && response["status"] == 200) {
      notifyListeners();
    } else {
      debugPrint("Price list Error: ${response?['data']}");
      notifyListeners();
    }
  }

  Future<void> submitAllPrices(int storeId, String visitId) async {
    loader = true;
    notifyListeners();
    for (var entry in productEntries) {
      debugPrint('--- Submitting Product Entry: ${entry.productId} ---');

      final File? imageFile =
          entry.priceImage?.isNotEmpty == true ? File(entry.priceImage!) : null;

      final response = await _priceController.priceSubmit(
        token: entry.token,
        productId: entry.productId.toString(),
        storeID: entry.storeId.toString(),
        price: entry.price,
        promotion: entry.promotion,
        priceTagPictureId: entry.priceTagPictureId.toString(),
        teamMemberId: entry.teamMemberId.toString(),
        netPrice: entry.netPrice,
        installment3Month: entry.installment3Month,
        installment6Month: entry.installment6Month,
        installment12Month: entry.installment12Month,
        isOutOfStock: entry.isOutOfStock ? '1' : '0',
        visitId: entry.visitId.toString(),
        checkInImgFile: imageFile,
      );

      if (response != null && response["status"] == 200) {
        debugPrint("✅ Submitted productId: ${entry.productId}");
        // continue to next entry
      } else {
        debugPrint("❌ Error submitting productId: ${entry.productId}");
        debugPrint("Response: ${response?['data']}");
        break; // stop on error, or handle retry if needed
      }
    }
    await loadPriceData(storeId, 1, visitId);
    // productEntries = [];
    NavigationService.goBack();

    loader = false;
    notifyListeners();

    debugPrint("📤 All submissions attempted.");
  }

  Future loadPriceData(int storeId, int brandId, String visitId) async {
    loader = true;
    notifyListeners();
    await loadUser();
    await getBrandDropDown();
    await pricePromotion(storeId, brandId, visitId);
    loader = false;
    notifyListeners();
  }
}
