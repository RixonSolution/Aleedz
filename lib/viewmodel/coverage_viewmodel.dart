import 'dart:convert';

import 'package:aleedz/core/controllers/coverage_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/audit_model.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/brand_model.dart';
import 'package:aleedz/models/chanel_mode.dart';
import 'package:aleedz/models/store_model.dart';
import 'package:aleedz/models/uer_permission.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

final coverageModelProvider = ChangeNotifierProvider<CoverageViewModel>((ref) {
  return CoverageViewModel();
});

class CoverageViewModel extends ChangeNotifier {
  final CoverageController _coverageController = CoverageController();

  UserModel? user;
  int? storeCount = 0;
  List<StoreModel> stores = [];

  List<ChannelModel> channelList = [];
  List<BrandListModel> brandList = [];
  UserPermission? permission;

  List<Brand> brands = [];
  List<AuditItem> auditList = [];

  ChannelModel? selectedChannel;
  BrandListModel? selectedBrand;

  Future<UserPermission?> loadStoredPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_permission');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      return UserPermission.fromJson(jsonMap);
    }
    return null;
  }

  void selectChannel(ChannelModel? channel, BuildContext context) async {
    loader = true;
    notifyListeners();
    selectedChannel = channel;
    notifyListeners();
    print("Selected Channel ID: ${channel?.channelId}");
    if (channel != null) {
      await getCoverageList(context, channelId: channel.channelId);
    }
    loader = false;
    notifyListeners();
    // You can also call getCoverageList here with the selectedChannel.channelId
  }

  void selectBrand(
    int storeId,
    BrandListModel? brand,
    BuildContext context,
  ) async {
    loader = true;
    notifyListeners();
    selectedBrand = brand;
    notifyListeners();
    print("Selected Channel ID: ${brand?.brandId}");
    if (brand != null) {
      await checkSummary(storeId, brand.brandId);
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
  }) async {
    final response = await _coverageController.coverageList(
      teamMemberId: user?.teamMemberID ?? 0,
      chanelId: channelId,
      searchKeyWord: searchKeyword,
      chanelTypeId: '',
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final dataList = response["data"]['data'];

      if (dataList != null && dataList is List && dataList.isNotEmpty) {
        stores = dataList.map((e) => StoreModel.fromJson(e)).toList();
        notifyListeners();
      }
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future<void> getCoverageDropDown() async {
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
      checkInImg: '',
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      await getCoverageList(context);
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future<void> coverageCheckout(
    BuildContext context,
    int visitedId, {
    String planRemarks = '',
    String remarks = '',
    bool isLocationAvailable = false,
  }) async {
    loader = true;
    notifyListeners();
    final response = await _coverageController.coverageCheckOut(
      visitedId: visitedId.toString(),
      longitude: longitude.toString(),
      latitude: latitude.toString(),
      remarks: remarks,
      checkInImg: '',
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      await getCoverageList(context);
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future<void> checkSummary(int storeId, int brandId) async {
    loader = true;
    brands = [];
    notifyListeners();
    final response = await _coverageController.displayCheckSummany(
      storeId: storeId.toString(),
      branddId: brandId.toString(),
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final List<Brand> brandList = List<Brand>.from(
        response['data']['data'].map((x) => Brand.fromJson(x)),
      );
      brands = brandList;
      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

  Future<void> getBrandDropDown() async {
    selectedBrand = null;
    brandList = [];
    notifyListeners();
    final response = await _coverageController.brandDropDown(
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

  Future<void> checkAudit(int storeId, int categoryId) async {
    loader = true;
    auditList = [];
    notifyListeners();
    final response = await _coverageController.checkAudit(
      storeId: storeId.toString(),
      categoryId: categoryId.toString(),
      token: user?.apiToken ?? '',
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
}
