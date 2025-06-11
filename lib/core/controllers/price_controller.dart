import 'package:aleedz/core/services/price_services.dart';

class PriceController {
  final PriceServices _apiService = PriceServices();

  Future<Map<String, dynamic>?> brandDropDown({required String token}) async {
    return await _apiService.getBrandDropDown(token: token);
  }
}
