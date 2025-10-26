import 'package:aleedz/core/services/home_chart_services.dart';

class HomeChartController {
  final HomeChartServices _apiService = HomeChartServices();

  Future<Map<String, dynamic>?> coverageCount({
    required int teamMemberId,
    required String token,
  }) async {
    return await _apiService.getCoverageCount(
      teamMemberId: teamMemberId,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> getMonthlySale({
    required int teamMemberId,
    required String token,
    required String targetYear,
    required String targetMonth,
  }) async {
    return await _apiService.getMonthlySale(
      teamMemberId: teamMemberId,
      token: token,
      targetYear: targetYear,
      targetMonth: targetMonth,
    );
  }

  Future<Map<String, dynamic>?> getMonthlyTargetValue({
    required int teamMemberId,
    required String token,
    required String targetYear,
    required String targetMonth,
  }) async {
    return await _apiService.getMonthlyTargeValue(
      teamMemberId: teamMemberId,
      token: token,
      targetYear: targetYear,
      targetMonth: targetMonth,
    );
  }

  Future<Map<String, dynamic>?> getMonthlyRecentSale({
    required int teamMemberId,
    required String token,
  }) async {
    return await _apiService.getMonthlyRecentSale(
      teamMemberId: teamMemberId,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> getMonthlyDashboardSale({
    required int teamMemberId,
    required String token,
  }) async {
    return await _apiService.getMonthlyDashboardSale(
      teamMemberId: teamMemberId,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> getTargetAchievementValue({
    required int brandId,
    required String month,
    required String year,
    required int teamMemberId,
    required String token,
  }) async {
    return await _apiService.getTargetAchievementValue(
      brandId: brandId,
      month: month,
      year: year,
      teamMemberId: teamMemberId,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> getTargetAchievementQty({
    required int brandId,
    required String month,
    required String year,
    required int teamMemberId,
    required String token,
  }) async {
    return await _apiService.getTargetAchievementQty(
      brandId: brandId,
      month: month,
      year: year,
      teamMemberId: teamMemberId,
      token: token,
    );
  }
}
