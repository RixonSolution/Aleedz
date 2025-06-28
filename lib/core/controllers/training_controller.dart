import 'dart:io';

import 'package:aleedz/core/services/training_services.dart';

class TrainingController {
  final TrainingServices _apiService = TrainingServices();

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
    return await _apiService.promoterList(token: token, storeId: storeId);
  }

  Future<Map<String, dynamic>?> trainingModelList({
    required String token,
  }) async {
    return await _apiService.trainingModelList(token: token);
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

    File? file,
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
      file: file,
    );
  }
}
