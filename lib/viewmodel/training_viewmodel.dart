import 'dart:io';

import 'package:aleedz/core/controllers/checklist_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/activity_type_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final trainingModelProvider = ChangeNotifierProvider<TrainingViewModel>((ref) {
  return TrainingViewModel();
});

class TrainingViewModel extends ChangeNotifier {
  final ChecklistController _checkController = ChecklistController();

  UserModel? user;
  List<ActivityModelType> activityType = [];
  final ImagePicker picker = ImagePicker();

  List<File> rightImages = []; // instead of File? rightImage;

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

  void pickFromGallerys(String direction) async {
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      final files = images.map((img) => File(img.path)).toList();
      if (direction == 'right') {
        rightImages.addAll(files);
      }
      notifyListeners();
    }
  }

  void pickFromCameras(String direction) async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      if (direction == 'right') {
        rightImages.add(File(image.path));

        notifyListeners();
      }
    }
  }

  Future<void> getActivityType({required String storeId}) async {
    activityType = [];
    notifyListeners();

    final response = await _checkController.checklistType(
      token: user?.apiToken ?? '',
      storeId: storeId,
      teamMemberId: user?.teamMemberID.toString() ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      activityType = data.map((e) => ActivityModelType.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future loadActivity(String storeId) async {
    activityType = [];
    loader = true;
    notifyListeners();
    await loadUser();
    await getActivityType(storeId: storeId);
    loader = false;
    notifyListeners();
  }
}
