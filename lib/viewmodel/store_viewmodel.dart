import 'dart:convert';
import 'dart:io';
import 'package:aleedz/core/controllers/coverage_controller.dart';
import 'package:aleedz/core/controllers/store_controller.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/audit_model.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/brand_model.dart';
import 'package:aleedz/models/dashboard_model.dart';
import 'package:aleedz/models/display_check_model.dart';
import 'package:aleedz/models/picture_view_model.dart';
import 'package:aleedz/models/product_selection_model.dart';
import 'package:aleedz/models/ros_label.dart';
import 'package:aleedz/models/uer_permission.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storeModelProvider = ChangeNotifierProvider<StoreViewModel>((ref) {
  return StoreViewModel();
});

class StoreViewModel extends ChangeNotifier {
  final CoverageController _coverageController = CoverageController();
  final StoreController _storeController = StoreController();
  List<ROSLabel> rosLabels = [];
  List<DisplayCheckModel> checkMaster = [];
  UserPermission? permission;

  List<PictureViewModel> viewPicture = [];
  List<DashboardModel> dashBoardList = [];
  int visitId = 0;

  bool leftImageRemoved = false; // Add this in your ViewModel
  bool rightImageRemoved = false;

  String storeId = '0';
  Future<UserPermission?> loadStoredPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_permission');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      return UserPermission.fromJson(jsonMap);
    }
    return null;
  }

  Future<void> saveROSLabelsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final rosLabelJson = rosLabels.map((e) => e.toJson()).toList();
    await prefs.setString('rosLabels', jsonEncode(rosLabelJson));
  }

  Future<void> loadROSLabelsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('rosLabels');

    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      rosLabels = decoded.map((e) => ROSLabel.fromJson(e)).toList();
      notifyListeners();
    }
  }

  UserModel? user;
  File? leftImage;
  File? rightImage;
  List<File> leftImages = []; // instead of File? leftImage;
  List<File> rightImages = []; // instead of File? rightImage;
  final ImagePicker picker = ImagePicker();
  BrandListModel? selectedBrand;
  PictureListModel? selectedPictureModel;
  CategoryIssueModel? selectedIssueCategory;

  void selectCategoryIssue(int storeId, CategoryIssueModel? category) async {
    loader = true;
    notifyListeners();
    selectedIssueCategory = category;
    // await getPictureView(
    //   storeId: storeId.toString(),
    //   brandId: selectedBrand?.brandId.toString() ?? '0',
    //   elementId: selectedPictureModel?.pictureElementId.toString() ?? '1',
    // );

    loader = false;
    notifyListeners();
  }

  void selectBrand(int storeId, BrandListModel? brand) async {
    loader = true;
    notifyListeners();
    selectedBrand = brand;
    notifyListeners();
    print("Selected Channel ID: ${brand?.brandId}");
    // await getPictureView(
    //   storeId: storeId.toString(),
    //   brandId: selectedBrand?.brandId.toString() ?? '0',
    //   elementId: selectedPictureModel?.pictureElementId.toString() ?? '1',
    // );
    if (brand != null) {
      await checkSummary(storeId, brand.brandId, visitId);
    }
    loader = false;
    notifyListeners();
  }

  void selectPictureDrop(
    PictureListModel? pictureList,
    BuildContext context,
  ) async {
    loader = true;
    notifyListeners();
    // await getPictureView(
    //   storeId: storeId,
    //   brandId: selectedBrand?.brandId.toString() ?? '0',
    //   elementId: selectedPictureModel?.pictureElementId.toString() ?? '1',
    // );
    selectedPictureModel = pictureList;
    print("Selected Picture ID: ${pictureList?.pictureElementId}");

    loader = false;
    notifyListeners();
    // You can also call getCoverageList here with the selectedChannel.channelId
  }

  List<BrandListModel> brandList = [];
  List<PictureListModel> pictureList = [];
  List<CategoryIssueModel> categoryIssue = [];

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

  Future loadUser() async {
    // loader = true;
    notifyListeners();
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

  Future<void> checkSummary(int storeId, int brandId, int visitId) async {
    loader = true;
    brands = [];
    notifyListeners();
    final response = await _coverageController.displayCheckSummany(
      storeId: storeId.toString(),
      branddId: brandId.toString(),
      token: user?.apiToken ?? '',
      visitId: visitId.toString(),
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

  Future<void> getPictureDropDown() async {
    final response = await _storeController.pictureDropDown(
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      pictureList = data.map((e) => PictureListModel.fromJson(e)).toList();
      // print(pictureList.length);
      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future<void> categoryIssueDropDown() async {
    final response = await _storeController.categoryIssueDropDown(
      token: user?.apiToken ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]['data'] as List;
      categoryIssue = data.map((e) => CategoryIssueModel.fromJson(e)).toList();
      notifyListeners();
    } else {
      debugPrint("Category Issue DropDown: ${response?['data']}");
    }
  }

  Future<void> checkAudit(
    int storeId,
    int categoryId,
    String brandId,
    int visitId,
  ) async {
    loader = true;
    auditList = [];
    selectedProducts = [];
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

  void pickFromGallerys(String direction) async {
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      final files = images.map((img) => File(img.path)).toList();
      if (direction == 'left') {
        leftImages.addAll(files);
      } else if (direction == 'right') {
        rightImages.addAll(files);
      }
      notifyListeners();
    }
  }

  void pickFromCameras(String direction) async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      if (direction == 'left') {
        leftImages.add(File(image.path));
      } else if (direction == 'right') {
        rightImages.add(File(image.path));
      }
      notifyListeners();
    }
  }

  Future<void> addDisplayCheck(
    List<Map<String, dynamic>> dataList,
    BuildContext context,
    int storeId,
    int categoryId,
  ) async {
    final response = await _coverageController.displayCheckAddController(
      dataList: dataList,
    );

    // AppSnackBar.showSuccess(context, 'Display Check added successfully');

    // if (response != null && response["status"] == 200) {
    //   debugPrint("Display Check added successfully: ${response['data']}");
    // } else {
    //   debugPrint("Display Check Error: ${response?['data']}");
    // }

    loader = false;
    notifyListeners();
  }

  Future<void> auditMediaSubmit(
    BuildContext context,
    int storeId,
    String productCategoryId,
    String displayCheckMark,
    String brandId,
    int visitId, { // ➕ New parameter
    required List<File> checkInImages1, // For DisplayCheckImage1 variations
    required List<File> checkInImages2, // For DisplayCheckImage2 variations
  }) async {
    loader = true;
    notifyListeners();

    final response = await _storeController.auditMediaSubmit(
      token: user?.apiToken ?? '',
      productCategoryId: productCategoryId,
      storeID: storeId.toString(),
      displayCheckMark: displayCheckMark,
      teamMemberId: user?.teamMemberID.toString() ?? '',
      checkInImages1: checkInImages1,
      checkInImages2: checkInImages2,
      brandId: brandId,
      visitId: visitId.toString(),
    );

    if (response != null && response["status"] == 200) {
      // Success actions like goBack or fetching summary
      notifyListeners();
    } else {
      debugPrint("auditMediaSubmit Error: ${response?['data']}");
      notifyListeners();
    }
  }

  Future<void> getROSLabels() async {
    loader = true;
    notifyListeners();

    await loadUser();

    // Load from cache first
    await loadROSLabelsFromPrefs();

    try {
      final response = await _storeController.getROSLabels(languageId: '1');
      final response1 = await _storeController.getPermissionRequest(
        teamMemberId: user?.teamMemberID.toString() ?? '',
        token: user?.apiToken.toString() ?? '',
      );

      if (response != null && response1 != null) {
        final dataList = response["data"]['data'];
        final dataList1 = response1["data"]['data'];

        if (dataList is List && dataList1 is List) {
          List<ROSLabel> updatedLabels = [];

          for (var permissionItem in dataList1) {
            final int? permissionId = permissionItem["PermissionID"];
            final String? permissionValue = permissionItem["Permission"];

            if (permissionId != null &&
                permissionId >= 28 &&
                permissionId <= 40 &&
                permissionValue == "Y") {
              final int dataIndex = permissionId - 1;

              if (dataIndex >= 0 && dataIndex < dataList.length) {
                final rosLabelItem = dataList[dataIndex];
                updatedLabels.add(ROSLabel.fromJson(rosLabelItem));
              }
            }
          }

          rosLabels = updatedLabels;
          await saveROSLabelsToPrefs(); // Save to cache

          loader = false;
          notifyListeners();
        }
      } else {
        loader = false;
        notifyListeners();
        debugPrint("Error fetching ROS Labels: ${response?['data']}");
      }
    } catch (e) {
      loader = false;
      notifyListeners();
      debugPrint("Error fetching ROS Labels: $e");
    }
  }

  Future<void> getDisplayCheckMaster({
    required String storeId,
    required String categoryId,
    required String brandId, // ➕ New parameter
  }) async {
    checkMaster = [];
    rightImages = [];
    leftImages = [];
    // loader = true;
    notifyListeners();
    final response = await _storeController.checkDisplayMaster(
      teamMemberId: user?.teamMemberID.toString() ?? '',
      storeId: storeId,
      categoryId: categoryId,
      token: user?.apiToken ?? '',
      brandId: brandId,
    );

    if (response != null && response["status"] == 200) {
      final dataList = response["data"]['data'] as List;

      // Check if dataList has at least 43 items (for index 29 to 42)
      checkMaster =
          dataList.map((item) => DisplayCheckModel.fromJson(item)).toList();
      notifyListeners();
    } else {
      // loader = false;
      notifyListeners();
      debugPrint("Error fetching ROS Labels: ${response?['data']}");
    }
  }

  Future<void> submitDisplayPicture({
    required String storeId,
    required String brandId,
    required String pictureElementId,
    required String remarks,
    required String pictureId,
    required String issueCategoryId,

    required File elementImg,
  }) async {
    loader = true;
    notifyListeners();

    final response = await _storeController.submitDisplayPicture(
      token: user?.apiToken ?? '',
      teamMemberId: user?.teamMemberID.toString() ?? '',
      storeId: storeId.toString(),
      brandId: brandId,
      pictureElementId: pictureElementId,
      remarks: remarks,
      pictureId: pictureId,
      elementImg: leftImage,
      issueCategoryId: issueCategoryId,
    );

    if (response != null && response["status"] == 200) {
      await getPictureView(
        storeId: storeId.toString(),
        brandId: brandId,
        elementId: selectedPictureModel!.pictureElementId.toString(),
      );
      clearDisplayPicture('0');
      // selectedPictureModel = null;
      // selectedBrand = null;
      leftImage = null;
      // loader = false;
      notifyListeners();
    } else {
      selectedPictureModel = null;
      selectedBrand = null;
      leftImage = null;
      debugPrint("auditMediaSubmit Error: ${response?['data']}");
      // loader = false;
      notifyListeners();
    }
  }

  Future<void> getPictureView({
    required String storeId,
    required String brandId,
    required String elementId,
  }) async {
    viewPicture = [];
    loader = true;
    notifyListeners();

    final response = await _storeController.viewPicture(
      token: user?.apiToken ?? '',
      storeId: storeId,
      brandId: brandId,
      elementId: elementId,
    );

    if (response != null && response["status"] == 200) {
      final dataList = response["data"]["data"];

      if (dataList != null && dataList is List && dataList.isNotEmpty) {
        viewPicture =
            dataList
                .map<PictureViewModel>(
                  (data) => PictureViewModel.fromJson(data),
                )
                .toList();
      }

      loader = false;
      notifyListeners();
    } else {
      loader = false;
      notifyListeners();
      debugPrint("Error fetching ROS Labels: ${response?['data']}");
    }
  }

  Future<void> deleteDisplayPicture({
    required String storeId,
    required String pictureId,
    required String pictureName,
  }) async {
    final response = await _storeController.deleteDisplayPicture(
      token: user?.apiToken ?? '',
      storeId: storeId,
      pictureId: pictureId,
      pictureName: pictureName,
    );

    if (response != null && response["status"] == 200) {
      await getPictureView(
        storeId: storeId,
        brandId: selectedBrand?.brandId.toString() ?? '0',
        elementId: selectedPictureModel?.pictureElementId.toString() ?? '1',
      );
      clearDisplayPicture('0');

      notifyListeners();
    } else {
      debugPrint("coverage list Error: ${response?['data']}");
    }
  }

  Future<void> getVisiteId({required String storeId}) async {
    loader = true;
    notifyListeners();
    await loadUser();

    final response = await _storeController.getVisitId(
      token: user?.apiToken ?? '',
      storeId: storeId,
      teamMemberId: user?.teamMemberID.toString() ?? '',
    );

    if (response != null && response["status"] == 200) {
      final data = response["data"]["data"] as List;
      if (data.isNotEmpty) {
        visitId = data.first['VisitID'];
      }
      loader = false;
      notifyListeners();
      print('visit Id:$visitId');

      notifyListeners();
    } else {
      debugPrint("visit Id = Error: ${response?['data']}");
    }
  }

  Future loadDisplayPicture(
    String storeId,
    String brandId,
    String elementId,
  ) async {
    loader = true;
    notifyListeners();
    await loadUser();
    await getBrandDropDown();
    await getPictureDropDown();
    await categoryIssueDropDown();
    await getPictureView(
      storeId: storeId,
      brandId: brandId,
      elementId: elementId,
    );
    loader = false;
    notifyListeners();
  }

  void clearData() {
    leftImage = null;
    rightImage = null;
    leftImageRemoved = false;
    rightImageRemoved = false;

    selectedProducts.clear();
    notifyListeners();
  }

  void clearDisplayPicture(String sId) {
    storeId = sId;
    selectedBrand = null;
    selectedPictureModel = null;
    selectedIssueCategory = null;
    leftImage = null;
    notifyListeners();
  }
}
