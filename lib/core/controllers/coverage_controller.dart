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
}
