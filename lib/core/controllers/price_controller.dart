import 'dart:io';

import 'package:aleedz/core/services/price_services.dart';

class PriceController {
  final PriceServices _apiService = PriceServices();

  Future<Map<String, dynamic>?> brandDropDown({required String token}) async {
    return await _apiService.getBrandDropDown(token: token);
  }

  Future<Map<String, dynamic>?> pricePromotion({
    required String storeId,
    required String branddId,

    required String token,
  }) async {
    return await _apiService.pricePromotion(
      storeId: storeId,
      brandId: branddId,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> priceList({
    required String token,
    required String brandId,
    required String productCategoryId,
    required String storeId,
    required String visiteId,
  }) async {
    return await _apiService.priceList(
      storeId: storeId,
      brandId: brandId,
      token: token,
      productCategoryId: productCategoryId,
      visiteId: visiteId,
    );
  }

  Future<Map<String, dynamic>?> priceSubmit({
    required String token,
    required String productId,
    required String storeID,
    required String price,
    required String promotion,
    required String priceTagPictureId,
    required String teamMemberId,
    required String netPrice,
    required String installment3Month,
    required String installment6Month,
    required String installment12Month,
    required String isOutOfStock,
    required String visitId,
    File? checkInImgFile,
  }) async {
    return await _apiService.priceSubmit(
      token: token,
      productId: productId,
      storeID: storeID,
      price: price,
      promotion: promotion,
      priceTagPictureId: priceTagPictureId,
      teamMemberId: teamMemberId,
      netPrice: netPrice,
      installment3Month: installment3Month,
      installment6Month: installment6Month,
      installment12Month: installment12Month,
      isOutOfStock: isOutOfStock,
      visitId: visitId,
      checkInImgFile: checkInImgFile,
    );
  }
}
