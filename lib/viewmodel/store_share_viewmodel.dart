import 'package:aleedz/core/controllers/store_share_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/training_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storeShareModelProvider = ChangeNotifierProvider<StoreShareViewModel>((
  ref,
) {
  return StoreShareViewModel();
});

class StoreShareViewModel extends ChangeNotifier {
  final StoreShareController _shareController = StoreShareController();

  UserModel? user;
  List<TrainingListModel> trainingList = [];
  List<BrandListModel> brandList = [];
  BrandListModel? selectedBrand;

  bool loader = false;

  void selectBrand(int storeId, BrandListModel? brand) async {
    loader = true;
    notifyListeners();
    selectedBrand = brand;
    notifyListeners();
    print("Selected Channel ID: ${brand?.brandId}");

    if (brand != null) {}
    loader = false;
    notifyListeners();
  }

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

  Future<void> getBrandDropDown() async {
    final response = await _shareController.brandDropDown(
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      brandList = data.map((e) => BrandListModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future<void> getTrainingList() async {
    trainingList = [];
    notifyListeners();

    final response = await _shareController.trainingList(
      token: user?.apiToken ?? '',
      storeId: '0',
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

  Future loadShare() async {
    trainingList = [];
    loader = true;
    notifyListeners();
    await loadUser();
    getBrandDropDown();
    // await getTrainingList();
    loader = false;
    notifyListeners();
  }
}
