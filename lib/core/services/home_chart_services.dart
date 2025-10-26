import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class HomeChartServices {
  Future<Map<String, dynamic>?> getCoverageCount({
    required int teamMemberId,
    required String token,
  }) async {
    final encodedTeamId = Uri.encodeComponent(teamMemberId.toString());
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.coverageCount}?TeamMemberID=$encodedTeamId&_token=$encodedToken',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMonthlySale({
    required int teamMemberId,
    required String token,
    required String targetYear,
    required String targetMonth,
  }) async {
    final encodedTeamId = Uri.encodeComponent(teamMemberId.toString());
    final encodedToken = Uri.encodeComponent(token);
    final encodedTargetYear = Uri.encodeComponent(targetYear);
    final encodedTargetMonth = Uri.encodeComponent(targetMonth);

    final url = Uri.parse(
      '${ApiConstants.targetMonthlySale}?TargetMonth=$encodedTargetMonth&TargetYear=$encodedTargetYear&TeamMemberID=$encodedTeamId&_token=$encodedToken',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMonthlyTargeValue({
    required int teamMemberId,
    required String token,
    required String targetYear,
    required String targetMonth,
  }) async {
    final encodedTeamId = Uri.encodeComponent(teamMemberId.toString());
    final encodedToken = Uri.encodeComponent(token);
    final encodedTargetYear = Uri.encodeComponent(targetYear);
    final encodedTargetMonth = Uri.encodeComponent(targetMonth);

    final url = Uri.parse(
      '${ApiConstants.targetMonthlyTargetValue}?TargetMonth=$encodedTargetMonth&TargetYear=$encodedTargetYear&TeamMemberID=$encodedTeamId&_token=$encodedToken',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMonthlyRecentSale({
    required int teamMemberId,
    required String token,
  }) async {
    final encodedTeamId = Uri.encodeComponent(teamMemberId.toString());
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.promoterRecentSale}?TeamMemberID=$encodedTeamId&_token=$encodedToken',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMonthlyDashboardSale({
    required int teamMemberId,
    required String token,
  }) async {
    final encodedTeamId = Uri.encodeComponent(teamMemberId.toString());
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.promoterMonthlySale}?TeamMemberID=$encodedTeamId&_token=$encodedToken',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTargetAchievementValue({
    required int brandId,
    required String month,
    required String year,
    required int teamMemberId,
    required String token,
  }) async {
    final encodedBrandId = Uri.encodeComponent(brandId.toString());
    final encodedMonth = Uri.encodeComponent(month);
    final encodedYear = Uri.encodeComponent(year);
    final encodedTeamId = Uri.encodeComponent(teamMemberId.toString());
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.targetAchievementValue}?BrandID=$encodedBrandId&Month=$encodedMonth&Year=$encodedYear&TeamMemberID=$encodedTeamId&_token=$encodedToken',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTargetAchievementQty({
    required int brandId,
    required String month,
    required String year,
    required int teamMemberId,
    required String token,
  }) async {
    final encodedBrandId = Uri.encodeComponent(brandId.toString());
    final encodedMonth = Uri.encodeComponent(month);
    final encodedYear = Uri.encodeComponent(year);
    final encodedTeamId = Uri.encodeComponent(teamMemberId.toString());
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.targetAchievementQty}?BrandID=$encodedBrandId&Month=$encodedMonth&Year=$encodedYear&TeamMemberID=$encodedTeamId&_token=$encodedToken',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }
}
