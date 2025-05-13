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

  Future<Map<String, dynamic>?> checkDisplayMaster({
    required String teamMemberId,
    required String storeId,
    required String productCategoryId,
    required String token,
  }) async {
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedCategoryId = Uri.encodeComponent(productCategoryId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.checkMasterDisplay}?TeamMemberID=$encodedTeamMemberId&StoreID=$encodedStoreId&ProductCategoryID=$encodedCategoryId&_token=$encodedToken',
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
      final url = Uri.parse(ApiConstants.checkDisplayAddMedia);
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({'Accept': 'application/json'});
      print(token);

      request.fields['_token'] = token;
      request.fields['ProductCategoryID'] = productCategoryId;
      request.fields['StoreID'] = storeID;
      request.fields['DisplayCheckRemarks'] = displayCheckMark;
      request.fields['TeamMemberID'] = teamMemberId;

      if (checkInImgFile1 != null) {
        print("Image 1 path: ${checkInImgFile1.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'DisplayCheckImage1',
            checkInImgFile1.path,
          ),
        );
      }

      if (checkInImgFile2 != null) {
        print("Image 2 path: ${checkInImgFile2.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'DisplayCheckImage2',
            checkInImgFile2.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Error during auditMediaSubmit: $e');
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

  Future<Map<String, dynamic>?> getPictureDropDown({
    required String token,
  }) async {
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.pictureDropDown}?_token=$encodedToken',
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

  Future<Map<String, dynamic>?> submitDisplayPicture({
    required String token,
    required String storeId,
    required String teamMemberId,
    required String brandId,
    required String pictureElementId,
    required String remarks,
    required String pictureId,
    File? elementImg,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.submitDisplayPicture);

      var request = http.MultipartRequest('POST', url);

      // Add all fields as multipart fields (not as query parameters)
      request.fields['_token'] = token;
      request.fields['StoreID'] = storeId;
      request.fields['TeamMemberID'] = teamMemberId;
      request.fields['BrandID'] = brandId;
      request.fields['PictureElementID'] = pictureElementId;
      request.fields['Remarks'] = remarks;
      request.fields['PictureID'] = pictureId;

      // Add image file if available
      if (elementImg != null) {
        request.files.add(
          await http.MultipartFile.fromPath('ElementImg', elementImg.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Error during check-in: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> viewPictureApi({
    required String token,
    required String storeId,
    required String brandId,
    required String elementId,
  }) async {
    final url = Uri.parse(
      '${ApiConstants.pictureApiView}?_token=${Uri.encodeComponent(token)}&StoreID=${Uri.encodeComponent(storeId)}&BrandID=${Uri.encodeComponent(brandId)}&ElementID=${Uri.encodeComponent(elementId)}',
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

  Future<Map<String, dynamic>?> deleteDisplayPicture({
    required String token,
    required String storeId,
    required String pictureId,
    required String pictureName,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedPictureId = Uri.encodeComponent(pictureId);
    final encodedPictureName = Uri.encodeComponent(pictureName);

    final url = Uri.parse(
      '${ApiConstants.deleteDisplayPicture}?_token=$encodedToken&StoreID=$encodedStoreId&PictureID=$encodedPictureId&PictureName=$encodedPictureName',
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
