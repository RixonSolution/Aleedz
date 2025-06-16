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
}
