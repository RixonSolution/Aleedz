import 'package:aleedz/core/services/open_issues_services.dart';

class OpenIssuesController {
  final OpenIssuesServices _apiService = OpenIssuesServices();

  Future<Map<String, dynamic>?> issueList({
    required String token,
    required String teamMemberId,
    required String chanelTypeId,
    required String storeId,
  }) async {
    return await _apiService.getIssueList(
      token: token,
      teamMemberId: teamMemberId,
      chanelTypeId: chanelTypeId,
      storeId: storeId,
    );
  }
}
