import 'package:aleedz/core/services/activity_services.dart';

class ActivityController {
  final ActivityServices _apiService = ActivityServices();

  Future<Map<String, dynamic>?> activityType({
    required String token,
    required String divisionId,
  }) async {
    return await _apiService.getActivityType(
      token: token,
      divisionId: divisionId,
    );
  }

  Future<Map<String, dynamic>?> activityCategoryId({
    required String token,
    required String divisionId,
    required String categoryTypeId,
  }) async {
    return await _apiService.getActivityCategory(
      token: token,
      divisionId: divisionId,
      categoryTypeId: categoryTypeId,
    );
  }
}
