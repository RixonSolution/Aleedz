import 'dart:io';

import 'package:aleedz/core/services/checklist_services.dart';

class ChecklistController {
  final ChecklistServices _apiService = ChecklistServices();

  Future<Map<String, dynamic>?> checklistType({
    required String token,
    required String storeId,
    required String teamMemberId,
  }) async {
    return await _apiService.getChecklistType(
      token: token,
      storeId: storeId,
      teamMemberId: teamMemberId,
    );
  }

  Future<Map<String, dynamic>?> checklistSubmitList({
    required String token,
    required String storeId,
    required String teamMemberId,
    required String checklistCateId,
    required String visiteId,
  }) async {
    return await _apiService.getChecklistSubmitList(
      token: token,
      storeId: storeId,
      teamMemberId: teamMemberId,
      checklistCateId: checklistCateId,
      visiteId: visiteId,
    );
  }

  Future<Map<String, dynamic>?> checklistSubmit({
    required String token,
    required String checklistAuditId,
    required String checklistId,
    required String storeId,
    required String checklistStatus,
    required String teamMemberId,
    required String visitId,
    File? checkInImgFile,
  }) async {
    return await _apiService.checklistSubmit(
      token: token,
      storeId: storeId,
      teamMemberId: teamMemberId,
      checklistAuditId: checklistAuditId,
      checklistId: checklistId,
      checklistStatus: checklistStatus,
      visitId: visitId,
      checkInImgFile: checkInImgFile,
    );
  }
}
