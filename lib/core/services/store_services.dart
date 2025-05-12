import 'dart:convert';
import 'dart:io';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class StoreServices {
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

  Future<Map<String, dynamic>?> auditMediaSubmit({
    required String token,
    required String productCategoryId,
    required String storeID,
    required String displayCheckMark,
    required String teamMemberId,
    File? checkInImgFile1,
    File? checkInImgFile2,
  }) async {
    try {
      // Step 1: Create URL with query parameters
      final url = Uri.parse(
        '${ApiConstants.checkDisplayAddMedia}?'
        '_token=${Uri.encodeComponent(token)}&'
        'ProductCategoryID=${Uri.encodeComponent(productCategoryId)}&'
        'StoreID=${Uri.encodeComponent(storeID)}&'
        'DisplayCheckRemarks=${Uri.encodeComponent(displayCheckMark)}&'
        'TeamMemberID=${Uri.encodeComponent(teamMemberId)}',
      );

      // Step 2: Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add first image
      if (checkInImgFile1 != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'DisplayCheckImage1',
            checkInImgFile1.path,
          ),
        );
      }
      if (checkInImgFile2 != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'DisplayCheckImage2',
            checkInImgFile2.path,
          ),
        );
      }
      // Add second image

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

  Future<Map<String, dynamic>?> getROSLabels({
    required String languageId,
  }) async {
    final encodedLanguageId = Uri.encodeComponent(languageId);

    final url = Uri.parse(
      '${ApiConstants.language}?LanguageID=$encodedLanguageId',
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
