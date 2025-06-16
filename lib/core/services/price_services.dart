import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class PriceServices {
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

  Future<Map<String, dynamic>?> pricePromotion({
    required String storeId,
    required String brandId,
    required String token,
  }) async {
    final encodedStoreId = Uri.encodeComponent('5');
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.pricePromotion}?_token=$encodedToken&StoreID=$encodedStoreId&BrandID=$encodedBrandId',
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

  Future<Map<String, dynamic>?> priceList({
    required String token,
    required String brandId,
    required String productCategoryId,
    required String storeId,
    required String visiteId,
  }) async {
    final encodedStoreId = Uri.encodeComponent('5');
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedToken = Uri.encodeComponent(token);
    final encodedVisitStatus = Uri.encodeComponent(visiteId);
    final encodedProductCategoryId = Uri.encodeComponent(productCategoryId);

    final url = Uri.parse(
      '${ApiConstants.priceList}?_token=$encodedToken&BrandID=$encodedBrandId&ProductCategoryID=$encodedProductCategoryId&StoreID=$encodedStoreId&VisitID=$encodedVisitStatus',
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
