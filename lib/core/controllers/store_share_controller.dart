import 'package:aleedz/core/services/store_share_services.dart';

class StoreShareController {
  final StoreShareServices _apiService = StoreShareServices();

  Future<Map<String, dynamic>?> brandList({
    required String token,
    required String storeId,
    required String visitId,

    required String teamMemberId,
  }) async {
    return await _apiService.brandList(
      token: token,
      storeId: storeId,
      visitId: visitId,
      teamMemberId: teamMemberId,
    );
  }

  Future<Map<String, dynamic>?> categoryList({
    required String token,
    required String storeId,
    required String visitId,
    required String teamMemberId,
    required String brandId,
  }) async {
    return await _apiService.categoryList(
      token: token,
      storeId: storeId,
      visitId: visitId,
      teamMemberId: teamMemberId,
      brandId: brandId,
    );
  }

  Future<Map<String, dynamic>?> productList({
    required String token,
    required String storeId,
    required String visitId,
    required String teamMemberId,
    required String productCategoryId,
    required String brandId,
  }) async {
    return await _apiService.productList(
      token: token,
      storeId: storeId,
      visitId: visitId,
      teamMemberId: teamMemberId,
      brandId: brandId,
      productCategoryId: productCategoryId,
    );
  }

  Future<Map<String, dynamic>?> brandDropDown({required String token}) async {
    return await _apiService.getBrandDropDown(token: token);
  }
}
