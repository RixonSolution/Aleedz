import 'package:aleedz/core/services/alert_services.dart';

class AlertController {
  final AlertServices _apiService = AlertServices();

  Future<Map<String, dynamic>?> getManagementAlerts({
    required int regionId,
    required int cityId,
    required int activityCategoryId,
    required int channelId,
    required int storeId,
    required String dateFrom,
    required String dateTo,
    required int alertType,
    required String token,
  }) async {
    return await _apiService.getManagementAlerts(
      regionId: regionId,
      cityId: cityId,
      activityCategoryId: activityCategoryId,
      channelId: channelId,
      storeId: storeId,
      dateFrom: dateFrom,
      dateTo: dateTo,
      alertType: alertType,
      token: token,
    );
  }
}
