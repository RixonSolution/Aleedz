import 'dart:io';
import 'package:aleedz/core/services/user_trainig_services.dart';

class UserTrainingController {
  final UserTrainingServices _apiService = UserTrainingServices();

  Future<Map<String, dynamic>?> trainingList({
    required String token,
    required String storeId,
    required String teamMemberId,
  }) async {
    return await _apiService.trainingList(
      token: token,
      storeId: storeId,
      teamMemberId: teamMemberId,
    );
  }

  Future<Map<String, dynamic>?> promoterList({
    required String token,
    required String storeId,
  }) async {
    return await _apiService.trainingType(token: token, storeId: storeId);
  }

  Future<Map<String, dynamic>?> trainingModelList({
    required String token,
  }) async {
    return await _apiService.trainingModelList(token: token);
  }

  Future<Map<String, dynamic>?> userTrainingType({
    required String token,
  }) async {
    return await _apiService.userTrainingType(token: token);
  }

  Future<Map<String, dynamic>?> coverageList({
    required int teamMemberId,
    required int chanelId,
    required String searchKeyWord,
    required String chanelTypeId,
    required String token,
  }) async {
    return await _apiService.getCoverageList(
      teamMemberId: teamMemberId,
      chanelId: chanelId,
      searchKeyWord: searchKeyWord,
      chanelTypeId: chanelTypeId,
      token: token,
    );
  }

  Future<Map<String, dynamic>?> trainingSubmit({
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
    return await _apiService.trainigSubmit(
      token: token,
      storeId: storeId,
      description: description,
      teamMemberId: teamMemberId,
      trainingDateTime: trainingDateTime,
      startTime: startTime,
      endTime: endTime,
      attendeseTypeId: attendeseTypeId,
      trainingTypeId: trainingTypeId,
      trainingTitle: trainingTitle,
      noOfAttendees: noOfAttendees,
      attendees: attendees,
      store: store,
      trainingModel: trainingModel,
      files: files,
    );
  }
}
