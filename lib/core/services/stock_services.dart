import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class StockServices {
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

  Future<Map<String, dynamic>?> stockSummary({
    required String storeId,
    required String brandId,
    required String token,
    required String visitId,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedToken = Uri.encodeComponent(token);
    final encodedVisiId = Uri.encodeComponent(visitId);

    final url = Uri.parse(
      '${ApiConstants.stockSummary}?VisitID=$encodedVisiId&StoreID=$encodedStoreId&BrandID=$encodedBrandId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> stockView({
    required String storeId,
    required String brandId,
    required String token,
    required String teamMemberId,
    required String productCategoryId,
    required String inputTypeId,
    required String visitId,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedToken = Uri.encodeComponent(token);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedInputTypeId = Uri.encodeComponent(inputTypeId);

    final encodedProductCategoryId = Uri.encodeComponent(productCategoryId);

    final encodedVisiId = Uri.encodeComponent(visitId);

    final url = Uri.parse(
      '${ApiConstants.stockView}?VisitID=$encodedVisiId&StoreID=$encodedStoreId&BrandID=$encodedBrandId&ProductCategoryID=$encodedProductCategoryId&inputTypeID=$encodedInputTypeId&TeamMemberID=$encodedTeamMemberId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> stockAdd({
    required String productId,
    required String storeId,
    required String visitId,
    required String teamMemberId,
    required String stock,
    required String token,
  }) async {
    final encodedProductId = Uri.encodeComponent(productId);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedVisitId = Uri.encodeComponent(visitId);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedStock = Uri.encodeComponent(stock);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.stockAdd}?ProductID=$encodedProductId&VisitID=$encodedVisitId&StoreID=$encodedStoreId&TeamMemberID=$encodedTeamMemberId&Stock=$encodedStock&_token=$encodedToken',
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
