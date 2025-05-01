import 'package:aleedz/core/controllers/coverage_controller.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/store_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coverageModelProvider = ChangeNotifierProvider<CoverageViewModel>((ref) {
  return CoverageViewModel();
});

class CoverageViewModel extends ChangeNotifier {
  final CoverageController _coverageController = CoverageController();

  UserModel? user;
  int? storeCount;
  List<StoreModel> stores = [];

  void loadUser() async {
    final store = StoreLocalData();

    user = await store.getUserFromPrefs();

    if (user != null) {
      print('Welcome ${user!.teamMemberName}');
    } else {
      print('No user found in prefs');
    }
  }

  bool loader = false;

  Future<void> getCoverageCount(BuildContext context) async {
    loader = true;
    notifyListeners();

    final response = await _coverageController.coverageCount(
      teamMemberId: user?.teamMemberID ?? 0,
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final dataList = response["data"]['data'];
      if (dataList != null && dataList is List && dataList.isNotEmpty) {
        storeCount = dataList[0]["MyCoverageStoresCount"];
        notifyListeners();
      }
    } else {
      debugPrint("Login Error: ${response?['data']}");
    }
  }

  Future<void> getCoverageList(BuildContext context) async {
    final response = await _coverageController.coverageList(
      teamMemberId: user?.teamMemberID ?? 0,
      chanelId: '',
      searchKeyWord: '',
      chanelTypeId: '',
      token: user?.apiToken ?? '',
    );

    loader = false;
    notifyListeners();

    if (response != null && response["status"] == 200) {
      final dataList = response["data"]['data'];
      print('Store List:${dataList}');

      if (dataList != null && dataList is List && dataList.isNotEmpty) {
        stores = dataList.map((e) => StoreModel.fromJson(e)).toList();
        notifyListeners();
      }
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }
}
