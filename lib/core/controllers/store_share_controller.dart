import 'dart:io';

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
