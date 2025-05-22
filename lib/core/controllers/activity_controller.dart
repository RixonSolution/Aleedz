import 'package:aleedz/core/services/activity_services.dart';

class ActivityController {
  final ActivityServices _apiService = ActivityServices();

  Future<Map<String, dynamic>?> brandDropDown({required String token}) async {
    return await _apiService.getBrandDropDown(token: token);
  }
}
