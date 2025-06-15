import 'package:aleedz/core/services/training_services.dart';

class ChecklistController {
  final TrainingServices _apiService = TrainingServices();

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
