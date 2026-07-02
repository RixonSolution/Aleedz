import 'dart:io';

import 'package:aleedz/core/services/store_share_services.dart';

class StoreShareController {
  final StoreShareServices _apiService = StoreShareServices();

  Future<Map<String, dynamic>?> shelfShareCategorySummary({
    required String token,
    required String storeId,
    required String productCategoryId,
    required String weekNo,
    required String visitId,
  }) async {
    return await _apiService.shelfShareCategorySummary(
      token: token,
      storeId: storeId,
      productCategoryId: productCategoryId,
      weekNo: weekNo,
      visitId: visitId,
    );
  }

  Future<Map<String, dynamic>?> shelfShareCategoryDropdown({
    required String token,
  }) async {
    return await _apiService.shelfShareCategoryDropdown(token: token);
  }

  Future<Map<String, dynamic>?> shelfShareAllBrands({
    required String token,
  }) async {
    return await _apiService.shelfShareAllBrands(token: token);
  }

  Future<Map<String, dynamic>?> shelfShareBrandSummaryByCategory({
    required String token,
    required String storeId,
    required String productCategoryId,
    required String brandId,
    required String weekNo,
    required String visitId,
  }) async {
    return await _apiService.shelfShareBrandSummaryByCategory(
      token: token,
      storeId: storeId,
      productCategoryId: productCategoryId,
      brandId: brandId,
      weekNo: weekNo,
      visitId: visitId,
    );
  }

  Future<Map<String, dynamic>?> shelfShareBrandDisplayLocation({
    required String token,
    required String shelfShareId,
  }) async {
    return await _apiService.shelfShareBrandDisplayLocation(
      token: token,
      shelfShareId: shelfShareId,
    );
  }

  Future<Map<String, dynamic>?> shelfShareAdd({
    required String token,
    required String shelfShareId,
    required String storeId,
    required String productCategoryId,
    required String weekNo,
    required String year,
    required String brandId,
    required String facingCount,
    required String stockCount,
    required String visitId,
    required String teamMemberId,
  }) async {
    return await _apiService.shelfShareAdd(
      token: token,
      shelfShareId: shelfShareId,
      storeId: storeId,
      productCategoryId: productCategoryId,
      weekNo: weekNo,
      year: year,
      brandId: brandId,
      facingCount: facingCount,
      stockCount: stockCount,
      visitId: visitId,
      teamMemberId: teamMemberId,
    );
  }

  Future<Map<String, dynamic>?> shelfShareDisplayLocationAdd({
    required String token,
    required String shelfShareDisplayId,
    required String shelfShareId,
    required String shelfShareDisplayLocationId,
    required String isShelfShareDisplay,
    required String teamMemberId,
  }) async {
    return await _apiService.shelfShareDisplayLocationAdd(
      token: token,
      shelfShareDisplayId: shelfShareDisplayId,
      shelfShareId: shelfShareId,
      shelfShareDisplayLocationId: shelfShareDisplayLocationId,
      isShelfShareDisplay: isShelfShareDisplay,
      teamMemberId: teamMemberId,
    );
  }

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

  Future<Map<String, dynamic>?> elementTypeList({required String token}) async {
    return await _apiService.elementTypeList(token: token);
  }

  Future<Map<String, dynamic>?> storeShareSummary({
    required String token,
    required String storeId,
    required String brandId,
    required String storeShareElementTypeId,
    required String storeShareElementId,
    required String visitId,
  }) async {
    return await _apiService.storeShareSummary(
      token: token,
      storeId: storeId,
      brandId: brandId,
      storeShareElementTypeId: storeShareElementTypeId,
      storeShareElementId: storeShareElementId,
      visitId: visitId,
    );
  }

  Future<Map<String, dynamic>?> storeShareAdd({
    required String token,
    required String storeId,
    required String storeShareElementId,
    required String brandId,
    required String teamMemberId,
    required String visitId,
    required String count,
    File? storeShareImage,
  }) async {
    return await _apiService.storeShareAdd(
      token: token,
      storeId: storeId,
      storeShareElementId: storeShareElementId,
      brandId: brandId,
      teamMemberId: teamMemberId,
      visitId: visitId,
      count: count,
      storeShareImage: storeShareImage,
    );
  }
}
