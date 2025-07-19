import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class OpenIssuesServices {
  Future<Map<String, dynamic>?> getIssueList({
    required String teamMemberId,
    required String chanelTypeId,
    required String storeId,
    required String token,
  }) async {
    final encodedTeamMeberId = Uri.encodeComponent(teamMemberId);
    final encodedChanelTypeId = Uri.encodeComponent(chanelTypeId);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.openIssues}?TeamMemberID=$encodedTeamMeberId&ChannelTypeID=$encodedChanelTypeId&StoreID=$encodedStoreId&_token=$encodedToken',
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
