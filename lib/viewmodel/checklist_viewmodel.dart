import 'dart:io';

import 'package:aleedz/core/controllers/checklist_controller.dart';
import 'package:aleedz/core/controllers/price_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/activity_type_model.dart';
import 'package:aleedz/models/brand_list_model.dart';
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
  List<ActivityModelType> activityType = [];
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

  Future<void> getActivityType() async {
    activityType = [];
    notifyListeners();

    final response = await _checkController.activityType(
      token: user?.apiToken ?? '',
      divisionId: '1',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      activityType = data.map((e) => ActivityModelType.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future loadActivity() async {
    activityType = [];
    loader = true;
    notifyListeners();
    await loadUser();
    await getActivityType();
    loader = false;
    notifyListeners();
  }
}
