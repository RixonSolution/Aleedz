import 'dart:io';

import 'package:aleedz/core/services/coverage_services.dart';

class CoverageController {
  final CoverageServices _apiService = CoverageServices();

  Future<Map<String, dynamic>?> coverageCount({
    required int teamMemberId,
    required String token,
  }) async {
    return await _apiService.getCoverageCount(
      teamMemberId: teamMemberId,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> coverageList({
    required int teamMemberId,
    required int chanelId,
    required String searchKeyWord,
    required String chanelTypeId,
    required String token,
  }) async {
    return await _apiService.getCoverageList(
      teamMemberId: teamMemberId,
      chanelId: chanelId,
      searchKeyWord: searchKeyWord,
      chanelTypeId: chanelTypeId,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> coverageDropDown({
    required String token,
  }) async {
    return await _apiService.getCoverageDropDown(token: token);
  }

  Future<Map<String, dynamic>?> brandDropDown({required String token}) async {
    return await _apiService.getBrandDropDown(token: token);
  }

  Future<Map<String, dynamic>?> coverageCheckIn({
    required String teamMemberId,
    required String storeID,
    required String planRemarks,
    required String planDate,
    required String longitude,
    required String latitude,
    required String remarks,
    required String isLocationAvailable,
    File? checkInImgFile, // ✅ Changed from String to File
    required String token,
  }) async {
    return await _apiService.coverageCheckIn(
      teamMemberId: teamMemberId,
      storeID: storeID,
      planRemarks: planRemarks,
      planDate: planDate,
      longitude: longitude,
      latitude: latitude,
      remarks: remarks,
      isLocationAvailable: isLocationAvailable,
      checkInImgFile: checkInImgFile, // ✅ Pass File
      token: token,
    );
  }

  Future<Map<String, dynamic>?> dashboardCheckIn({
    required String visiteId,
    required String longitude,
    required String latitude,
    required String remarks,
    required File checkInImgFile,
    required String token,
  }) async {
    return await _apiService.dashboardCheckIn(
      longitude: longitude,
      latitude: latitude,
      remarks: remarks,
      checkInImgFile: checkInImgFile,
      token: token,
      visiteId: visiteId,
    );
  }

  Future<Map<String, dynamic>?> coverageCheckOut({
    required String visitedId,
    required String longitude,
    required String latitude,
    required String remarks,
    File? checkOutImgFile, // Now using File instead of base64 string
    required String token,
  }) async {
    return await _apiService.coverageCheckOut(
      visitedId: visitedId,
      longitude: longitude,
      latitude: latitude,
      remarks: remarks,
      checkOutImgFile: checkOutImgFile, // Pass image file here
      token: token,
    );
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
    required String brandId, // <-- new parameter
  }) async {
    return await _apiService.checkAudit(
      storeId: storeId,
      categoryId: categoryId,
      token: token,
      brandId: brandId,
    );
  }

  Future<Map<String, dynamic>?> displayCheckAddController({
    required List<Map<String, dynamic>> dataList,
  }) async {
    return await _apiService.displayCheckAddService(dataList: dataList);
  }

  Future<Map<String, dynamic>?> cancelVisite({
    required String visiteId,
    required String lng,
    required String lat,
    required String remark,
    required String planDate,
    required String teamMemberId,
    required String storeId,
    required String token,
  }) async {
    return await _apiService.cancelVisite(
      visiteId: visiteId,
      lng: lng,
      lat: lat,
      remark: remark,
      planDate: planDate,
      teamMemberId: teamMemberId,
      storeId: storeId,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> getDashboard({
    required String token,
    required String planDate,
    required String teamMemberId,
    required String visiteSatue,
  }) async {
    return await _apiService.getDashboard(
      token: token,
      planDate: planDate,
      teamMemberId: teamMemberId,
      visiteStatus: visiteSatue,
    );
  }
}
