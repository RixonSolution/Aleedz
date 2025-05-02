import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  Future<Map<String, dynamic>?> loginUser({
    required String username,
    required String password,
    required String deviceIMEIID,
  }) async {
    final encodedUsername = Uri.encodeComponent(username);
    final encodedPassword = Uri.encodeComponent(password);
    final encodedDeviceIMEIID = Uri.encodeComponent(deviceIMEIID);

    final url = Uri.parse(
      '${ApiConstants.login}?Username=$encodedUsername&Password=$encodedPassword&DeviceIMEIID=$encodedDeviceIMEIID',
    );

    // final url = Uri.parse('${ApiConstants.login}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          // Removed 'Content-Type' because it's not needed for GET
        },
      );

      print(
        jsonEncode({
          "Username": username,
          "Password": password,
          "DeviceIMEIID": deviceIMEIID,
        }),
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> requestPermission({
    required int teamId,
    required String token,
  }) async {
    final encodedTeamId = Uri.encodeComponent(teamId.toString());
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.requestPermission}?TeamMemberID=$encodedTeamId&_token=$encodedToken',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      print(jsonEncode({"Username": teamId, "Password": token}));

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> chooseLanguage({
    required String languageId,
  }) async {
    final encodedLanguageId = Uri.encodeComponent(languageId);

    final url = Uri.parse(
      '${ApiConstants.language}?LanguageID=$encodedLanguageId',
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
