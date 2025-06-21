import 'dart:io';
import 'package:aleedz/core/controllers/checklist_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/checklist_entry.dart';
import 'package:aleedz/models/checklist_model.dart';
import 'package:aleedz/models/checklist_submit_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final checklistModelProvider = ChangeNotifierProvider<checklistViewModel>((
  ref,
) {
  return checklistViewModel();
});

class checklistViewModel extends ChangeNotifier {
  final ChecklistController _checkController = ChecklistController();

  UserModel? user;
  List<ChecklistModel> checkList = [];
  List<ChecklistSubmitModel> checkListSubmitView = [];

  List<ChecklistEntry> checklistEntries = [];

  File? leftImage;
  File? rightImage;
  final ImagePicker picker = ImagePicker();
  bool loader = false;

  Future loadUser() async {
    final store = StoreLocalData();

    user = await store.getUserFromPrefs();
    notifyListeners();

    if (user != null) {
      print('Welcome ${user!.teamMemberName}');
    } else {
      print('No user found in prefs');
    }
  }

  Future<String?> pickFromCamera(String direction) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      // Save or process the image if needed
      return image.path;
    }
    return null;
  }

  Future<String?> pickFromGallery(String direction) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Save or process the image if needed
      return image.path;
    }
    return null;
  }

  Future<void> getCheckListType({required String storeId}) async {
    checkList = [];
    notifyListeners();

    final response = await _checkController.checklistType(
      token: user?.apiToken ?? '',
      storeId: storeId,
      teamMemberId: user?.teamMemberID.toString() ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      checkList = data.map((e) => ChecklistModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future<void> getCheckSubmitList({
    required String storeId,
    required String checkListCateId,
    required String visitedId,
  }) async {
    loader = true;
    checkListSubmitView = [];
    checklistEntries = [];
    notifyListeners();

    final response = await _checkController.checklistSubmitList(
      token: user?.apiToken ?? '',
      storeId: storeId,
      teamMemberId: user?.teamMemberID.toString() ?? '',
      checklistCateId: checkListCateId,
      visiteId: visitedId,
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      checkListSubmitView =
          data.map((e) => ChecklistSubmitModel.fromJson(e)).toList();
      loader = false;
      notifyListeners();
    } else {
      loader = false;
      notifyListeners();
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  void addOrUpdateChecklistEntry(ChecklistEntry newEntry) {
    final index = checklistEntries.indexWhere(
      (e) => e.checkListID == newEntry.checkListID,
    );

    if (index != -1) {
      final existingEntry = checklistEntries[index];
      print('exist ${checklistEntries[index].description}');

      // Merge values: new values overwrite old; old values are preserved if null
      final mergedEntry = existingEntry.copyWith(
        token: newEntry.token.isNotEmpty ? newEntry.token : null,
        checklistAuditID:
            newEntry.checklistAuditID ?? existingEntry.checklistAuditID,
        storeID: newEntry.storeID.isNotEmpty ? newEntry.storeID : null,
        checkListStatus:
            newEntry.checkListStatus ?? existingEntry.checkListStatus,
        teamMemberID:
            newEntry.teamMemberID.isNotEmpty ? newEntry.teamMemberID : null,
        visitID: newEntry.visitID.isNotEmpty ? newEntry.visitID : null,
        imagePath: newEntry.imagePath ?? existingEntry.imagePath,
        description: newEntry.description ?? existingEntry.description,
      );

      checklistEntries[index] = mergedEntry;
      notifyListeners();
    } else {
      print('new ${newEntry}');

      checklistEntries.add(newEntry);
      notifyListeners();
    }
  }

  String? getChecklistEntryDescription(String checkListID) {
    return checklistEntries
        .firstWhere(
          (e) => e.checkListID == checkListID,
          orElse:
              () => ChecklistEntry(
                token: '',
                checklistAuditID: '0',
                checkListID: checkListID,
                storeID: '',
                teamMemberID: '',
                visitID: '',
              ),
        )
        .description;
  }

  Future<void> checklistSubmit({
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
    notifyListeners();

    final response = await _checkController.checklistSubmit(
      token: user?.apiToken ?? '',
      storeId: storeId,
      teamMemberId: user?.teamMemberID.toString() ?? '',
      checklistAuditId: checklistAuditId,
      checklistId: checklistId,
      checklistStatus: checklistStatus,
      visitId: visitId,
      description: description,
      checkInImgFile: checkInImgFile,
    );

    if (response != null && response["status"] == 200) {
      print('submitted');
      notifyListeners();
    } else {
      loader = false;
      notifyListeners();
      debugPrint("Checklist list Error: ${response?['data']}");
    }
  }

  Future loadActivity(String storeId) async {
    checkList = [];
    loader = true;
    notifyListeners();
    await loadUser();
    await getCheckListType(storeId: storeId);
    loader = false;
    notifyListeners();
  }
}
