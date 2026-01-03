import 'dart:convert';
import 'package:aleedz/core/controllers/home_chart_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/monthly_dashboard_sale.dart';
import 'package:aleedz/models/monthly_recent_sale_model.dart';
import 'package:aleedz/models/monthly_sale_model.dart';
import 'package:aleedz/models/target_achievement_model.dart';
import 'package:aleedz/models/uer_permission.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:aleedz/viewmodel/monthly_target_value_model.dart';
import 'package:aleedz/models/field_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final homeChartTeamMP = ChangeNotifierProvider<HomeChartTeamViewModel>((ref) {
  return HomeChartTeamViewModel();
});

class HomeChartTeamViewModel extends ChangeNotifier {
  final HomeChartController _homeChartController = HomeChartController();
  UserModel? user;
  UserPermission? permission;
  List<MonthlySaleModel>? monthlySaleModel = [];
  List<MonthlyTargetValueModel>? monthlyTargetValueModel = [];
  List<MonthlyRecentSaleModel>? monthlyRecentSaleModel = [];
  List<MonthlyDashboardSaleModel>? monthlyDashboardSaleModel = [];
  List<TargetAchievementModel> targetAchievementValue = [];
  List<TargetAchievementModel> targetAchievementQty = [];
  List<FieldUserModel> fieldUsers = [];
  FieldUserModel? selectedFieldUser;

  String? storeCount = '0';
  String storeTimeSpend = '00:00';
  String storeTotalTravel = '-';

  bool loader = false;

  // Month map as a static or top-level constant
  static const Map<int, String> _monthNameMap = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  String selectedMonth = _monthNameMap[DateTime.now().month]!;
  String selectedMonthNumber = DateTime.now().month.toString().padLeft(2, '0');
  String selectedYear = DateTime.now().year.toString();

  int get _activeTeamMemberId => selectedFieldUser?.teamMemberId ?? 0;

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
      teamMemberId: _activeTeamMemberId,
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

  Future<void> getMonthlySale({String? targetYear, String? targetMonth}) async {
    monthlySaleModel = [];
    final now = DateTime.now();
    final year = targetYear ?? now.year.toString();
    final month = targetMonth ?? now.month.toString(); // can pad if needed

    notifyListeners();

    final response = await _homeChartController.getMonthlySale(
      teamMemberId: _activeTeamMemberId,
      token: user?.apiToken ?? '',
      targetYear: year,
      targetMonth: month,
      managerId: 0,
      brandId: 0,
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
    String? targetYear,
    String? targetMonth,
  }) async {
    final now = DateTime.now();
    final year = targetYear ?? now.year.toString();
    final month =
        targetMonth ??
        now.month.toString().padLeft(2, '0'); // padded for '01', '02', etc.

    monthlyTargetValueModel = [];
    notifyListeners();

    final response = await _homeChartController.getMonthlyTargetValue(
      teamMemberId: _activeTeamMemberId,
      token: user?.apiToken ?? '',
      targetYear: year,
      targetMonth: month,
      managerId: 0,
      brandId: 0,
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
      teamMemberId: _activeTeamMemberId,
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      monthlyRecentSaleModel =
          data.map((e) => MonthlyRecentSaleModel.fromJson(e)).toList();
      notifyListeners();
    } else {
      debugPrint("Monthly Target Value Error: ${response?['data']}");
    }
  }

  List<WeeklySaleEntry> getWeeklySaleData() {
    final List<MonthlyRecentSaleModel> sales = monthlyRecentSaleModel ?? [];
    if (sales.isEmpty) return [];

    final Map<DateTime, double> totalsByDay = {};

    for (final sale in sales) {
      final date = DateTime(
        sale.creationDateTime.year,
        sale.creationDateTime.month,
        sale.creationDateTime.day,
      );
      final value = showQty ? sale.quantity.toDouble() : sale.saleValue;
      totalsByDay.update(
        date,
        (existing) => existing + value,
        ifAbsent: () => value,
      );
    }

    return totalsByDay.entries
        .map((entry) => WeeklySaleEntry(date: entry.key, value: entry.value))
        .toList();
  }

  Future<void> getMonthlyDashboardSale() async {
    monthlyDashboardSaleModel = [];
    notifyListeners();

    final response = await _homeChartController.getMonthlyDashboardSale(
      teamMemberId: _activeTeamMemberId,
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

  Future<void> init() async {
    final now = DateTime.now();
    selectedMonth = _monthNameMap[now.month]!;
    selectedMonthNumber = now.month.toString().padLeft(2, '0');
    selectedYear = now.year.toString();

    await getMonthlySale();
    await getMonthlyTargetValue();
    await fetchTargetAchievements();

    notifyListeners();
  }

  Future<void> updateSelectedMonth(String month, {String? year}) async {
    loader = true;
    notifyListeners();
    selectedMonth = month;
    selectedMonthNumber = _monthMap[month] ?? '01';
    if (year != null) {
      selectedYear = year;
    }
    await getMonthlyTargetValue(targetMonth: selectedMonthNumber);
    await getMonthlySale(targetMonth: selectedMonthNumber);
    await fetchTargetAchievements(month: selectedMonthNumber);
    loader = false;
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
  bool showQty = false;

  void setShowQty(bool value) {
    showQty = value;
    notifyListeners();
  }

  List<TargetAchievementModel> get activeTargetAchievements {
    final list = showQty ? targetAchievementQty : targetAchievementValue;
    if (_activeTeamMemberId != 0) {
      return list
          .where((entry) => entry.teamMemberId == _activeTeamMemberId)
          .toList();
    }
    return list;
  }

  List<TargetAchievementSummary> get activeTargetAchievementSummaries {
    final entries = activeTargetAchievements;
    final Map<int, TargetAchievementSummary> summaryMap = {};

    for (final entry in entries) {
      final summary = summaryMap.putIfAbsent(
        entry.brandId,
        () => TargetAchievementSummary(
          brandId: entry.brandId,
          brandName: entry.brandName,
        ),
      );

      summary.target += entry.target;
      summary.achieved += entry.achieved;
    }

    final summaries = summaryMap.values.toList();
    summaries.sort((a, b) => a.brandName.compareTo(b.brandName));
    return summaries;
  }

  Future<void> fetchTargetAchievements({String? month, String? year}) async {
    if (user == null) return;

    final currentMonth = month ?? selectedMonthNumber;
    final currentYear = year ?? selectedYear;
    final brandId = 0; // Default: All brands

    final valueResponse =
        await _homeChartController.getManagementTargetAchievementValue(
      brandId: brandId,
      month: currentMonth,
      year: currentYear,
      teamMemberId: _activeTeamMemberId,
      token: user?.apiToken ?? '',
      managerId: 0,
    );

    if (valueResponse != null && valueResponse["status"] == 200) {
      final data = valueResponse["data"]['data'] as List?;
      targetAchievementValue =
          data
              ?.map(
                (item) => TargetAchievementModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [];
    } else {
      targetAchievementValue = [];
      debugPrint("Target Achievement Value Error: ${valueResponse?['data']}");
    }

    final qtyResponse =
        await _homeChartController.getManagementTargetAchievementQty(
      brandId: brandId,
      month: currentMonth,
      year: currentYear,
      teamMemberId: _activeTeamMemberId,
      token: user?.apiToken ?? '',
      managerId: 0,
    );

    if (qtyResponse != null && qtyResponse["status"] == 200) {
      final data = qtyResponse["data"]['data'] as List?;
      targetAchievementQty =
          data
              ?.map(
                (item) => TargetAchievementModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [];
    } else {
      targetAchievementQty = [];
      debugPrint("Target Achievement Qty Error: ${qtyResponse?['data']}");
    }

    notifyListeners();
  }

  Future loadDashboard(context) async {
    loader = true;
    showQty = false;
    notifyListeners();
    await loadUser();

    await loadFieldUsers();
    await init();
    await getCoverageCount(context);
    await getMonthRecentSale();
    await getMonthlyDashboardSale();

    loader = false;
    notifyListeners();
  }

  Future<void> loadFieldUsers() async {
    fieldUsers = [];
    selectedFieldUser = null;
    notifyListeners();

    final response = await _homeChartController.getFieldUsers(
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]?['data'] as List?;
      fieldUsers =
          data
              ?.map(
                (e) => FieldUserModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [];
      notifyListeners();
    }
  }

  Future<void> setSelectedFieldUser(
    FieldUserModel? user,
    BuildContext context,
  ) async {
    selectedFieldUser = user;
    loader = true;
    notifyListeners();

    await fetchTargetAchievements(
      month: selectedMonthNumber,
      year: selectedYear,
    );
    await getMonthRecentSale();
    await getMonthlyDashboardSale();
    await getCoverageCount(context);

    loader = false;
    notifyListeners();
  }
}

class WeeklySaleEntry {
  WeeklySaleEntry({required this.date, required this.value});

  final DateTime date;
  final double value;
}

class TargetAchievementSummary {
  TargetAchievementSummary({
    required this.brandId,
    required this.brandName,
    double initialTarget = 0,
    double initialAchieved = 0,
  }) : target = initialTarget,
       achieved = initialAchieved;

  final int brandId;
  final String brandName;
  double target;
  double achieved;

  double get percentage {
    if (target <= 0) return 0;
    return (achieved / target) * 100;
  }
}
