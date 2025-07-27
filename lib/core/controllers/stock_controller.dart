import 'package:aleedz/core/services/stock_services.dart';

class StockController {
  final StockServices _apiService = StockServices();

  Future<Map<String, dynamic>?> brandDropDown({required String token}) async {
    return await _apiService.getBrandDropDown(token: token);
  }

  Future<Map<String, dynamic>?> stockSummary({
    required String storeId,
    required String branddId,
    required String token,
    required String visitId,
  }) async {
    return await _apiService.stockSummary(
      storeId: storeId,
      brandId: branddId,
      token: token,
      visitId: visitId,
    );
  }

  Future<Map<String, dynamic>?> stockView({
    required String storeId,
    required String branddId,
    required String token,
    required String visitId,
    required String teamMemberId,
    required String productCategoryId,
    required String inputTypeId,
  }) async {
    return await _apiService.stockView(
      storeId: storeId,
      brandId: branddId,
      token: token,
      visitId: visitId,
      teamMemberId: teamMemberId,
      productCategoryId: productCategoryId,
      inputTypeId: inputTypeId,
    );
  }

  Future<Map<String, dynamic>?> stockAdd({
    required String productId,
    required String storeId,
    required String visitId,
    required String teamMemberId,
    required String stock,
    required String token,
  }) async {
    return await _apiService.stockAdd(
      storeId: storeId,
      token: token,
      visitId: visitId,
      teamMemberId: teamMemberId,
      productId: productId,
      stock: stock,
    );
  }
}
