import 'dart:convert';
import 'dart:io';
import 'package:aleedz/core/controllers/coverage_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/audit_model.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/brand_model.dart';
import 'package:aleedz/models/chanel_mode.dart';
import 'package:aleedz/models/dashboard_model.dart';
import 'package:aleedz/models/store_model.dart';
import 'package:aleedz/models/uer_permission.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

final coverageModelProvider = ChangeNotifierProvider<CoverageViewModel>((ref) {
  return CoverageViewModel();
});

class CoverageViewModel extends ChangeNotifier {
  final CoverageController _coverageController = CoverageController();

  UserModel? user;
  String? storeCount = '0';
  String? storeTimeSpend = '0';
  String? storeTotalTravel = '0';

  List<StoreModel> stores = [];

  List<ChannelModel> channelList = [];
  List<BrandListModel> brandList = [];
  List<DashboardModel> dashBoardList = [];

  int userPlan = 0;
  List<DashboardModel> userPlanList = [];

  int userVisited = 0;
  List<DashboardModel> userVisitedList = [];

  UserPermission? permission;

  List<Brand> brands = [];
  List<AuditItem> auditList = [];

  ChannelModel? selectedChannel;

  Future<UserPermission?> loadStoredPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_permission');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      return UserPermission.fromJson(jsonMap);
    }
    return null;
  }

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
      await getCoverageList(
        context,
        channelId: channel.channelId,
        forceRefresh: forceRefresh,
      );
    }
    loader = false;
    notifyListeners();
    // You can also call getCoverageList here with the selectedChannel.channelId
  }

  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> getLatLong() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Separate variables
    latitude = position.latitude;
    longitude = position.longitude;
    print('latitude:$latitude, longitude:$longitude');

    notifyListeners();
  }

  double calculateDistanceInMeters(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    const earthRadius = 6371000; // in meters

    final dLat = _degreesToRadians(endLat - latitude);
    final dLng = _degreesToRadians(endLng - longitude);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(startLat)) *
            cos(_degreesToRadians(endLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
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

  bool loader = false;

  Future<void> getCoverageCount(BuildContext context) async {
    // If already fetched and not zero, skip API call
    // if (storeCount != '0') return;

    selectedChannel = null;
    notifyListeners();

    final response = await _coverageController.coverageCount(
      teamMemberId: user?.teamMemberID ?? 0,
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final dataList = response["data"]['data'];
      if (dataList != null && dataList is List && dataList.isNotEmpty) {
        storeCount = dataList[0]["MyCoverageStoresCount"];
        storeTimeSpend = dataList[1]["MyCoverageStoresCount"];
        storeTotalTravel = dataList[2]["MyCoverageStoresCount"];
        notifyListeners();
      }
    } else {
      debugPrint("Login Error: ${response?['data']}");
    }
  }

  Future<void> getCoverageList(
    BuildContext context, {
    String searchKeyword = '',
    int channelId = 0,
    bool forceRefresh = false,
  }) async {
    loader = true;
    notifyListeners();
    // Condition to skip API call unless list is empty or forceRefresh is true
    if (stores.isNotEmpty && !forceRefresh) return;

    final response = await _coverageController.coverageList(
      teamMemberId: user?.teamMemberID ?? 0,
      chanelId: channelId,
      searchKeyWord: searchKeyword,
      chanelTypeId: '',
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final dataList = response["data"]['data'];
      loader = false;
      notifyListeners();
      if (dataList != null && dataList is List && dataList.isNotEmpty) {
        stores = dataList.map((e) => StoreModel.fromJson(e)).toList();
      }
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future<void> getCoverageDropDown() async {
    // If channelList already has data, skip API call
    if (channelList.isNotEmpty) return;

    final response = await _coverageController.coverageDropDown(
      token: user?.apiToken ?? '',
    );

    notifyListeners();

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      channelList = data.map((e) => ChannelModel.fromJson(e)).toList();
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> coverageCheckIn(
    BuildContext context,
    int storeId, {
    String planRemarks = '',
    String remarks = '',
    bool isLocationAvailable = false,
    File? checkInImgFile, // ✅ NEW parameter
  }) async {
    loader = true;
    notifyListeners();

    final response = await _coverageController.coverageCheckIn(
      teamMemberId: user?.teamMemberID.toString() ?? '',
      storeID: storeId.toString(),
      planRemarks: planRemarks,
      planDate: formattedDate,
      longitude: longitude.toString(),
      latitude: latitude.toString(),
      remarks: remarks,
      isLocationAvailable: isLocationAvailable.toString(),
      checkInImgFile: checkInImgFile, // ✅ Pass image as File
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      await getCoverageList(context, forceRefresh: true);
      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future<void> dashboardCheckIn(
    BuildContext context,
    int visiteId, {
    String remarks = '',
    required File checkInImgFile,
  }) async {
    loader = true;
    notifyListeners();

    final response = await _coverageController.dashboardCheckIn(
      longitude: longitude.toString(),
      latitude: latitude.toString(),
      remarks: remarks,
      checkInImgFile: checkInImgFile, // ✅ Pass image as File
      token: user?.apiToken ?? '',
      visiteId: visiteId.toString(),
    );

    if (response != null && response["status"] == 200) {
      await getDashboard();
      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future<void> coverageCheckout(
    BuildContext context,
    int visitedId, {
    String planRemarks = '',
    String remarks = '',
    bool isLocationAvailable = false,
    File? checkOutImgFile, // Now passing a File object instead of base64
  }) async {
    loader = true;
    notifyListeners();

    final response = await _coverageController.coverageCheckOut(
      visitedId: visitedId.toString(),
      longitude: longitude.toString(),
      latitude: latitude.toString(),
      remarks: remarks,
      checkOutImgFile: checkOutImgFile, // Pass the image file here
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      await getCoverageList(context, forceRefresh: true);
      await getDashboard();

      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage checkout Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future<void> getDashboard() async {
    dashBoardList = [];
    DateTime date = DateTime.now(); // or DateTime.now()
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final response = await _coverageController.getDashboard(
      token: user?.apiToken ?? '',
      planDate: formattedDate,
      // planDate: '2025-05-17',
      teamMemberId: user?.teamMemberID.toString() ?? '',
      visiteSatue: '0',
    );

    if (response != null && response["status"] == 200) {
      final dataList = response["data"]["data"];

      if (dataList != null && dataList is List && dataList.isNotEmpty) {
        dashBoardList =
            dataList
                .map<DashboardModel>((data) => DashboardModel.fromJson(data))
                .toList();
        // Count and store VisitTypeID == 1
        userPlanList =
            dashBoardList.where((item) => item.visitTypeId == 1).toList();
        userPlan = userPlanList.length;

        // Count and store VisitStatusID == 3
        userVisitedList =
            dashBoardList
                .where(
                  (item) => item.visitStatusId == 3 && item.visitTypeId == 1,
                )
                .toList();
        userVisited = userVisitedList.length;
      }

      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future<void> cancelVisite(
    BuildContext context,
    int storeId,
    int visiteId, {
    String remarks = '',
  }) async {
    loader = true;
    userPlanList = [];
    userVisitedList = [];
    notifyListeners();

    final response = await _coverageController.cancelVisite(
      teamMemberId: user?.teamMemberID.toString() ?? '',
      storeId: storeId.toString(),
      remark: remarks,
      planDate: formattedDate,
      lng: longitude.toString(),
      lat: latitude.toString(),
      token: user?.apiToken ?? '',
      visiteId: visiteId.toString(),
    );

    if (response != null && response["status"] == 200) {
      await getCoverageList(context, forceRefresh: true);
      await getDashboard();
      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future<void> checkAudit(
    int storeId,
    int categoryId,
    String brandId, // <-- new parameter
    int visitId,
  ) async {
    loader = true;
    auditList = [];
    notifyListeners();
    final response = await _coverageController.checkAudit(
      storeId: storeId.toString(),
      categoryId: categoryId.toString(),
      token: user?.apiToken ?? '',
      brandId: brandId,
      visitId: visitId.toString(),
    );

    if (response != null && response["status"] == 200) {
      final List<AuditItem> items = List<AuditItem>.from(
        response['data']['data'].map((x) => AuditItem.fromJson(x)),
      );
      auditList = items;
      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future loadDashboard(context) async {
    loader = true;
    notifyListeners();
    await loadUser();
    await getLatLong();
    await getCoverageCount(context);
    await getDashboard();

    loader = false;
    notifyListeners();
  }

  Future loadCoverageData(context) async {
    loader = true;
    notifyListeners();
    // await loadUser();
    // await getLatLong();
    await getCoverageCount(context);
    await getCoverageDropDown();
    await getCoverageList(context);

    loader = false;
    notifyListeners();
  }
}
