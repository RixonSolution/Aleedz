import 'dart:convert';
import 'dart:io';

import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_text_style.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/coverage_details/google_map.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/view/screens/store/store_home.dart';
import 'package:aleedz/view/screens/today_plan/today_plan_view.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchCoverage();
    });
  }

  Future<void> loadUserAndFetchCoverage() async {
    await ref.read(coverageModelProvider.notifier).loadDashboard(context);
  }

  Future<void> showImagePopup({
    required BuildContext context,
    required String title,
    required String checkStatus,
    required String checkStatus1,

    required String checkRemarks,
    required File? imageFile, // 🔹 new parameter

    required void Function(String value) onSubmit,
    required void Function(String value) cancel,
  }) {
    final TextEditingController _controller = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 10,
          ), // Remove default dialog padding
          backgroundColor:
              Colors
                  .transparent, // Make dialog transparent to handle full custom layout
          child: Align(
            alignment: Alignment.center, // Position to top if needed
            child: Material(
              color: AppColors.whiteColor,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16), // Optional internal padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    imageFile != null
                        ? Image.file(
                          imageFile,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.blackColor,
                          ),
                          child: Center(
                            child: Text(
                              'Camera will open and taken image will\nappear here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controller,
                      style: TextStyle(color: AppColors.blackColor),
                      decoration: InputDecoration(
                        hintText: checkRemarks,
                        hintStyle: TextStyle(color: AppColors.blackColor),
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.blackColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.blackColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              onSubmit(_controller.text);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.primary,
                                    width: 4.0,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  checkStatus,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (checkStatus1 != '') SizedBox(width: 5),
                        if (checkStatus1 != '')
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                cancel(_controller.text);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                ),
                                child: Center(
                                  child: Text(
                                    checkStatus1,
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showLocationPopup({
    required BuildContext context,
    required String title,
    required String checkStatus,
    required String meter,
    required double myLat,
    required double myLng,
    required double otherLat,
    required double otherLng,
  }) {
    final TextEditingController _controller = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 10,
          ), // Remove default dialog padding
          backgroundColor:
              Colors
                  .transparent, // Make dialog transparent to handle full custom layout
          child: Align(
            alignment: Alignment.center, // Position to top if needed
            child: Material(
              color: AppColors.whiteColor,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16), // Optional internal padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      height: 300,
                      child: GoogleMapScreen(
                        myLat: myLat,
                        myLang: myLng,
                        otherLat: otherLat,
                        otherLang: otherLng,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${LabelService().getLabel(25)} $meter',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(coverageModelProvider);
    String distancePermission =
        viewModel.permission?.getPermissionValue("LocationLimit") ?? "N";
    String checkInCamera =
        viewModel.permission?.getPermissionValue("CheckIn_Camera") ?? "N";
    String checkoutCamera =
        viewModel.permission?.getPermissionValue("CheckOut_Camera") ?? "N";
    String allowMultiCheckIn =
        viewModel.permission?.getPermissionValue("AllowMultipleCheckIn") ?? "N";
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('dd-MMM-yyyy').format(today);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body:
            viewModel.loader
                ? Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.blackColor,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 70,
                              color: AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${viewModel.user?.teamMemberName ?? ""}',
                                style: const TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${viewModel.user?.teamTypeName ?? ""}',
                                style: const TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${viewModel.user?.divisionName ?? ""}',
                                style: const TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const Divider(color: AppColors.primary, height: 5),
                      const SizedBox(height: 5),

                      // Stats
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                NavigationService.navigateTo(
                                  DashboardView(initialIndex: 1),
                                ); //
                              },
                              child: Container(
                                height: 110,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          AppIcons.coverageNetwork,
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 85,
                                          child: Text(
                                            LabelService().getLabel(11),
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.labelStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${viewModel.storeCount ?? 0}",
                                      style: AppTextStyles.bigTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                NavigationService.navigateTo(TodayPlanView());
                              },
                              child: Container(
                                height: 110,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          AppIcons.toddayPlan,
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 85,
                                          child: Text(
                                            LabelService().getLabel(12),
                                            style: AppTextStyles.labelStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      formattedDate,
                                      style: AppTextStyles.subLabelStyle,
                                    ),
                                    Text(
                                      '${viewModel.visitType1Count}/${viewModel.visitStatus3Count}',
                                      style: AppTextStyles.bigTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      GestureDetector(
                        onTap: () {
                          //
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    '${ApiConstants.baseUrl}/AppImages/StoreMenu_Icons/45.png',
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    LabelService().getLabel(45),
                                    style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '04:12',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      GestureDetector(
                        onTap: () {
                          //
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    '${ApiConstants.baseUrl}/AppImages/StoreMenu_Icons/46.png',
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    LabelService().getLabel(46),
                                    style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '31 KM',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),
                      const SizedBox(height: 5),
                      viewModel.loader
                          ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.secondary,
                            ),
                          )
                          : Flexible(
                            child: ListView.separated(
                              physics: ScrollPhysics(),
                              itemCount: viewModel.dashBoardList.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final visitStatusId =
                                    viewModel
                                        .dashBoardList[index]
                                        .visitStatusId;

                                Widget statusWidget;

                                if (visitStatusId == 1) {
                                  // Plan (Check-in)
                                  statusWidget = InkWell(
                                    onTap: () async {
                                      // Add check-in logic here
                                      if (checkInCamera == 'Y') {
                                        // await viewModel.getLatLong();
                                        double myLat = viewModel.latitude;
                                        double myLng = viewModel.longitude;

                                        double otherLat = double.parse(
                                          viewModel
                                              .dashBoardList[index]
                                              .latitude,
                                        );
                                        double otherLng = double.parse(
                                          viewModel
                                              .dashBoardList[index]
                                              .longitude,
                                        );
                                        print('myLat$myLat myLong$myLng');
                                        print(
                                          'otherLat$otherLat otherLng$otherLng',
                                        );

                                        double distance = viewModel
                                            .calculateDistanceInMeters(
                                              myLat,
                                              myLng,
                                              otherLat,
                                              otherLng,
                                            );

                                        print(
                                          'Distance is ${distance.toStringAsFixed(2)} meters',
                                        );

                                        final picker = ImagePicker();
                                        final pickedFile = await picker
                                            .pickImage(
                                              source: ImageSource.camera,
                                            );

                                        if (pickedFile != null) {
                                          final imageFile = File(
                                            pickedFile.path,
                                          );

                                          showImagePopup(
                                            context: context,
                                            title:
                                                viewModel
                                                    .dashBoardList[index]
                                                    .storeName,
                                            checkStatus:
                                                viewModel
                                                            .dashBoardList[index]
                                                            .visitStatusId ==
                                                        0
                                                    ? LabelService().getLabel(
                                                      14,
                                                    )
                                                    : LabelService().getLabel(
                                                      15,
                                                    ),
                                            checkStatus1: 'Cancel',
                                            checkRemarks:
                                                viewModel
                                                            .dashBoardList[index]
                                                            .visitStatusId ==
                                                        0
                                                    ? LabelService().getLabel(
                                                      21,
                                                    )
                                                    : LabelService().getLabel(
                                                      22,
                                                    ),
                                            onSubmit: (value) async {
                                              if (viewModel
                                                      .dashBoardList[index]
                                                      .visitStatusId ==
                                                  0) {
                                                viewModel.coverageCheckIn(
                                                  context,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .storeId,
                                                  remarks: value,
                                                  checkInImgFile: imageFile,
                                                );
                                              } else {
                                                viewModel.coverageCheckout(
                                                  context,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .visitStatusId,
                                                  remarks: value,
                                                  checkOutImgFile: imageFile,
                                                );
                                              }
                                            },
                                            cancel: (value) async {
                                              viewModel.cancelVisite(
                                                context,
                                                viewModel
                                                    .dashBoardList[index]
                                                    .storeId,
                                                remarks: value,
                                              );
                                            },
                                            imageFile:
                                                imageFile, // 🔹 pass the image to dialog
                                          );
                                        }
                                      } else {
                                        AppSnackBar.showError(
                                          context,
                                          "You don't have camera permission.",
                                        );
                                      }
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LabelService().getLabel(14),
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (visitStatusId == 2) {
                                  // Checkout process
                                  statusWidget = InkWell(
                                    onTap: () async {
                                      // Add checkout logic here
                                      if (checkoutCamera == 'Y') {
                                        // await viewModel.getLatLong();
                                        double myLat = viewModel.latitude;
                                        double myLng = viewModel.longitude;

                                        double otherLat = double.parse(
                                          viewModel
                                              .dashBoardList[index]
                                              .latitude,
                                        );
                                        double otherLng = double.parse(
                                          viewModel
                                              .dashBoardList[index]
                                              .longitude,
                                        );

                                        print('myLat$myLat myLong$myLng');
                                        print(
                                          'otherLat$otherLat otherLng$otherLng',
                                        );

                                        double distance = viewModel
                                            .calculateDistanceInMeters(
                                              myLat,
                                              myLng,
                                              otherLat,
                                              otherLng,
                                            );

                                        print(
                                          'Distance is ${distance.toStringAsFixed(2)} meters',
                                        );

                                        if (distance >
                                            double.parse(distancePermission)) {
                                          showLocationPopup(
                                            context: context,
                                            title:
                                                viewModel
                                                    .dashBoardList[index]
                                                    .storeName,
                                            checkStatus:
                                                viewModel
                                                            .dashBoardList[index]
                                                            .visitStatusId ==
                                                        0
                                                    ? LabelService().getLabel(
                                                      14,
                                                    )
                                                    : LabelService().getLabel(
                                                      15,
                                                    ),
                                            meter: distance.toStringAsFixed(2),
                                            myLat: myLat,
                                            myLng: myLng,
                                            otherLat: otherLat,
                                            otherLng: otherLng,
                                          );
                                        } else {
                                          final picker = ImagePicker();
                                          final pickedFile = await picker
                                              .pickImage(
                                                source: ImageSource.camera,
                                              );

                                          if (pickedFile != null) {
                                            final imageFile = File(
                                              pickedFile.path,
                                            );
                                            List<int> imageBytes =
                                                File(
                                                  pickedFile.path,
                                                ).readAsBytesSync();

                                            String base64Image = base64Encode(
                                              imageBytes,
                                            );

                                            showImagePopup(
                                              context: context,
                                              title:
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .storeName,
                                              checkStatus:
                                                  viewModel
                                                              .dashBoardList[index]
                                                              .visitStatusId ==
                                                          0
                                                      ? LabelService().getLabel(
                                                        14,
                                                      )
                                                      : LabelService().getLabel(
                                                        15,
                                                      ),
                                              checkStatus1: '',
                                              checkRemarks:
                                                  viewModel
                                                              .dashBoardList[index]
                                                              .visitStatusId ==
                                                          0
                                                      ? LabelService().getLabel(
                                                        21,
                                                      )
                                                      : LabelService().getLabel(
                                                        22,
                                                      ),
                                              onSubmit: (value) {
                                                if (viewModel
                                                        .dashBoardList[index]
                                                        .visitStatusId ==
                                                    0) {
                                                  viewModel.coverageCheckIn(
                                                    context,
                                                    viewModel
                                                        .dashBoardList[index]
                                                        .storeId,
                                                    remarks: value,
                                                    checkInImgFile:
                                                        imageFile, // ✅ Required parameter now
                                                  );
                                                } else {
                                                  viewModel.coverageCheckout(
                                                    context,
                                                    viewModel
                                                        .dashBoardList[index]
                                                        .visitStatusId,
                                                    remarks: value,
                                                    checkOutImgFile: imageFile,
                                                  );
                                                }
                                              },
                                              cancel: (value) async {
                                                viewModel.cancelVisite(
                                                  context,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .storeId,
                                                  remarks: value,
                                                );
                                              },

                                              imageFile:
                                                  imageFile, // 🔹 pass the image to dialog
                                            );
                                          }
                                        }
                                      } else {
                                        AppSnackBar.showError(
                                          context,
                                          "You don't have camera permission.",
                                        );
                                      }
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${LabelService().getLabel(14)} : ${viewModel.dashBoardList[index].checkInTime}',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          LabelService().getLabel(15),
                                          style: TextStyle(
                                            color: AppColors.secondary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (visitStatusId == 3) {
                                  // Visited
                                  statusWidget = Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Visited',
                                        style: TextStyle(
                                          color: AppColors.secondary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (visitStatusId == 4) {
                                  // Cancelled
                                  statusWidget = Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cancelled',
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  // Fallback for unknown statuses
                                  statusWidget = Text('Unknown Status');
                                }

                                return Column(
                                  children: [
                                    Container(
                                      color:
                                          viewModel
                                                      .dashBoardList[index]
                                                      .visitStatusId ==
                                                  3
                                              ? AppColors.darkGreyBackground
                                              : AppColors.whiteColor,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 15,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            child: Text(
                                              '${index + 1}.',
                                              style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                final allowMultiCheckIn =
                                                    viewModel.permission
                                                        ?.getPermissionValue(
                                                          'AllowMultipleCheckIn',
                                                        );
                                                final allowStoreInWithoutCheckIn =
                                                    viewModel.permission
                                                        ?.getPermissionValue(
                                                          'Allow_StoreIn_WithoutCheckIn',
                                                        );

                                                final selectedStore =
                                                    viewModel
                                                        .dashBoardList[index];

                                                // 1. Check: StoreIn not allowed without check-in
                                                if (allowStoreInWithoutCheckIn ==
                                                        'N' &&
                                                    selectedStore
                                                            .visitStatusId ==
                                                        0) {
                                                  AppSnackBar.showError(
                                                    context,
                                                    "You must check in before entering the store.",
                                                  );
                                                  return;
                                                }

                                                // 2. If multi-check-in allowed, allow navigation
                                                if (allowMultiCheckIn == 'Y') {
                                                  NavigationService.navigateTo(
                                                    StoreHome(
                                                      storeName:
                                                          selectedStore
                                                              .storeName,
                                                      checkInTime:
                                                          selectedStore
                                                              .checkInTime,
                                                      grade: 'A',
                                                      address:
                                                          selectedStore.address,
                                                      storeId:
                                                          selectedStore.storeId,
                                                    ),
                                                  );
                                                  return;
                                                }

                                                // 3. If multi-check-in not allowed, check if user is already checked into another store
                                                final isAlreadyCheckedIn =
                                                    viewModel.stores.any(
                                                      (store) =>
                                                          store.visitStatusId !=
                                                              0 &&
                                                          store.storeId !=
                                                              selectedStore
                                                                  .storeId,
                                                    );

                                                if (isAlreadyCheckedIn) {
                                                  AppSnackBar.showError(
                                                    context,
                                                    "You are already checked in to another store. Multiple check-ins are not allowed.",
                                                  );
                                                  return;
                                                }

                                                // ✅ All good, navigate
                                                NavigationService.navigateTo(
                                                  StoreHome(
                                                    storeName:
                                                        selectedStore.storeName,
                                                    checkInTime:
                                                        selectedStore
                                                            .checkInTime,
                                                    grade: 'A',
                                                    address:
                                                        selectedStore.address,
                                                    storeId:
                                                        selectedStore.storeId,
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 5,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      viewModel
                                                          .dashBoardList[index]
                                                          .storeName,
                                                      style: TextStyle(
                                                        color:
                                                            AppColors
                                                                .blackColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(height: 3),
                                                    Text(
                                                      viewModel
                                                          .dashBoardList[index]
                                                          .address,
                                                      style: TextStyle(
                                                        color:
                                                            AppColors
                                                                .blackColor,
                                                        fontSize: 13,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${viewModel.dashBoardList[index].planDate}',
                                                          style: TextStyle(
                                                            color:
                                                                AppColors
                                                                    .blackColor,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          statusWidget,
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (context, index) => Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    color: Colors.grey,
                                    height: 1,
                                  ),
                            ),
                          ),
                    ],
                  ),
                ),
      ),
    );
  }
}
