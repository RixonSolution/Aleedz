import 'package:aleedz/core/services/pending_deployement.dart';

class PendingDeploymentController {
  final PendingDeploymentServices _apiService = PendingDeploymentServices();

  Future<Map<String, dynamic>?> pendingList({
    required String token,
    required String activityCategory,

    required String teamMemberId,
  }) async {
    return await _apiService.pendingList(
      token: token,
      activityCategory: activityCategory,
      teamMemberId: teamMemberId,
    );
  }
}
