import 'package:aleedz/core/controllers/alert_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/management_alert_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AlertViewModel extends ChangeNotifier {
  final AlertController _alertController = AlertController();
  final StoreLocalData _store = StoreLocalData();

  UserModel? user;
  bool loader = false;

  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime endDate = DateTime(DateTime.now().year + 1, 1, 1);

  int selectedAlertType = 1;
  List<ManagementAlertModel> alerts = [];

  String get formattedStartDate => DateFormat('yyyy-MM-dd').format(startDate);
  String get formattedEndDate => DateFormat('yyyy-MM-dd').format(endDate);

  Future<void> init() async {
    user = await _store.getUserFromPrefs();
    await loadAlerts();
  }

  Future<void> loadAlerts() async {
    if (user == null) return;

    loader = true;
    notifyListeners();

    final response = await _alertController.getManagementAlerts(
      regionId: 0,
      cityId: 0,
      activityCategoryId: 0,
      channelId: 0,
      storeId: 0,
      dateFrom: formattedStartDate,
      dateTo: formattedEndDate,
      alertType: selectedAlertType,
      token: user?.apiToken ?? '',
    );

    if (response != null && response['status'] == 200) {
      final rawData = response['data'];
      final nested = rawData is Map<String, dynamic> ? rawData['data'] : null;
      final data = rawData is List ? rawData : nested is List ? nested : null;
      alerts =
          data
              ?.map(
                (item) =>
                    ManagementAlertModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [];
    } else {
      alerts = [];
    }

    loader = false;
    notifyListeners();
  }

  Future<void> setAlertType(int type) async {
    selectedAlertType = type;
    await loadAlerts();
  }

  Future<void> setStartDate(DateTime date) async {
    startDate = date;
    await loadAlerts();
  }

  Future<void> setEndDate(DateTime date) async {
    endDate = date;
    await loadAlerts();
  }
}

final alertProvider = ChangeNotifierProvider<AlertViewModel>((ref) {
  return AlertViewModel();
});
