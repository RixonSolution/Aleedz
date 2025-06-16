import 'dart:io';
import 'package:aleedz/core/controllers/checklist_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
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

  Future<void> pickFromCamera(String direction) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      if (direction == 'left') {
        leftImage = File(pickedFile.path);
        notifyListeners();
      } else {
        rightImage = File(pickedFile.path);
        notifyListeners();
      }
    }
  }

  Future<void> pickFromGallery(String direction) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (direction == 'left') {
        leftImage = File(pickedFile.path);
        notifyListeners();
      } else {
        rightImage = File(pickedFile.path);
        notifyListeners();
      }
    }
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
