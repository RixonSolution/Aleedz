import 'package:aleedz/core/controllers/open_issue_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/open_issue_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final openIssueModelProvider = ChangeNotifierProvider<OpenIssuesViewModel>((
  ref,
) {
  return OpenIssuesViewModel();
});

class OpenIssuesViewModel extends ChangeNotifier {
  final OpenIssuesController _openIssueController = OpenIssuesController();
  UserModel? user;
  bool loader = false;
  List<OpenIssueModel> openIssueList = [];

  Future loadUser() async {
    loader = true;
    notifyListeners();
    final store = StoreLocalData();

    user = await store.getUserFromPrefs();

    notifyListeners();

    if (user != null) {
      print('Welcome ${user!.teamMemberName}');
    } else {
      print('No user found in prefs');
    }
  }

  Future<void> getIssueList({
    String chanelTypeId = '1',
    String storeId = '0',
  }) async {
    openIssueList = [];
    notifyListeners();

    final response = await _openIssueController.issueList(
      token: user?.apiToken ?? '',
      teamMemberId: user?.teamMemberID.toString() ?? '',
      chanelTypeId: chanelTypeId,
      storeId: storeId,
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      openIssueList = data.map((e) => OpenIssueModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      loader = false;

      notifyListeners();
      debugPrint("issues list Error: ${response?['data']}");
    }
  }

  Future loadIssues() async {
    loader = true;
    notifyListeners();
    await loadUser();
    await getIssueList();
    loader = false;
    notifyListeners();
  }
}
