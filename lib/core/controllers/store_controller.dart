import 'package:aleedz/core/services/store_services.dart';

class StoreController {
  final StoreServices _apiService = StoreServices();

  Future<Map<String, dynamic>?> brandDropDown({required String token}) async {
    return await _apiService.getBrandDropDown(token: token);
  }

  Future<Map<String, dynamic>?> displayCheckSummany({
    required String storeId,
    required String branddId,

    required String token,
  }) async {
    return await _apiService.displayCheckSummary(
      storeId: storeId,
      brandId: branddId,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> checkAudit({
    required String storeId,
    required String categoryId,
    required String token,
  }) async {
    return await _apiService.checkAudit(
      storeId: storeId,
      categoryId: categoryId,
      token: token,
    );
  }
}
