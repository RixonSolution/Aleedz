import 'dart:convert';
import 'dart:io';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class StoreShareServices {
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

  Future<Map<String, dynamic>?> brandList({
    required String token,
    required String storeId,
    required String visitId,

    required String teamMemberId,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedVisitId = Uri.encodeComponent(visitId);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.brandStoreShare}?StoreID=$encodedStoreId&VisitID=$encodedVisitId&TeamMemberID=$encodedTeamMemberId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> categoryList({
    required String token,
    required String storeId,
    required String visitId,
    required String brandId,
    required String teamMemberId,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedVisitId = Uri.encodeComponent(visitId);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.categoryStoreShare}?StoreID=$encodedStoreId&VisitID=$encodedVisitId&TeamMemberID=$encodedTeamMemberId&BrandID=$encodedBrandId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> productList({
    required String token,
    required String storeId,
    required String visitId,
    required String brandId,
    required String productCategoryId,
    required String teamMemberId,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedVisitId = Uri.encodeComponent(visitId);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedProductCategoryId = Uri.encodeComponent(productCategoryId);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.productStoreShare}?StoreID=$encodedStoreId&VisitID=$encodedVisitId&TeamMemberID=$encodedTeamMemberId&BrandID=$encodedBrandId&ProductCategoryID=$encodedProductCategoryId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> elementTypeList({required String token}) async {
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.storeShareElementType}?_token=$encodedToken',
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

  Future<Map<String, dynamic>?> storeShareSummary({
    required String token,
    required String storeId,
    required String brandId,
    required String storeShareElementTypeId,
    required String storeShareElementId,
    required String visitId,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedElementTypeId = Uri.encodeComponent(storeShareElementTypeId);
    final encodedElementId = Uri.encodeComponent(storeShareElementId);
    final encodedVisitId = Uri.encodeComponent(visitId);

    final url = Uri.parse(
      '${ApiConstants.storeShareSummary}?_token=$encodedToken&StoreID=$encodedStoreId&BrandID=$encodedBrandId&StoreShare_ElementTypeID=$encodedElementTypeId&StoreShareElementID=$encodedElementId&VisitID=$encodedVisitId',
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

  Future<Map<String, dynamic>?> storeShareAdd({
    required String token,
    required String storeId,
    required String storeShareElementId,
    required String brandId,
    required String teamMemberId,
    required String visitId,
    required String count,
    File? storeShareImage,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.storeShareAdd);
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({'Accept': 'application/json'});
      request.fields['_token'] = token;
      request.fields['StoreID'] = storeId;
      request.fields['StoreShareElementID'] = storeShareElementId;
      request.fields['BrandID'] = brandId;
      request.fields['TeamMemberID'] = teamMemberId;
      request.fields['VisitID'] = visitId;
      request.fields['Count'] = count;

      if (storeShareImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'StoreShareImage',
            storeShareImage.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Error during storeShareAdd: $e');
      return null;
    }
  }
}
