import 'dart:io';
import 'package:aleedz/core/controllers/training_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/promoter_list_model.dart';
import 'package:aleedz/models/trainig_model.dart';
import 'package:aleedz/models/training_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final trainingModelProvider = ChangeNotifierProvider<TrainingViewModel>((ref) {
  return TrainingViewModel();
});

class TrainingViewModel extends ChangeNotifier {
  final TrainingController _checkController = TrainingController();

  UserModel? user;
  List<TrainingListModel> trainingList = [];
  List<PromoterListModel> promoterList = [];
  List<TraingModel> trainingModel = [];

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
        notifyListeners();
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

  Future<void> getTrainingList({required String storeId}) async {
    trainingList = [];
    notifyListeners();

    final response = await _checkController.trainingList(
      token: user?.apiToken ?? '',
      storeId: storeId,
      teamMemberId: user?.teamMemberID.toString() ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      trainingList = data.map((e) => TrainingListModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("training list Error: ${response?['data']}");
    }
  }

  Future<void> getPromoterList({required String storeId}) async {
    loader = true;
    promoterList = [];
    notifyListeners();

    final response = await _checkController.promoterList(
      token: user?.apiToken ?? '',
      storeId: storeId,
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      promoterList = data.map((e) => PromoterListModel.fromJson(e)).toList();
      loader = false;
      notifyListeners();
    } else {
      loader = false;
      notifyListeners();
      debugPrint("promoter list Error: ${response?['data']}");
    }
  }

  Future<void> getTrainingModelList() async {
    loader = true;
    trainingModel = [];
    rightImages = [];
    notifyListeners();

    final response = await _checkController.trainingModelList(
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      trainingModel = data.map((e) => TraingModel.fromJson(e)).toList();
      loader = false;
      notifyListeners();
    } else {
      loader = false;
      notifyListeners();
      debugPrint("model list Error: ${response?['data']}");
    }
  }

  Future<void> trainingSubmit({
    required String storeId,
    required String description,
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
  }) async {
    loader = true;
    notifyListeners();

    final response = await _checkController.trainingSubmit(
      token: user?.apiToken ?? '',
      storeId: storeId,
      description: description,
      teamMemberId: user?.teamMemberID.toString() ?? '',
      trainingDateTime: trainingDateTime,
      startTime: startTime,
      endTime: endTime,
      attendeseTypeId: attendeseTypeId,
      trainingTypeId: trainingTypeId,
      trainingTitle: trainingTitle,
      noOfAttendees: noOfAttendees,
      // attendees: attendees,
      attendees: '0:GuestAli:GUEST001,0:Adel:GUEST002',
      store: store,
      trainingModel: trainingModel,
      files: rightImages,
    );

    if (response != null && response["status"] == 200) {
      loader = false;
      notifyListeners();
    } else {
      loader = false;
      notifyListeners();
      debugPrint("training submit Error: ${response?['data']}");
    }
  }

  Future loadTraining(String storeId) async {
    trainingList = [];
    loader = true;
    notifyListeners();
    await loadUser();
    await getTrainingList(storeId: storeId);
    loader = false;
    notifyListeners();
  }
}
