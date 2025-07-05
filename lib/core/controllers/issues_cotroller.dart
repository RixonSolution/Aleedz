import 'dart:io';
import 'package:aleedz/core/services/issues_services.dart';

class IssuesController {
  final IssuesServices _apiService = IssuesServices();

  Future<Map<String, dynamic>?> issueList({
    required String token,
    required String divisionId,
    required String categoryTypeId,
  }) async {
    return await _apiService.getIssueList(
      token: token,
      divisionId: divisionId,
      categoryTypeId: categoryTypeId,
    );
  }

  Future<Map<String, dynamic>?> removeActivity({
    required String token,
    required String activityId,
    required String activityTypeId,
  }) async {
    return await _apiService.removeActivityType(
      token: token,
      activityId: activityId,
      activityTypeId: activityTypeId,
    );
  }

  Future<Map<String, dynamic>?> activityList({
    required String storeId,
    required String activityCategoryId,
    required String activityTypeId,
    required String brandId,
    required String teamMemberId,
    required String token,
  }) async {
    return await _apiService.getMarketActivity(
      storeId: storeId,
      activityCategoryId: activityCategoryId,
      activityTypeId: activityTypeId,
      brandId: brandId,
      teamMemberId: teamMemberId,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> marketActivityAdd({
    required String teamMemberId,
    required String token,
    required String storeID,
    required String activityTypeId,
    required String activityCategoryId,
    required String brandId,
    required String activityDescription,
    required String statusId,
    required String quantity,
    required String deployementReason,
    List<File>? beforeActivityPictures, // Updated: accepts list of images
  }) async {
    return await _apiService.marketActivityAdd(
      token: token,
      storeID: storeID,
      teamMemberId: teamMemberId,
      beforeActivityPictures: beforeActivityPictures, // Updated
      activityTypeId: activityTypeId,
      activityCategoryId: activityCategoryId,
      brandId: brandId,
      activityDescription: activityDescription,
      statusId: statusId,
      quantity: quantity,
      deployementReason: deployementReason,
    );
  }
}
