import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/models/product_transfer_model.dart';
import 'package:http/http.dart' as http;

class TransferServices {
  Future<Map<String, dynamic>?> getTtransferList({
    required String teamMemberId,
    required String visiteId,
    required String chanelId,
    required String searchKeyWord,
    required String chanelTypeId,
    required String token,
  }) async {
    final encodedTeamId = Uri.encodeComponent(teamMemberId);
    final encodedVisitId = Uri.encodeComponent(visiteId);

    final encodedChanelId = Uri.encodeComponent(chanelId);
    final encodedSearchKeyword = Uri.encodeComponent(searchKeyWord);
    final encodedChanelTypeId = Uri.encodeComponent(chanelTypeId);

    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.transferView}?TeamMemberID=$encodedTeamId&VisitID=$encodedVisitId&ChannelID=$encodedChanelId&SearchKeyWord=$encodedSearchKeyword&ChannelTypeID=$encodedChanelTypeId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> getTransferDropDown({
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

  Future<Map<String, dynamic>?> transferBrandView({
    required String storeId,
    required String brandId,
    required String visiteId,
    required String token,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedVisitId = Uri.encodeComponent(visiteId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.transferBrandView}?StoreID=$encodedStoreId&BrandID=$encodedBrandId&VisitID=$encodedVisitId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> transferCheckBrand({
    required String storeId,
    required String brandId,
    required String visiteId,
    required String token,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedVisiteId = Uri.encodeComponent(visiteId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.transferBrandView}?StoreID=$encodedStoreId&BrandID=$encodedBrandId&VisitID=$encodedVisiteId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> transferSubmitList({
    required String storeId,
    required String categoryId,
    required String visiteStatus,

    required String token,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedCategoryId = Uri.encodeComponent(categoryId);
    final encodedVisiteStatus = Uri.encodeComponent(visiteStatus);

    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.trasferSubmitList}?StoreID=$encodedStoreId&VisitID=$encodedVisiteStatus&ProductCategoryID=$encodedCategoryId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> transferSubmit({
    required List<ProductTransferModel> transferModelList,
  }) async {
    final List<dynamic> responses = [];

    for (var transferModel in transferModelList) {
      final queryParams = {
        '_token': transferModel.token,
        'TransferID': transferModel.transferId.toString(),
        'ProductID': transferModel.productId.toString(),
        'isTransfer': transferModel.isTransfer.toString(),
        'TransferCount': transferModel.transferCount.toString(),
        'TeamMemberID': transferModel.teamMemberId.toString(),
        'StoreID': transferModel.storeId.toString(),
        'VisitID': transferModel.visitId.toString(),
      };

      final uri = Uri.parse(
        ApiConstants.addProductTrasfer,
      ).replace(queryParameters: queryParams);

      try {
        final response = await http.get(
          uri,
          headers: {'Accept': 'application/json'},
        );

        final data = json.decode(response.body);
        responses.add({
          'productId': transferModel.productId,
          'status': response.statusCode,
          'data': data,
        });
      } catch (e) {
        responses.add({
          'productId': transferModel.productId,
          'status': 500,
          'error': e.toString(),
        });
      }
    }

    return {'status': 200, 'results': responses};
  }
}
