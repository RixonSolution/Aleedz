import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class CoverageServices {
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

  Future<Map<String, dynamic>?> getCoverageList({
    required int teamMemberId,
    required String chanelId,
    required String searchKeyWord,
    required String chanelTypeId,
    required String token,
  }) async {
    final encodedTeamId = Uri.encodeComponent(teamMemberId.toString());
    final encodedChanelId = Uri.encodeComponent(chanelId);
    final encodedSearchKeyword = Uri.encodeComponent(searchKeyWord);
    final encodedChanelTypeId = Uri.encodeComponent(chanelTypeId);

    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.coverageList}?TeamMemberID=$encodedTeamId&ChannelID=$encodedChanelId&SearchKeyWord=$encodedSearchKeyword&ChannelTypeID=$encodedChanelTypeId&_token=$encodedToken ',
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
