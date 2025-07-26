import 'dart:convert';
import 'package:aleedz/core/controllers/home_chart_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/monthly_dashboard_sale.dart';
import 'package:aleedz/models/monthly_recent_sale_model.dart';
import 'package:aleedz/models/monthly_sale_model.dart';
import 'package:aleedz/models/uer_permission.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:aleedz/viewmodel/monthly_target_value_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final homeChartMP = ChangeNotifierProvider<HomeChartViewModel>((ref) {
  return HomeChartViewModel();
});

class HomeChartViewModel extends ChangeNotifier {
  final HomeChartController _homeChartController = HomeChartController();
  UserModel? user;
  UserPermission? permission;
  List<MonthlySaleModel>? monthlySaleModel = [];
  List<MonthlyTargetValueModel>? monthlyTargetValueModel = [];
  List<MonthlyRecentSaleModel>? monthlyRecentSaleModel = [];
  List<MonthlyDashboardSaleModel>? monthlyDashboardSaleModel = [];

  String? storeCount = '0';

  bool loader = false;

  Future<UserPermission?> loadStoredPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_permission');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      return UserPermission.fromJson(jsonMap);
    }
    return null;
  }

  Future loadUser() async {
    final store = StoreLocalData();

    user = await store.getUserFromPrefs();
    permission = await loadStoredPermissions();
    notifyListeners();

    if (user != null) {
      print('Welcome ${user!.teamMemberName}');
    } else {
      print('No user found in prefs');
    }
  }

  Future<void> getCoverageCount(BuildContext context) async {
    notifyListeners();

    final response = await _homeChartController.coverageCount(
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

  Future<void> getMonthlySale({
    String targetYear = '2025',
    String targetMonth = '7',
  }) async {
    monthlySaleModel = [];
    notifyListeners();

    final response = await _homeChartController.getMonthlySale(
      teamMemberId: user?.teamMemberID ?? 0,
      token: user?.apiToken ?? '',
      targetYear: targetYear,
      targetMonth: targetMonth,
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      monthlySaleModel = data.map((e) => MonthlySaleModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("Monthly Sale Error: ${response?['data']}");
    }
  }

  Future<void> getMonthlyTargetValue({
    String targetYear = '2025',
    String targetMonth = '7',
  }) async {
    monthlyTargetValueModel = [];
    notifyListeners();

    final response = await _homeChartController.getMonthlyTargetValue(
      teamMemberId: user?.teamMemberID ?? 0,
      token: user?.apiToken ?? '',
      targetYear: targetYear,
      targetMonth: targetMonth,
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      monthlyTargetValueModel =
          data.map((e) => MonthlyTargetValueModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("Monthly Target Value Error: ${response?['data']}");
    }
  }

  Future<void> getMonthRecentSale() async {
    monthlyRecentSaleModel = [];
    notifyListeners();

    final response = await _homeChartController.getMonthlyRecentSale(
      teamMemberId: user?.teamMemberID ?? 0,
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      monthlyRecentSaleModel =
          data.map((e) => MonthlyRecentSaleModel.fromJson(e)).toList();
      getWeeklySaleData();

      notifyListeners();
    } else {
      debugPrint("Monthly Target Value Error: ${response?['data']}");
    }
  }

  Map<int, double> getWeeklySaleData() {
    // Map<weekday, totalSaleValue>
    final Map<int, double> weeklyData = {
      1: 0, // Monday
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
      7: 0, // Sunday
    };

    for (final sale in monthlyRecentSaleModel ?? []) {
      int weekday = sale.creationDateTime.weekday;
      weeklyData[weekday] = (weeklyData[weekday] ?? 0) + sale.saleValue;
    }

    return weeklyData;
  }

  Future<void> getMonthlyDashboardSale() async {
    monthlyDashboardSaleModel = [];
    notifyListeners();

    final response = await _homeChartController.getMonthlyDashboardSale(
      teamMemberId: user?.teamMemberID ?? 0,
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      monthlyDashboardSaleModel =
          data.map((e) => MonthlyDashboardSaleModel.fromJson(e)).toList();

      notifyListeners();
    } else {
      debugPrint("Monthly Target Value Error: ${response?['data']}");
    }
  }

  String selectedMonth = 'July';
  String selectedMonthNumber = '07';

  void updateSelectedMonth(String month) async {
    selectedMonth = month;
    selectedMonthNumber = _monthMap[month] ?? '01';
    await getMonthlyTargetValue(targetMonth: selectedMonthNumber);
    await getMonthlySale(targetMonth: selectedMonthNumber);
    notifyListeners();
  }

  // Month name to number mapping
  final Map<String, String> _monthMap = {
    'January': '01',
    'February': '02',
    'March': '03',
    'April': '04',
    'May': '05',
    'June': '06',
    'July': '07',
    'August': '08',
    'September': '09',
    'October': '10',
    'November': '11',
    'December': '12',
  };
  bool showQty = true;

  void setShowQty(bool value) {
    showQty = value;
    notifyListeners();
  }

  Future loadDashboard(context) async {
    loader = true;
    notifyListeners();
    await loadUser();
    await getCoverageCount(context);
    await getMonthlySale();
    await getMonthlyTargetValue();
    await getMonthRecentSale();
    await getMonthlyDashboardSale();

    loader = false;
    notifyListeners();
  }
}
