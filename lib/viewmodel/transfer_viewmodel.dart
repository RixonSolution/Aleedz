import 'dart:convert';
import 'package:aleedz/core/controllers/transfer_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/audit_model.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/brand_model.dart';
import 'package:aleedz/models/chanel_mode.dart';
import 'package:aleedz/models/product_selection_model.dart';
import 'package:aleedz/models/transfer_check_brand.dart';
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
  BrandListModel? selectedBrand;
  Map<String, TextEditingController> quantityControllers = {};

  List<TransferModel> transfer = [];

  List<ChannelModel> channelList = [];
  List<BrandListModel> brandList = [];
  List<ProductSelection> selectedProducts = [];

  UserPermission? permission;

  List<Brand> brands = [];
  List<TransferCheckBrand> transferCheck = [];

  List<AuditItem> auditList = [];

  ChannelModel? selectedChannel;

  Future<void> transferSubmitList(int storeId, int categoryId) async {
    loader = true;
    auditList = [];
    selectedProducts = [];
    notifyListeners();
    final response = await _transferController.transferSubmitList(
      storeId: storeId.toString(),
      categoryId: categoryId.toString(),
      token: user?.apiToken ?? '',
      visiteStatus: '0',
    );

    if (response != null && response["status"] == 200) {
      final List<AuditItem> items = List<AuditItem>.from(
        response['data']['data'].map((x) => AuditItem.fromJson(x)),
      );
      auditList = items;
      auditList.forEach((auditItem) {
        final product = ProductSelection(
          displayCheck: auditItem.displayCheck,
          displayCheckCount: auditItem.displayCheckCount,
          productId: auditItem.productId,
          token: user?.apiToken ?? '',
          storeId: storeId.toString(),
          teamMemberId: user!.teamMemberID.toString(),
          // Add other relevant fields
        );

        selectedProducts.add(product);
      });

      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
    }
  }

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

  Future<void> getBrandDropDown() async {
    final response = await _transferController.brandDropDown(
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

  void selectBrand(int storeId, BrandListModel? brand) async {
    loader = true;
    notifyListeners();
    selectedBrand = brand;
    notifyListeners();
    print("Selected Channel ID: ${brand?.brandId}");

    if (brand != null) {
      await transferCheckBrand(storeId, brand.brandId);
    }
    loader = false;
    notifyListeners();
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

  Future<void> transferCheckBrand(int storeId, int brandId) async {
    loader = true;
    brands = [];
    notifyListeners();
    final response = await _transferController.transferCheckBrand(
      storeId: storeId.toString(),
      brandId: brandId.toString(),
      token: user?.apiToken ?? '',
      visiteId: '0',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      transferCheck = data.map((e) => TransferCheckBrand.fromJson(e)).toList();

      loader = false;
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
      loader = false;
      notifyListeners();
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
