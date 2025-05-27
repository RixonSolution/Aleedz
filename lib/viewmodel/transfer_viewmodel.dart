import 'dart:convert';
import 'package:aleedz/core/controllers/transfer_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/audit_model.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/brand_model.dart';
import 'package:aleedz/models/chanel_mode.dart';
import 'package:aleedz/models/transfer_model.dart';
import 'package:aleedz/models/uer_permission.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

final transferModelProvider = ChangeNotifierProvider<TransferViewModel>((ref) {
  return TransferViewModel();
});

class TransferViewModel extends ChangeNotifier {
  final TransferController _transferController = TransferController();

  UserModel? user;
  String? storeCount = '0';
  String? storeTimeSpend = '0';
  String? storeTotalTravel = '0';

  List<TransferModel> transfer = [];

  List<ChannelModel> channelList = [];
  List<BrandListModel> brandList = [];

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

  void selectChannel(ChannelModel? channel, BuildContext context) async {
    loader = true;
    notifyListeners();
    selectedChannel = channel;
    notifyListeners();
    print("Selected Channel ID: ${channel?.channelId}");
    if (channel != null) {
      await getTransferList(context, channelId: channel.channelId);
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

  Future<void> getTransferList(
    BuildContext context, {
    String searchKeyword = '',
    int channelId = 0,
  }) async {
    final response = await _transferController.transferList(
      teamMemberId: user?.teamMemberID.toString() ?? '0',
      chanelId: channelId.toString(),
      searchKeyWord: searchKeyword,
      chanelTypeId: '0',
      token: user?.apiToken ?? '',
      visiteId: '0',
    );

    if (response != null && response["status"] == 200) {
      final dataList = response["data"]['data'];

      if (dataList != null && dataList is List && dataList.isNotEmpty) {
        transfer = dataList.map((e) => TransferModel.fromJson(e)).toList();
        notifyListeners();
      }
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future<void> getTransferDropDown() async {
    final response = await _transferController.transferDropDown(
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

  Future loadCoverageData(context) async {
    loader = true;
    notifyListeners();
    await loadUser();
    await getLatLong();
    await getTransferDropDown();
    await getTransferList(context);

    loader = false;
    notifyListeners();
  }
}
