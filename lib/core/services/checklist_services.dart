import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class ChecklistServices {
  Future<Map<String, dynamic>?> getChecklistType({
    required String token,
    required String storeId,
    required String teamMemberId,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);

    final url = Uri.parse(
      '${ApiConstants.checklist}?_token=$encodedToken&StoreID=$encodedStoreId&TeamMemberID=$encodedTeamMemberId',
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

  Future<Map<String, dynamic>?> getChecklistSubmitList({
    required String token,
    required String storeId,
    required String teamMemberId,
    required String checklistCateId,
    required String visiteId,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedCheckListCateId = Uri.encodeComponent(checklistCateId);
    final encodedVisiteId = Uri.encodeComponent(visiteId);

    final url = Uri.parse(
      '${ApiConstants.checkListSubmitView}?_token=$encodedToken&StoreID=$encodedStoreId&TeamMemberID=$encodedTeamMemberId&CheckListCategoryID=$encodedCheckListCateId&VisitID=$encodedVisiteId',
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
