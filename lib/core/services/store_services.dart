import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart'; //
import 'package:path/path.dart' as path;

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
      // Function to compress image
      Future<File?> compressImage(File file) async {
        final dir = await getTemporaryDirectory();
        final targetPath = path.join(
          dir.path,
          '${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        final result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: 30,
        );

        return result != null ? File(result.path) : null;
      }

      // Compress if image is not null
      File? compressedImage1 =
          checkInImgFile1 != null ? await compressImage(checkInImgFile1) : null;
      File? compressedImage2 =
          checkInImgFile2 != null ? await compressImage(checkInImgFile2) : null;

      final url = Uri.parse(ApiConstants.checkDisplayAddMedia);
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({'Accept': 'application/json'});
      print(token);

      request.fields['_token'] = token;
      request.fields['ProductCategoryID'] = productCategoryId;
      request.fields['StoreID'] = storeID;
      request.fields['DisplayCheckRemarks'] = displayCheckMark;
      request.fields['TeamMemberID'] = teamMemberId;

      if (compressedImage1 != null) {
        print("Compressed Image 1 path: ${compressedImage1.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'DisplayCheckImage1',
            compressedImage1.path,
          ),
        );
      }

      if (compressedImage2 != null) {
        print("Compressed Image 2 path: ${compressedImage2.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'DisplayCheckImage2',
            compressedImage2.path,
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

  Future<Map<String, dynamic>?> getPermissionRequest({
    required String teamMemberId,
    required String token,
  }) async {
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedToken = Uri.encodeComponent(token);
    final url = Uri.parse(
      '${ApiConstants.requestPermission}?TeamMemberID=$encodedTeamMemberId&_token=$encodedToken',
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
      // Compression function
      Future<File?> compressImage(File file) async {
        final dir = await getTemporaryDirectory();
        final targetPath = path.join(
          dir.path,
          '${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        final result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: 30,
        );

        return result != null ? File(result.path) : null;
      }

      // Compress image before upload
      File? compressedElementImg =
          elementImg != null ? await compressImage(elementImg) : null;

      final url = Uri.parse(ApiConstants.submitDisplayPicture);
      var request = http.MultipartRequest('POST', url);

      request.fields['_token'] = token;
      request.fields['StoreID'] = storeId;
      request.fields['TeamMemberID'] = teamMemberId;
      request.fields['BrandID'] = brandId;
      request.fields['PictureElementID'] = pictureElementId;
      request.fields['Remarks'] = remarks;
      request.fields['PictureID'] = pictureId;

      if (compressedElementImg != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'ElementImg',
            compressedElementImg.path,
          ),
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

  Future<File?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(
      dir.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
    );

    // ✅ Convert XFile? to File?
    return result != null ? File(result.path) : null;
  }
}
