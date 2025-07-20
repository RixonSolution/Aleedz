import 'package:aleedz/core/controllers/pending_deployment_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/chanel_mode.dart';
import 'package:aleedz/models/pending_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pendingModelProvider = ChangeNotifierProvider<PendingDeploymentViewModel>(
  (ref) {
    return PendingDeploymentViewModel();
  },
);

class PendingDeploymentViewModel extends ChangeNotifier {
  final PendingDeploymentController _checkController =
      PendingDeploymentController();

  UserModel? user;
  ChannelModel? selectedChannel;
  List<ChannelModel> channelList = [];

  List<PendingModel> pendingList = [];
  List<PendingModel> filteredList = [];

  void selectChannel(
    ChannelModel? channel,
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    loader = true;
    notifyListeners();
    selectedChannel = channel;
    notifyListeners();
    print("Selected Channel ID: ${channel?.channelId}");
    if (channel != null) {
      await getPendingList();
    }
    loader = false;
    notifyListeners();
    // You can also call getCoverageList here with the selectedChannel.channelId
  }

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

  Future<void> getPendingList() async {
    pendingList = [];
    notifyListeners();

    final response = await _checkController.pendingList(
      token: user?.apiToken ?? '',
      activityCategory: '0',
      teamMemberId: '0',

      // teamMemberId: user?.teamMemberID.toString() ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      pendingList = data.map((e) => PendingModel.fromJson(e)).toList();

      filteredList = pendingList;

      notifyListeners();
    } else {
      debugPrint("pending list Error: ${response?['data']}");
    }
  }

  void filterPendingList(String query) {
    if (query.isEmpty) {
      filteredList = pendingList;
    } else {
      filteredList =
          pendingList.where((item) {
            return (item.storeName?.toLowerCase() ?? '').contains(
                  query.toLowerCase(),
                ) ||
                (item.activityCategoryName?.toLowerCase() ?? '').contains(
                  query.toLowerCase(),
                ) ||
                (item.taskDeploymentCategoryName?.toLowerCase() ?? '').contains(
                  query.toLowerCase(),
                );
          }).toList();
    }
    notifyListeners();
  }

  List<String> get uniqueCategories {
    final categories =
        pendingList
            .map((e) => e.activityCategoryName ?? '')
            .where((name) => name.isNotEmpty)
            .toSet()
            .toList();
    categories.sort(); // Optional: Sort alphabetically
    return categories;
  }

  void filterByCategory(String? categoryName) {
    if (categoryName == null || categoryName.isEmpty) {
      filteredList = pendingList;
    } else {
      filteredList =
          pendingList
              .where((item) => item.activityCategoryName == categoryName)
              .toList();
    }
    notifyListeners();
  }

  Future loadPending() async {
    pendingList = [];
    loader = true;
    notifyListeners();
    await loadUser();
    await getPendingList();
    loader = false;
    notifyListeners();
  }
}
