import 'package:aleedz/core/services/auth_services.dart';

class AuthController {
  final AuthServices _apiService = AuthServices();

  Future<Map<String, dynamic>?> loginUser({
    required String username,
    required String password,
    required String deviceIMEIID,
  }) async {
    return await _apiService.loginUser(
      username: username,
      password: password,
      deviceIMEIID: deviceIMEIID,
    );
  }

  Future<Map<String, dynamic>?> requestUserPermission({
    required int userTeamId,
    required String userToken,
  }) async {
    return await _apiService.requestPermission(
      teamId: userTeamId,
      token: userToken,
    );
  }
}
