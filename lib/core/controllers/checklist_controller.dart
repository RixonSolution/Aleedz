import 'package:aleedz/core/services/checklist_services.dart';

class ChecklistController {
  final ChecklistServices _apiService = ChecklistServices();

  Future<Map<String, dynamic>?> activityType({
    required String token,
    required String divisionId,
  }) async {
    return await _apiService.getActivityType(
      token: token,
      divisionId: divisionId,
    );
  }
}
