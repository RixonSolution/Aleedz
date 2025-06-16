import 'package:aleedz/core/controllers/checklist_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/activity_type_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trainingModelProvider = ChangeNotifierProvider<TrainingViewModel>((ref) {
  return TrainingViewModel();
});

class TrainingViewModel extends ChangeNotifier {
  final ChecklistController _checkController = ChecklistController();

  UserModel? user;
  List<ActivityModelType> activityType = [];

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
