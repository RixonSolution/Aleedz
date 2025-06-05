import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class SaleServices {
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

  Future<Map<String, dynamic>?> getProductCategory({
    required String token,
    required String brandId,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedBrandId = Uri.encodeComponent(brandId);

    final url = Uri.parse(
      '${ApiConstants.getSaleProductCategory}?_token=$encodedToken&BrandID=$encodedBrandId',
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

  Future<Map<String, dynamic>?> getModelSearchDP({
    required String token,
    required String brandId,
    required String productCategoryId,
    required String storeId,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedProductCateId = Uri.encodeComponent(productCategoryId);
    final encodedStoreId = Uri.encodeComponent(storeId);

    final url = Uri.parse(
      '${ApiConstants.getModelSearch}?_token=$encodedToken&BrandID=$encodedBrandId&ProductCategoryID=$encodedProductCateId&StoreID=$encodedStoreId',
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

  Future<Map<String, dynamic>?> submitSale({
    required String token,
    required String productCategoryId,
    required String storeId,
    required String saleCount,
    required String salePrice,
    required String teamMemberId,
    required String saleDate,
    required String saleType,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedProductCateId = Uri.encodeComponent(productCategoryId);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedSaleCount = Uri.encodeComponent(saleCount);
    final encodedSalePrice = Uri.encodeComponent(salePrice);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedSaleDate = Uri.encodeComponent(saleDate);
    final encodedSaleType = Uri.encodeComponent(saleType);

    final url = Uri.parse(
      '${ApiConstants.addSale}?_token=$encodedToken&ProductID=$encodedProductCateId&StoreID=$encodedStoreId&SaleCount=$encodedSaleCount&SalePrice=$encodedSalePrice&TeamMemberID=$encodedTeamMemberId&SaleDate=$encodedSaleDate&SaleType=$encodedSaleType',
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

  Future<Map<String, dynamic>?> saleView({
    required String token,
    required String storeId,
    required String saleDate,
    required String teamMemberId,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedSaleDate = Uri.encodeComponent(saleDate);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);

    final url = Uri.parse(
      '${ApiConstants.viewSale}?_token=$encodedToken&StoreID=$encodedStoreId&SaleDate=$encodedSaleDate&TeamMemberID=$encodedTeamMemberId',
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

  Future<Map<String, dynamic>?> deleteSale({
    required String token,
    required String storeId,
    required String saleId,
    required String teamMemberId,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedSaleId = Uri.encodeComponent(saleId);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);

    final url = Uri.parse(
      '${ApiConstants.removeSale}?SaleID=$encodedSaleId&StoreID=$encodedStoreId&TeamMemberID=$encodedTeamMemberId&_token=$encodedToken',
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
