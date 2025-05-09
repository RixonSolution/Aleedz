import 'dart:io';
import 'package:aleedz/core/controllers/coverage_controller.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/audit_model.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/brand_model.dart';
import 'package:aleedz/models/product_selection_model.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

final storeModelProvider = ChangeNotifierProvider<StoreViewModel>((ref) {
  return StoreViewModel();
});

class StoreViewModel extends ChangeNotifier {
  final CoverageController _coverageController = CoverageController();

  UserModel? user;
  File? leftImage;
  File? rightImage;
  final ImagePicker picker = ImagePicker();
  BrandListModel? selectedBrand;
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

  List<BrandListModel> brandList = [];
  List<ProductSelection> selectedProducts = [];

  List<Brand> brands = [];
  List<AuditItem> auditList = [];

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
    notifyListeners();

    if (user != null) {
      print('Welcome ${user!.teamMemberName}');
    } else {
      print('No user found in prefs');
    }
  }

  bool loader = false;

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
    selectedProducts = [];
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

  Future<void> pickFromCamera(String direction) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      if (direction == 'left') {
        leftImage = File(pickedFile.path);
        notifyListeners();
      } else {
        rightImage = File(pickedFile.path);
        notifyListeners();
      }
    }
  }

  Future<void> pickFromGallery(String direction) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (direction == 'left') {
        leftImage = File(pickedFile.path);
        notifyListeners();
      } else {
        rightImage = File(pickedFile.path);
        notifyListeners();
      }
    }
  }

  Future<void> addDisplayCheck(
    List<Map<String, dynamic>> dataList,
    BuildContext context,
    int storeId,
    int categoryId,
  ) async {
    loader = true;
    notifyListeners();

    final response = await _coverageController.displayCheckAddController(
      dataList: dataList,
    );

    await checkSummary(storeId, 0);
    AppSnackBar.showSuccess(context, 'Display Check added successfully');

    // if (response != null && response["status"] == 200) {
    //   debugPrint("Display Check added successfully: ${response['data']}");
    // } else {
    //   debugPrint("Display Check Error: ${response?['data']}");
    // }

    loader = false;
    notifyListeners();
  }

  void clearData() {
    leftImage = null;
    rightImage = null;
    selectedProducts.clear();
    notifyListeners();
  }
}
