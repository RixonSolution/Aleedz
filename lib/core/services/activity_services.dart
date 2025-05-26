import 'dart:convert';
import 'dart:io';

import 'package:aleedz/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart'; //
import 'package:path/path.dart' as path;

class ActivityServices {
  Future<Map<String, dynamic>?> getActivityType({
    required String token,
    required String divisionId,
  }) async {
    final encodedDivisionId = Uri.encodeComponent(divisionId);

    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.activityTypeList}?DivisionID=$encodedDivisionId&_Token=$encodedToken',
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

  Future<Map<String, dynamic>?> getActivityCategory({
    required String token,
    required String divisionId,
    required String categoryTypeId,
  }) async {
    final encodedDivisionId = Uri.encodeComponent(divisionId);
    final encodedCategoryTypeId = Uri.encodeComponent(categoryTypeId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.activityCategoryId}?DivisionID=$encodedDivisionId&ActivityTypeID=$encodedCategoryTypeId&_Token=$encodedToken',
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

  Future<Map<String, dynamic>?> getMarketActivity({
    required String storeId,
    required String activityCategoryId,
    required String activityTypeId,
    required String brandId,
    required String teamMemberId,
    required String token,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedActivityCategoryId = Uri.encodeComponent(activityCategoryId);
    final encodedActivityTypeId = Uri.encodeComponent(activityTypeId);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.activityList}?StoreID=$encodedStoreId&ActivityCategoryID=$encodedActivityCategoryId&ActivityTypeID=$encodedActivityTypeId&BrandID=$encodedBrandId&TeamMemberID=$encodedTeamMemberId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> marketActivityAdd({
    required String teamMemberId,
    required String token,
    required String storeID,
    required String activityTypeId,
    required String activityCategoryId,
    required String brandId,
    required String activityDescription,
    required String statusId,
    required String quantity,
    required String deployementReason,

    List<File>? beforeActivityPictures, // Updated parameter
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

      final url = Uri.parse(ApiConstants.merketActivitySubmit);
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({'Accept': 'application/json'});
      print(token);
      request.fields['TeamMemberID'] = teamMemberId;
      request.fields['_token'] = token;
      request.fields['StoreID'] = storeID;
      request.fields['ActivityTypeID'] = activityTypeId;
      request.fields['ActivityCategoryID'] = activityCategoryId;
      request.fields['BrandID'] = brandId;
      request.fields['ActivityDescription'] = activityDescription;
      request.fields['StatusID'] = statusId;
      request.fields['Quantity'] = quantity;
      request.fields['DeploymentReasonID'] = deployementReason;

      if (beforeActivityPictures != null && beforeActivityPictures.isNotEmpty) {
        for (int i = 0; i < beforeActivityPictures.length && i < 4; i++) {
          final compressedImage = await compressImage(
            beforeActivityPictures[i],
          );

          if (compressedImage != null) {
            print(
              "Compressed BeforeActivityPicture $i path: ${compressedImage.path}",
            );
            request.files.add(
              await http.MultipartFile.fromPath(
                'BeforeActivityPicture',
                compressedImage.path,
              ),
            );
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Error during marketActivityAdd: $e');
      return null;
    }
  }
}
