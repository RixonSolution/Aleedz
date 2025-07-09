import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class PendingDeploymentServices {
  Future<Map<String, dynamic>?> pendingList({
    required String token,
    required String activityCategory,
    required String teamMemberId,
  }) async {
    final encodedActivityCategory = Uri.encodeComponent(activityCategory);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.pendingDeployment}?ActivityCategory=$encodedActivityCategory&TeamMemberID=$encodedTeamMemberId&_token=$encodedToken',
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
