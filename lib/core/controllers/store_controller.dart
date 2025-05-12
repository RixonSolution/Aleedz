import 'dart:io';

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

  Future<Map<String, dynamic>?> auditMediaSubmit({
    required String token,
    required String productCategoryId,
    required String storeID,
    required String displayCheckMark,
    required String teamMemberId,
    File? checkInImgFile1,
    File? checkInImgFile2,
  }) async {
    return await _apiService.auditMediaSubmit(
      token: token,
      productCategoryId: productCategoryId,
      storeID: storeID,
      displayCheckMark: displayCheckMark,
      teamMemberId: teamMemberId,
      checkInImgFile1: checkInImgFile1,
      checkInImgFile2: checkInImgFile2,
    );
  }

  Future<Map<String, dynamic>?> getROSLabels({
    required String languageId,
  }) async {
    return await _apiService.getROSLabels(languageId: languageId);
  }
}
