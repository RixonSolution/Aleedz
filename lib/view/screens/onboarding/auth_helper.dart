import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthHelper {
  static final _storage = FlutterSecureStorage();
  static final _auth = LocalAuthentication();

  static Future<bool> isBiometricAvailable() async {
    return await _auth.canCheckBiometrics;
  }

  static Future<bool> authenticateWithBiometrics() async {
    return await _auth.authenticate(
      localizedReason: 'Use fingerprint to login',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
  }

  static Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);
  }

  static Future<Map<String, String?>> getCredentials() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  static Future<void> clearCredentials() async {
    await _storage.deleteAll();
  }
}
