import 'package:aleedz/core/services/store_share_services.dart';

class StoreShareController {
  final StoreShareServices _apiService = StoreShareServices();

  Future<Map<String, dynamic>?> trainingList({
    required String token,
    required String storeId,
    required String teamMemberId,
  }) async {
    return await _apiService.trainingList(
      token: token,
      storeId: storeId,
      teamMemberId: teamMemberId,
    );
  }

  Future<Map<String, dynamic>?> brandDropDown({required String token}) async {
    return await _apiService.getBrandDropDown(token: token);
  }
}
