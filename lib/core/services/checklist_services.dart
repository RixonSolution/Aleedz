import 'dart:convert';
import 'dart:io';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ChecklistServices {
  Future<Map<String, dynamic>?> getChecklistType({
    required String token,
    required String storeId,
    required String teamMemberId,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);

    final url = Uri.parse(
      '${ApiConstants.checklist}?_token=$encodedToken&StoreID=$encodedStoreId&TeamMemberID=$encodedTeamMemberId',
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

  Future<Map<String, dynamic>?> getChecklistSubmitList({
    required String token,
    required String storeId,
    required String teamMemberId,
    required String checklistCateId,
    required String visiteId,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedCheckListCateId = Uri.encodeComponent(checklistCateId);
    final encodedVisiteId = Uri.encodeComponent(visiteId);

    final url = Uri.parse(
      '${ApiConstants.checkListSubmitView}?_token=$encodedToken&StoreID=$encodedStoreId&TeamMemberID=$encodedTeamMemberId&CheckListCategoryID=$encodedCheckListCateId&VisitID=$encodedVisiteId',
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

  Future<Map<String, dynamic>?> checklistSubmit({
    required String token,
    required String checklistAuditId,
    required String checklistId,
    required String storeId,
    required String checklistStatus,
    required String teamMemberId,
    required String visitId,
    required String description,

    File? checkInImgFile,
  }) async {
    try {
      // Compress image before upload
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

      File? compressedImage;
      if (checkInImgFile != null) {
        compressedImage = await compressImage(checkInImgFile);
      }
      final url = Uri.parse(
        '${ApiConstants.checklistSubmit}?'
        '_token=${Uri.encodeComponent(token)}&'
        'Checklist_Audit_ID=${Uri.encodeComponent(checklistAuditId)}&'
        'CheckListID=${Uri.encodeComponent(checklistId)}&'
        'StoreID=${Uri.encodeComponent(storeId)}&'
        'CheckListStatus=${Uri.encodeComponent(checklistStatus)}&'
        'TeamMemberID=${Uri.encodeComponent(teamMemberId)}&'
        'VisitID=${Uri.encodeComponent(visitId)}&'
        'Checklist_Description=${Uri.encodeComponent(description)}',
      );

      var request = http.MultipartRequest('POST', url);

      if (compressedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'CheckList_Img',
            compressedImage.path,
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
}
