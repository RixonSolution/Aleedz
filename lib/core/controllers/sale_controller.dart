import 'package:aleedz/core/services/sale_services.dart';

class SaleController {
  final SaleServices _apiService = SaleServices();

  Future<Map<String, dynamic>?> brandDropDown({required String token}) async {
    return await _apiService.getBrandDropDown(token: token);
  }

  Future<Map<String, dynamic>?> getProductCategory({
    required String token,
    required String brandId,
  }) async {
    return await _apiService.getProductCategory(token: token, brandId: brandId);
  }

  Future<Map<String, dynamic>?> getModelSearchDP({
    required String token,
    required String brandId,
    required String productCategoryId,
    required String storeId,
  }) async {
    return await _apiService.getModelSearchDP(
      token: token,
      brandId: brandId,
      productCategoryId: productCategoryId,
      storeId: storeId,
    );
  }

  Future<Map<String, dynamic>?> addSale({
    required String token,
    required String productCategoryId,
    required String storeId,
    required String saleCount,
    required String salePrice,
    required String teamMemberId,
    required String saleDate,
    required String saleType,
  }) async {
    return await _apiService.submitSale(
      token: token,
      productCategoryId: productCategoryId,
      storeId: storeId,
      saleCount: saleCount,
      salePrice: salePrice,
      teamMemberId: teamMemberId,
      saleDate: saleDate,
      saleType: saleType,
    );
  }

  Future<Map<String, dynamic>?> saleView({
    required String token,
    required String storeId,
    required String saleDate,
    required String teamMemberId,
  }) async {
    return await _apiService.saleView(
      token: token,
      storeId: storeId,
      teamMemberId: teamMemberId,
      saleDate: saleDate,
    );
  }

  Future<Map<String, dynamic>?> removeSale({
    required String token,
    required String storeId,
    required String saleId,
    required String teamMemberId,
  }) async {
    return await _apiService.deleteSale(
      token: token,
      storeId: storeId,
      teamMemberId: teamMemberId,
      saleId: saleId,
    );
  }
}
