import 'dart:convert';
import 'dart:io';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class UserTrainingServices {
  Future<Map<String, dynamic>?> trainingList({
    required String token,
    required String storeId,
    required String teamMemberId,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedTeamMemberId = Uri.encodeComponent(teamMemberId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.trainingList}?StoreID=$encodedStoreId&TeamMemberID=$encodedTeamMemberId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> trainingType({
    required String token,
    required String storeId,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.promoterList}?StoreID=$encodedStoreId&_token=$encodedToken',
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

  Future<Map<String, dynamic>?> trainingModelList({
    required String token,
  }) async {
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse('${ApiConstants.trainingModel}?_token=$encodedToken');

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

  Future<Map<String, dynamic>?> trainigSubmit({
    required String token,
    required String storeId,
    required String description,
    required String teamMemberId,
    required String trainingDateTime,
    required String startTime,
    required String endTime,
    required String attendeseTypeId,
    required String trainingTypeId,
    required String trainingTitle,
    required String noOfAttendees,
    required String attendees,
    required String store,
    required String trainingModel,
    List<File>? files,
  }) async {
    try {
      // Compress a single image
      Future<File?> compressImage(File file) async {
        final dir = await getTemporaryDirectory();
        final targetPath = path.join(
          dir.path,
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}',
        );

        final result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: 30,
        );

        return result != null ? File(result.path) : null;
      }

      // ✅ Compress all images in the list
      List<File> compressedFiles = [];
      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          if (file.path.isNotEmpty) {
            var compressed = await compressImage(file);
            if (compressed != null) {
              compressedFiles.add(compressed);
            }
          }
        }
      }

      final url = Uri.parse(
        '${ApiConstants.trainingSubmit}?'
        '_token=${Uri.encodeComponent(token)}&'
        'StoreID=${Uri.encodeComponent(storeId)}&'
        'Description=${Uri.encodeComponent(description)}&'
        'TeamMemberID=${Uri.encodeComponent(teamMemberId)}&'
        'TrainingDateTime=${Uri.encodeComponent(trainingDateTime)}&'
        'StartTime=${Uri.encodeComponent(startTime)}&'
        'EndTime=${Uri.encodeComponent(endTime)}&'
        'AttendeseTypeID=${Uri.encodeComponent(attendeseTypeId)}&'
        'TrainingTypeID=${Uri.encodeComponent(trainingTypeId)}&'
        'TrainingTitle=${Uri.encodeComponent(trainingTitle)}&'
        'NoOfAttendees=${Uri.encodeComponent(noOfAttendees)}&'
        'Attendees=${Uri.encodeComponent(attendees)}&'
        'Stores=${Uri.encodeComponent(store)}&'
        'TrainingModel=${Uri.encodeComponent(trainingModel)}',
      );

      var request = http.MultipartRequest('POST', url);

      // ✅ Attach all compressed images
      for (var file in compressedFiles) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Error during training submit: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> userTrainingType({
    required String token,
  }) async {
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse('${ApiConstants.trainingType}?_token=$encodedToken');

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

  Future<Map<String, dynamic>?> getCoverageList({
    required int teamMemberId,
    required int chanelId,
    required String searchKeyWord,
    required String chanelTypeId,
    required String token,
  }) async {
    final encodedTeamId = Uri.encodeComponent(teamMemberId.toString());
    final encodedChanelId = Uri.encodeComponent(chanelId.toString());
    final encodedSearchKeyword = Uri.encodeComponent(searchKeyWord);
    final encodedChanelTypeId = Uri.encodeComponent(chanelTypeId);

    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse(
      '${ApiConstants.coverageList}?TeamMemberID=$encodedTeamId&ChannelID=$encodedChanelId&SearchKeyWord=$encodedSearchKeyword&ChannelTypeID=$encodedChanelTypeId&_token=$encodedToken ',
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
