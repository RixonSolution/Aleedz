import 'dart:convert';
import 'dart:io';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class CoverageServices {
  Future<Map<String, dynamic>?> getCoverageCount({
    required int teamMemberId,
    required String token,
  }) async {
    final encodedTeamId = Uri.encodeComponent(teamMemberId.toString());
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.coverageCount}?TeamMemberID=$encodedTeamId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> getCoverageList({
    required int teamMemberId,
    required int chanelId,
    required String searchKeyWord,
    required String chanelTypeId,
    required String token,
  }) async {
    final encodedTeamId = Uri.encodeComponent(teamMemberId.toString());
    final encodedChanelId = Uri.encodeComponent(chanelId.toString());
    final encodedSearchKeyword = Uri.encodeComponent(searchKeyWord);
    final encodedChanelTypeId = Uri.encodeComponent(chanelTypeId);

    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.coverageList}?TeamMemberID=$encodedTeamId&ChannelID=$encodedChanelId&SearchKeyWord=$encodedSearchKeyword&ChannelTypeID=$encodedChanelTypeId&_token=$encodedToken ',
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

  Future<Map<String, dynamic>?> getCoverageDropDown({
    required String token,
  }) async {
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.coverageDropDown}?_token=$encodedToken',
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

  Future<Map<String, dynamic>?> getBrandDropDown({
    required String token,
  }) async {
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse('${ApiConstants.brandDropDown}?_token=$encodedToken');

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

  Future<Map<String, dynamic>?> coverageCheckIn({
    required String teamMemberId,
    required String storeID,
    required String planRemarks,
    required String planDate,
    required String longitude,
    required String latitude,
    required String remarks,
    required String isLocationAvailable,
    required File checkInImgFile,
    required String token,
  }) async {
    try {
      // Step 1: Create URL with query parameters
      final url = Uri.parse(
        '${ApiConstants.checkIn}?'
        'TeamMemberID=${Uri.encodeComponent(teamMemberId)}&'
        'StoreID=${Uri.encodeComponent(storeID)}&'
        'PlanRemarks=${Uri.encodeComponent(planRemarks)}&'
        'PlanDate=${Uri.encodeComponent(planDate)}&'
        'Longitude=${Uri.encodeComponent(longitude)}&'
        'Latitude=${Uri.encodeComponent(latitude)}&'
        'Remarks=${Uri.encodeComponent(remarks)}&'
        'IsLocationAvailable=${Uri.encodeComponent(isLocationAvailable)}&'
        '_token=${Uri.encodeComponent(token)}',
      );

      // Step 2: Create multipart request with only the image in the body
      var request = http.MultipartRequest('POST', url);

      request.files.add(
        await http.MultipartFile.fromPath('CheckInImg', checkInImgFile.path),
      );

      // Step 3: Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Error during check-in: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> coverageCheckOut({
    required String visitedId,
    required String longitude,
    required String latitude,
    required String remarks,
    required File checkOutImgFile,
    required String token,
  }) async {
    try {
      // Step 1: Build URL with query parameters
      final url = Uri.parse(
        '${ApiConstants.checkOut}?'
        'VisitID=${Uri.encodeComponent(visitedId)}&'
        'Longitude=${Uri.encodeComponent(longitude)}&'
        'Latitude=${Uri.encodeComponent(latitude)}&'
        'Remarks=${Uri.encodeComponent(remarks)}&'
        '_token=${Uri.encodeComponent(token)}',
      );

      // Step 2: Create multipart request (image in body)
      final request = http.MultipartRequest('POST', url);

      request.files.add(
        await http.MultipartFile.fromPath(
          'CheckOutImage',
          checkOutImgFile.path,
        ),
      );

      // Step 3: Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Error during checkout: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> displayCheckSummary({
    required String storeId,
    required String brandId,
    required String token,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.displayCheckSummary}?StoreID=$encodedStoreId&BrandID=$encodedBrandId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> checkAudit({
    required String storeId,
    required String categoryId,
    required String token,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedCategoryId = Uri.encodeComponent(categoryId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.checkAudit}?StoreID=$encodedStoreId&ProductCategoryID=$encodedCategoryId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> displayCheckAdd({
    required List<Map<String, dynamic>> dataList,
  }) async {
    final url = Uri.parse(ApiConstants.checkDisplayAdd);

    final body = {"data": dataList};

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> displayCheckAddService({
    required List<Map<String, dynamic>> dataList,
  }) async {
    final url = Uri.parse(ApiConstants.checkDisplayAdd);

    final body = {"data": dataList};

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> cancelVisite({
    required String visiteId,
    required String lng,
    required String lat,
    required String remark,
    required String planDate,
    required String teamMemberId,
    required String storeId,
    required String token,
  }) async {
    final encodedVisiteId = Uri.encodeComponent(visiteId);
    final encodedLongitude = Uri.encodeComponent(lng);
    final encodedLatitude = Uri.encodeComponent(lat);
    final encodedRemarks = Uri.encodeComponent(remark);
    final encodedPlanDate = Uri.encodeComponent(planDate);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.cancelVisite}?VisitID=$encodedVisiteId&Longitude=$encodedLongitude&Latitude=$encodedLatitude&Remarks=$encodedRemarks&PlanDate=$encodedPlanDate&_token=$encodedToken&TeamMemberID=$encodedTeamMemberId&StoreID=$encodedStoreId',
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
