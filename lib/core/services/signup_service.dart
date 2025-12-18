import 'dart:convert';

import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class SignupService {
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String mobile,
    required int regionId,
    required String password,
    required String token,
    String teamTypeId = '5',
    String activeStatus = '1',
    String identifier = 'email',
  }) async {
    final uri = Uri.parse(ApiConstants.signUp).replace(
      queryParameters: {
        'TeamTypeID': teamTypeId,
        'mySingleID': identifier,
        'TeamMemberName': name,
        'Email': email,
        'Mobile': mobile,
        'ActiveStatus': activeStatus,
        '_token': token,
        'RegionID': regionId.toString(),
        'Password': password,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    final payload = _extractJson(response.body);
    final decoded = json.decode(payload);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected signup response.');
    }
    return decoded;
  }

  String _extractJson(String body) {
    final start = body.indexOf('{');
    final end = body.lastIndexOf('}');

    if (start != -1 && end != -1 && end >= start) {
      return body.substring(start, end + 1);
    }
    throw FormatException('Signup response missing JSON payload.');
  }
}
