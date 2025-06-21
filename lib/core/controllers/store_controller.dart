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
    required String brandId, // ➕ New parameter
  }) async {
    return await _apiService.checkAudit(
      storeId: storeId,
      categoryId: categoryId,
      token: token,
      brandId: brandId,
    );
  }

  Future<Map<String, dynamic>?> checkDisplayMaster({
    required String teamMemberId,
    required String storeId,
    required String categoryId,
    required String token,
    required String brandId, // ➕ New parameter
  }) async {
    return await _apiService.checkDisplayMaster(
      storeId: storeId,
      token: token,
      teamMemberId: teamMemberId,
      productCategoryId: categoryId,
      brandId: brandId,
    );
  }

  Future<Map<String, dynamic>?> auditMediaSubmit({
    required String token,
    required String productCategoryId,
    required String storeID,
    required String displayCheckMark,
    required String teamMemberId,
    required String brandId, // ➕ New parameter

    required List<File>
    checkInImages1, // List for DisplayCheckImage1 variations
    required List<File>
    checkInImages2, // List for DisplayCheckImage2 variations
  }) async {
    return await _apiService.auditMediaSubmit(
      token: token,
      productCategoryId: productCategoryId,
      storeID: storeID,
      displayCheckMark: displayCheckMark,
      teamMemberId: teamMemberId,
      checkInImages1: checkInImages1,
      checkInImages2: checkInImages2,
      brandId: brandId,
    );
  }

  Future<Map<String, dynamic>?> getROSLabels({
    required String languageId,
  }) async {
    return await _apiService.getROSLabels(languageId: languageId);
  }

  Future<Map<String, dynamic>?> getPermissionRequest({
    required String teamMemberId,
    required String token,
  }) async {
    return await _apiService.getPermissionRequest(
      teamMemberId: teamMemberId,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> pictureDropDown({required String token}) async {
    return await _apiService.getPictureDropDown(token: token);
  }

  Future<Map<String, dynamic>?> categoryIssueDropDown({
    required String token,
  }) async {
    return await _apiService.getIssueCategoryDropDown(token: token);
  }

  Future<Map<String, dynamic>?> submitDisplayPicture({
    required String token,
    required String storeId,
    required String teamMemberId,
    required String brandId,
    required String pictureElementId,
    required String remarks,
    required String pictureId,
    required String issueCategoryId,

    File? elementImg,
  }) async {
    return await _apiService.submitDisplayPicture(
      token: token,
      storeId: storeId,
      teamMemberId: teamMemberId,
      brandId: brandId,
      pictureElementId: pictureElementId,
      remarks: remarks,
      pictureId: pictureId,
      elementImg: elementImg,
      issueCategoryId: issueCategoryId,
    );
  }

  Future<Map<String, dynamic>?> viewPicture({
    required String token,
    required String storeId,
    required String brandId,
    required String elementId,
  }) async {
    return await _apiService.viewPictureApi(
      token: token,
      storeId: storeId,
      brandId: brandId,
      elementId: elementId,
    );
  }

  Future<Map<String, dynamic>?> deleteDisplayPicture({
    required String token,
    required String storeId,
    required String pictureId,
    required String pictureName,
  }) async {
    return await _apiService.deleteDisplayPicture(
      token: token,
      storeId: storeId,
      pictureId: pictureId,
      pictureName: pictureName,
    );
  }

  Future<Map<String, dynamic>?> getVisitId({
    required String storeId,
    required String teamMemberId,
    required String token,
  }) async {
    return await _apiService.getVisiteId(
      token: token,
      storeId: storeId,
      teamMemberId: teamMemberId,
    );
  }
}
