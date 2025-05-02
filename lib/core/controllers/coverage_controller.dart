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

  Future<Map<String, dynamic>?> coverageCheckIn({
    required String teamMemberId,
    required String storeID,
    required String planRemarks,
    required String planDate,
    required String longitude,
    required String latitude,
    required String remarks,
    required String isLocationAvailable,
    required String checkInImg,
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
      checkInImg: checkInImg,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> coverageCheckOut({
    required String visitedId,
    required String longitude,
    required String latitude,
    required String remarks,
    required String checkInImg,
    required String token,
  }) async {
    return await _apiService.coverageCheckOut(
      visitedId: visitedId,
      longitude: longitude,
      latitude: latitude,
      remarks: remarks,
      checkInImg: checkInImg,
      token: token,
    );
  }
}
