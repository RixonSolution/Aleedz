import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class TrainingServices {
  Future<Map<String, dynamic>?> getActivityType({
    required String token,
    required String divisionId,
  }) async {
    final encodedDivisionId = Uri.encodeComponent(divisionId);

    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.activityTypeList}?DivisionID=$encodedDivisionId&_Token=$encodedToken',
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
