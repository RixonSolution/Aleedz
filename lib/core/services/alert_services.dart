import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class AlertServices {
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
    final encodedRegionId = Uri.encodeComponent(regionId.toString());
    final encodedCityId = Uri.encodeComponent(cityId.toString());
    final encodedActivityCategoryId = Uri.encodeComponent(
      activityCategoryId.toString(),
    );
    final encodedChannelId = Uri.encodeComponent(channelId.toString());
    final encodedStoreId = Uri.encodeComponent(storeId.toString());
    final encodedDateFrom = Uri.encodeComponent(dateFrom);
    final encodedDateTo = Uri.encodeComponent(dateTo);
    final encodedAlertType = Uri.encodeComponent(alertType.toString());
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.managementAlert}?RegionID=$encodedRegionId&CityID=$encodedCityId&ActivityCategoryID=$encodedActivityCategoryId&ChannelID=$encodedChannelId&StoreID=$encodedStoreId&DateFrom=$encodedDateFrom&DateTo=$encodedDateTo&AlertType=$encodedAlertType&_token=$encodedToken',
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
