import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/services/api_headers.dart';
import 'package:dio/dio.dart';

class AuthServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: ApiHeaders.defaultHeaders,
    ),
  );

  // GET login call
  Future<Map<String, dynamic>?> loginUser({
    required String username,
    required String password,
    required String deviceIMEIID,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.login,
        queryParameters: {
          "Username": username,
          "Password": password,
          "DeviceIMEIID": deviceIMEIID,
        },
        options: Options(headers: ApiHeaders.defaultHeaders),
      );

      return {"status": response.statusCode, "data": response.data};
    } catch (e) {
      if (e is DioException && e.response != null) {
        return {"status": e.response?.statusCode, "data": e.response?.data};
      }
      return null;
    }
  }
}
