import 'package:aleedz/core/controllers/coverage_controller.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/chanel_mode.dart';
import 'package:aleedz/models/store_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

final coverageModelProvider = ChangeNotifierProvider<CoverageViewModel>((ref) {
  return CoverageViewModel();
});

class CoverageViewModel extends ChangeNotifier {
  final CoverageController _coverageController = CoverageController();

  UserModel? user;
  int? storeCount;
  List<StoreModel> stores = [];

  List<ChannelModel> channelList = [];
  ChannelModel? selectedChannel;

  void selectChannel(ChannelModel? channel, BuildContext context) async {
    loader = true;
    notifyListeners();
    selectedChannel = channel;
    notifyListeners();
    print("Selected Channel ID: ${channel?.channelId}");
    if (channel != null) {
      await getCoverageList(context, channelId: channel.channelId);
    }
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

  void loadUser() async {
    loader = true;
    notifyListeners();
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
        loader = false;
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

    loader = false;
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
      longitude: latitude.toString(),
      latitude: longitude.toString(),
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
      longitude: latitude.toString(),
      latitude: longitude.toString(),
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
}
