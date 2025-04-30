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
}
