import 'dart:convert';
import 'dart:io';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic>? _decodeJsonResponse(
  http.Response response,
  String label,
) {
  final body = response.body.trimLeft();
  if (body.isEmpty) {
    print('$label returned an empty response (${response.statusCode})');
    return null;
  }

  if (body.startsWith('<')) {
    final preview = body.length > 200 ? body.substring(0, 200) : body;
    print('$label returned non-JSON (${response.statusCode}): $preview');
    return null;
  }

  try {
    final data = json.decode(response.body);
    return {"status": response.statusCode, "data": data};
  } catch (e) {
    final preview = body.length > 200 ? body.substring(0, 200) : body;
    print('$label decode error (${response.statusCode}): $e');
    print('$label response preview: $preview');
    return null;
  }
}

class StoreShareServices {
  Future<Map<String, dynamic>?> shelfShareCategorySummary({
    required String token,
    required String storeId,
    required String productCategoryId,
    required String weekNo,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedProductCategoryId = Uri.encodeComponent(productCategoryId);
    final encodedWeekNo = Uri.encodeComponent(weekNo);

    final url = Uri.parse(
      '${ApiConstants.shelfShareCategorySummary}?_token=$encodedToken&StoreID=$encodedStoreId&ProductCategoryID=$encodedProductCategoryId&WeekNo=$encodedWeekNo',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      return _decodeJsonResponse(response, 'shelfShareCategorySummary');
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> shelfShareCategoryDropdown({
    required String token,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final url = Uri.parse(
      '${ApiConstants.shelfShareCategoryDropdown}?_token=$encodedToken',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      return _decodeJsonResponse(response, 'shelfShareCategoryDropdown');
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> shelfShareAllBrands({
    required String token,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final url = Uri.parse(
      '${ApiConstants.shelfShareAllBrands}?_token=$encodedToken',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      return _decodeJsonResponse(response, 'shelfShareAllBrands');
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> shelfShareBrandSummaryByCategory({
    required String token,
    required String storeId,
    required String productCategoryId,
    required String brandId,
    required String weekNo,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedProductCategoryId = Uri.encodeComponent(productCategoryId);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedWeekNo = Uri.encodeComponent(weekNo);

    final url = Uri.parse(
      '${ApiConstants.shelfShareBrandSummaryByCategory}?_token=$encodedToken&StoreID=$encodedStoreId&ProductCategoryID=$encodedProductCategoryId&BrandID=$encodedBrandId&WeekNo=$encodedWeekNo',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      return _decodeJsonResponse(response, 'shelfShareBrandSummaryByCategory');
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> shelfShareBrandDisplayLocation({
    required String token,
    required String shelfShareId,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedShelfShareId = Uri.encodeComponent(shelfShareId);
    final url = Uri.parse(
      '${ApiConstants.shelfShareBrandDisplayLocation}?_token=$encodedToken&ShelfShareID=$encodedShelfShareId',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      return _decodeJsonResponse(response, 'shelfShareBrandDisplayLocation');
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> shelfShareAdd({
    required String token,
    required String shelfShareId,
    required String storeId,
    required String productCategoryId,
    required String weekNo,
    required String year,
    required String brandId,
    required String facingCount,
    required String stockCount,
    required String teamMemberId,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedShelfShareId = Uri.encodeComponent(shelfShareId);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedProductCategoryId = Uri.encodeComponent(productCategoryId);
    final encodedWeekNo = Uri.encodeComponent(weekNo);
    final encodedYear = Uri.encodeComponent(year);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedFacing = Uri.encodeComponent(facingCount);
    final encodedStock = Uri.encodeComponent(stockCount);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);

    final url = Uri.parse(
      '${ApiConstants.shelfShareAdd}?_token=$encodedToken&ShelfShareID=$encodedShelfShareId&StoreID=$encodedStoreId&ProductCategoryID=$encodedProductCategoryId&WeekNo=$encodedWeekNo&Year=$encodedYear&BrandID=$encodedBrandId&FacingCount=$encodedFacing&StockCount=$encodedStock&TeamMemberID=$encodedTeamMemberId',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      return _decodeJsonResponse(response, 'shelfShareAdd');
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> shelfShareDisplayLocationAdd({
    required String token,
    required String shelfShareDisplayId,
    required String shelfShareId,
    required String shelfShareDisplayLocationId,
    required String isShelfShareDisplay,
    required String teamMemberId,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedShelfShareDisplayId = Uri.encodeComponent(shelfShareDisplayId);
    final encodedShelfShareId = Uri.encodeComponent(shelfShareId);
    final encodedShelfShareDisplayLocationId = Uri.encodeComponent(
      shelfShareDisplayLocationId,
    );
    final encodedIsShelfShareDisplay = Uri.encodeComponent(isShelfShareDisplay);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);

    final url = Uri.parse(
      '${ApiConstants.shelfShareDisplayLocationAdd}?_token=$encodedToken&ShelfShareDisplayID=$encodedShelfShareDisplayId&ShelfShareID=$encodedShelfShareId&ShelfShareDisplayLocationID=$encodedShelfShareDisplayLocationId&IsShelfShareDisplay=$encodedIsShelfShareDisplay&TeamMemberID=$encodedTeamMemberId',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      return _decodeJsonResponse(response, 'shelfShareDisplayLocationAdd');
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

      return _decodeJsonResponse(response, 'brandDropDown');
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
