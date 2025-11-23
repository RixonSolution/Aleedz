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
import 'package:aleedz/view/screens/open_issues/open_issues_view.dart';
import 'package:aleedz/view/screens/store/store_home.dart';
import 'package:aleedz/view/screens/today_plan/today_plan_view.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
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
    await ref.read(storeModelProvider).getROSLabels();
    final notifier = ref.read(storeModelProvider.notifier);
    await notifier.loadROSLabelsFromPrefs();
  }

  Future<void> showImagePopup({
    required BuildContext context,
    required String title,
    required String checkStatus,
    required String checkStatus1,
    required String checkRemarks,
    required File? imageFile,
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
            horizontal: 0,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.close, color: AppColors.secondary),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 8,
                            ),
                            child: Center(
                              child: Text(
                                checkStatus,
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        DateFormat('hh:mm a').format(DateTime.now()),
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    imageFile != null
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Image.file(
                            imageFile,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                        : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),

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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      child: TextField(
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
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
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

                          // if (checkStatus1 != '') SizedBox(width: 5),
                          // if (checkRemarks == 'Check In Remarks')
                          //   Expanded(
                          //     child: InkWell(
                          //       onTap: () {
                          //         Navigator.pop(context);
                          //         cancel(_controller.text);
                          //       },
                          //       child: Container(
                          //         padding: EdgeInsets.symmetric(vertical: 15),
                          //         decoration: BoxDecoration(
                          //           color: AppColors.error,
                          //         ),
                          //         child: Center(
                          //           child: Text(
                          //             checkStatus1,
                          //             style: TextStyle(
                          //               color: AppColors.whiteColor,
                          //               fontSize: 14,
                          //               fontWeight: FontWeight.w600,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                        ],
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

  Future<void> showCancelPopup({
    required BuildContext context,
    required String title,
    required void Function(String value) cancel,
  }) {
    final TextEditingController _controller = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 0,
          ), // Remove default dialog padding
          backgroundColor:
              Colors
                  .transparent, // Make dialog transparent to handle full custom layout
          child: Align(
            alignment: Alignment.center, // Position to top if needed
            child: Material(
              color: AppColors.secondary,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.close, color: AppColors.secondary),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 8,
                            ),
                            child: Center(
                              child: Text(
                                LabelService().getLabel(102),
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 10),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: Text(
                    //     title,
                    //     style: TextStyle(
                    //       color: AppColors.whiteColor,
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        LabelService().getLabel(55),
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: AppColors.whiteColor),
                        decoration: InputDecoration(
                          hintText: LabelService().getLabel(103),
                          hintStyle: TextStyle(color: AppColors.whiteColor),
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.whiteColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.whiteColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(),
                              child: Center(
                                child: Text(
                                  LabelService().getLabel(94),
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              if (_controller.text.isEmpty) {
                                AppSnackBar.showError(
                                  context,
                                  LabelService().getLabel(103),
                                );
                              } else {
                                Navigator.pop(context);
                                cancel(_controller.text);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(),
                              child: Center(
                                child: Text(
                                  LabelService().getLabel(95),
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
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
    required String checkStatus1,

    required void Function(String value) cancel,
  }) {
    final TextEditingController _controller = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 0,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.close, color: AppColors.secondary),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 8,
                            ),
                            child: Center(
                              child: Text(
                                checkStatus,
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        DateFormat('hh:mm a').format(DateTime.now()),
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 300,
                      child: GoogleMapScreen(
                        myLat: myLat,
                        myLang: myLng,
                        otherLat: otherLat,
                        otherLang: otherLng,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${LabelService().getLabel(25)} $meter',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // const SizedBox(height: 10),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     cancel(_controller.text);
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(vertical: 15),
                    //     decoration: BoxDecoration(color: AppColors.error),
                    //     child: Center(
                    //       child: Text(
                    //         checkStatus1,
                    //         style: TextStyle(
                    //           color: AppColors.whiteColor,
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _statusChip({
    required String label,
    required Color bgColor,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    if (onTap == null) return chip;
    return InkWell(onTap: onTap, child: chip);
  }

  Future<void> _handleCheckIn(
    BuildContext context,
    CoverageViewModel viewModel,
    int index,
    String distancePermission,
    String checkInCamera,
  ) async {
    if (checkInCamera == 'Y') {
      final myLat = viewModel.latitude;
      final myLng = viewModel.longitude;

      final otherLat = double.parse(viewModel.dashBoardList[index].latitude);
      final otherLng = double.parse(viewModel.dashBoardList[index].longitude);

      final isOtherLocationEmpty = otherLat == 0.0 && otherLng == 0.0;
      final distance = viewModel.calculateDistanceInMeters(
        myLat,
        myLng,
        otherLat,
        otherLng,
      );

      if (isOtherLocationEmpty || distance < double.parse(distancePermission)) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          final imageFile = File(pickedFile.path);

          showImagePopup(
            context: context,
            title: viewModel.dashBoardList[index].storeName,
            checkStatus:
                viewModel.dashBoardList[index].visitStatusId == 1
                    ? LabelService().getLabel(14)
                    : LabelService().getLabel(15),
            checkStatus1: LabelService().getLabel(102),
            checkRemarks:
                viewModel.dashBoardList[index].visitStatusId == 1
                    ? LabelService().getLabel(21)
                    : LabelService().getLabel(22),
            onSubmit: (value) async {
              await viewModel.dashboardCheckIn(
                context,
                viewModel.dashBoardList[index].visitId,
                remarks: value,
                checkInImgFile: imageFile,
              );
              NavigationService.navigateTo(
                StoreHome(
                  storeName: viewModel.dashBoardList[index].storeName,
                  checkInTime: viewModel.dashBoardList[index].checkInTime,
                  grade: viewModel.dashBoardList[index].gradeName,
                  address: viewModel.dashBoardList[index].address,
                  storeId: viewModel.dashBoardList[index].storeId,
                ),
              );
            },
            cancel: (value) async {
              viewModel.cancelVisite(
                context,
                viewModel.dashBoardList[index].storeId,
                viewModel.dashBoardList[index].visitId,
                remarks: value,
              );
            },
            imageFile: imageFile,
          );
        }
      } else if (distance > double.parse(distancePermission)) {
        showLocationPopup(
          context: context,
          title: viewModel.dashBoardList[index].storeName,
          checkStatus: LabelService().getLabel(14),
          meter: distance.toStringAsFixed(2),
          myLat: myLat,
          myLng: myLng,
          otherLat: otherLat,
          otherLng: otherLng,
          checkStatus1: LabelService().getLabel(102),
          cancel: (value) async {
            viewModel.cancelVisite(
              context,
              viewModel.dashBoardList[index].storeId,
              viewModel.dashBoardList[index].visitId,
              remarks: value,
            );
          },
        );
      }
    } else {
      await viewModel.dashboardCheckIn(
        context,
        viewModel.dashBoardList[index].visitId,
        remarks: '',
      );
      NavigationService.navigateTo(
        StoreHome(
          storeName: viewModel.dashBoardList[index].storeName,
          checkInTime: viewModel.dashBoardList[index].checkInTime,
          grade: viewModel.dashBoardList[index].gradeName,
          address: viewModel.dashBoardList[index].address,
          storeId: viewModel.dashBoardList[index].storeId,
        ),
      );
    }
  }

  Future<void> _handleCheckOut(
    BuildContext context,
    CoverageViewModel viewModel,
    int index,
    String distancePermission,
    String checkoutCamera,
  ) async {
    if (checkoutCamera == 'Y') {
      final myLat = viewModel.latitude;
      final myLng = viewModel.longitude;

      final otherLat = double.parse(viewModel.dashBoardList[index].latitude);
      final otherLng = double.parse(viewModel.dashBoardList[index].longitude);

      final isOtherLocationEmpty = otherLat == 0.0 && otherLng == 0.0;
      final distance = viewModel.calculateDistanceInMeters(
        myLat,
        myLng,
        otherLat,
        otherLng,
      );

      if (isOtherLocationEmpty || distance < double.parse(distancePermission)) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          final imageFile = File(pickedFile.path);

          showImagePopup(
            context: context,
            title: viewModel.dashBoardList[index].storeName,
            checkStatus:
                viewModel.dashBoardList[index].visitStatusId == 1
                    ? LabelService().getLabel(14)
                    : LabelService().getLabel(15),
            checkStatus1: '',
            checkRemarks:
                viewModel.dashBoardList[index].visitStatusId == 1
                    ? LabelService().getLabel(21)
                    : LabelService().getLabel(22),
            onSubmit: (value) {
              viewModel.coverageCheckout(
                context,
                viewModel.dashBoardList[index].visitId,
                remarks: value,
                checkOutImgFile: imageFile,
              );
            },
            cancel: (value) async {
              viewModel.cancelVisite(
                context,
                viewModel.dashBoardList[index].storeId,
                viewModel.dashBoardList[index].visitId,
                remarks: value,
              );
            },
            imageFile: imageFile,
          );
        }
      } else if (distance > double.parse(distancePermission)) {
        showLocationPopup(
          context: context,
          title: viewModel.dashBoardList[index].storeName,
          checkStatus: LabelService().getLabel(15),
          meter: distance.toStringAsFixed(2),
          myLat: myLat,
          myLng: myLng,
          otherLat: otherLat,
          otherLng: otherLng,
          checkStatus1: LabelService().getLabel(102),
          cancel: (value) async {
            viewModel.cancelVisite(
              context,
              viewModel.dashBoardList[index].storeId,
              viewModel.dashBoardList[index].visitId,
              remarks: value,
            );
          },
        );
      }
    } else {
      viewModel.coverageCheckout(
        context,
        viewModel.dashBoardList[index].visitId,
        remarks: '',
      );
    }
  }

  String _initialsFromName(String name) {
    if (name.trim().isEmpty) return 'NA';
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
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

    String allowWithoutCheckIn =
        viewModel.permission?.getPermissionValue(
          "Allow_StoreIn_WithoutCheckIn",
        ) ??
        "N";

    DateTime today = DateTime.now();
    String formattedDate = DateFormat('dd-MMM-yyyy').format(today);
    // print('distancePermission$distancePermission');

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body:
            viewModel.loader
                ? Center(child: CircularProgressIndicator())
                : Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1f2937), Color(0xFF0f172a)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _initialsFromName(
                                        viewModel.user?.teamMemberName ?? '',
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${viewModel.user?.teamMemberName ?? ""}',
                                        style: const TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${viewModel.user?.teamTypeName ?? ""}',
                                        style: const TextStyle(
                                          color: Color(0xFFd1d5db),
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${viewModel.user?.divisionName ?? ""}',
                                        style: const TextStyle(
                                          color: Color(0xFF9ca3af),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      NavigationService.navigateTo(
                                        DashboardView(initialIndex: 1),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.12),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.public,
                                                color: AppColors.primary,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                LabelService().getLabel(11),
                                                style: const TextStyle(
                                                  color: Color(0xFFfbbf24),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "${viewModel.storeCount ?? 0}",
                                            style: const TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          const Text(
                                            "Total Stores",
                                            style: TextStyle(
                                              color: Color(0xFF9ca3af),
                                              fontSize: 11,
                                            ),
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
                                      NavigationService.navigateTo(
                                        TodayPlanView(),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.12),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.event_note,
                                                color: Color(0xFF60a5fa),
                                                size: 18,
                                              ),
                                              const SizedBox(width: 6),
                                              const Text(
                                                "Today's Plan",
                                                style: TextStyle(
                                                  color: Color(0xFF60a5fa),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "${viewModel.userVisited}/${viewModel.userPlan}",
                                            style: const TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          const Text(
                                            "Visits Completed",
                                            style: TextStyle(
                                              color: Color(0xFF9ca3af),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Transform.translate(
                          offset: const Offset(0, -18),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 44,
                                        width: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF7ED),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.access_time,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            viewModel.storeTimeSpend.toString(),
                                            style: const TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Time in Store',
                                            style: TextStyle(
                                              color: AppColors.greyText,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 44,
                                        width: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEEF2FF),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.map_outlined,
                                          color: Color(0xFF2563EB),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            viewModel.storeTotalTravel
                                                .toString(),
                                            style: const TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Total Travel',
                                            style: TextStyle(
                                              color: AppColors.greyText,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 6,
                              ),
                              child: Text(
                                "Today's Journey",
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (viewModel.dashBoardList.isEmpty) {
                                  AppSnackBar.showError(
                                    context,
                                    LabelService().getLabel(122),
                                  );
                                } else {
                                  NavigationService.navigateTo(TodayPlanView());
                                }
                              },
                              child: Text(
                                'View All',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
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
                              padding: EdgeInsets.only(
                                bottom: 12,
                                left: 12,
                                right: 12,
                              ),
                              itemBuilder: (context, index) {
                                final store = viewModel.dashBoardList[index];
                                final visitStatusId = store.visitStatusId;

                                Color cardBg = AppColors.whiteColor;
                                Color borderColor = Colors.grey.shade200;
                                double cardOpacity = 1;
                                Color badgeBg = AppColors.secondary.withOpacity(
                                  0.08,
                                );
                                Color badgeTextColor = AppColors.secondary;
                                Color numberBg = AppColors.secondary;
                                Color numberText = AppColors.whiteColor;
                                String badgeLabel =
                                    store.visitStatus.isNotEmpty
                                        ? store.visitStatus
                                        : 'Plan';
                                String trailingText =
                                    'Plan Date: ${store.planDate}';
                                Color trailingColor = AppColors.greyText;
                                VoidCallback? statusTap;

                                if (visitStatusId == 1) {
                                  statusTap =
                                      () => _handleCheckIn(
                                        context,
                                        viewModel,
                                        index,
                                        distancePermission,
                                        checkInCamera,
                                      );
                                } else if (visitStatusId == 2) {
                                  cardBg = AppColors.primary.withOpacity(0.08);
                                  borderColor = AppColors.primary;
                                  badgeBg = AppColors.primary;
                                  badgeTextColor = AppColors.whiteColor;
                                  badgeLabel = LabelService().getLabel(15);
                                  numberBg = AppColors.primary;
                                  numberText = AppColors.whiteColor;
                                  trailingText =
                                      'In: ${store.checkInTime.isEmpty ? '--' : store.checkInTime}';
                                  trailingColor = AppColors.primary;
                                  statusTap =
                                      () => _handleCheckOut(
                                        context,
                                        viewModel,
                                        index,
                                        distancePermission,
                                        checkoutCamera,
                                      );
                                } else if (visitStatusId == 3) {
                                  badgeBg = AppColors.success.withOpacity(0.12);
                                  badgeTextColor = AppColors.success;
                                  badgeLabel =
                                      store.visitStatus.isNotEmpty
                                          ? store.visitStatus
                                          : 'Visited';
                                  numberBg = AppColors.success;
                                  numberText = AppColors.whiteColor;
                                  trailingText =
                                      'In: ${store.checkInTime} - Out: ${store.checkOutTime}';
                                } else if (visitStatusId == 4) {
                                  badgeBg = AppColors.error.withOpacity(0.12);
                                  badgeTextColor = AppColors.error;
                                  badgeLabel =
                                      store.visitStatus.isNotEmpty
                                          ? store.visitStatus
                                          : 'Cancelled';
                                  numberBg = AppColors.error;
                                  numberText = AppColors.whiteColor;
                                  cardOpacity = 0.55;
                                  trailingText = '';
                                }

                                final statusBadge = _statusChip(
                                  label: badgeLabel,
                                  bgColor: badgeBg,
                                  textColor: badgeTextColor,
                                  onTap: statusTap,
                                );

                                return Opacity(
                                  opacity: cardOpacity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cardBg,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: borderColor),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 44,
                                          width: 44,
                                          decoration: BoxDecoration(
                                            color: numberBg,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                color: numberText,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: GestureDetector(
                                            onLongPress: () async {
                                              if (visitStatusId == 1) {
                                                showCancelPopup(
                                                  context: context,
                                                  title: store.storeName,
                                                  cancel: (value) async {
                                                    viewModel.cancelVisite(
                                                      context,
                                                      store.storeId,
                                                      store.visitId,
                                                      remarks: value,
                                                    );
                                                  },
                                                );
                                              }
                                            },
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

                                              final selectedStore = store;

                                              if (allowStoreInWithoutCheckIn ==
                                                      'N' &&
                                                  selectedStore.visitStatusId ==
                                                      1) {
                                                AppSnackBar.showError(
                                                  context,
                                                  LabelService().getLabel(105),
                                                );
                                                return;
                                              }

                                              if (allowMultiCheckIn == 'Y' &&
                                                  visitStatusId == 2) {
                                                NavigationService.navigateTo(
                                                  StoreHome(
                                                    storeName:
                                                        selectedStore.storeName,
                                                    checkInTime:
                                                        selectedStore
                                                            .checkInTime,
                                                    grade:
                                                        selectedStore.gradeName,
                                                    address:
                                                        selectedStore.address,
                                                    storeId:
                                                        selectedStore.storeId,
                                                  ),
                                                );
                                                return;
                                              }

                                              final isAlreadyCheckedIn =
                                                  viewModel.stores.any(
                                                    (storeItem) =>
                                                        storeItem
                                                                .visitStatusId !=
                                                            0 &&
                                                        storeItem.storeId !=
                                                            selectedStore
                                                                .storeId,
                                                  );

                                              if (isAlreadyCheckedIn) {
                                                AppSnackBar.showError(
                                                  context,
                                                  LabelService().getLabel(106),
                                                );
                                                return;
                                              }
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  store.storeName,
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  store.address,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: AppColors.greyText,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Row(children: [statusBadge]),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (trailingText.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 6,
                                                ),
                                                child: Text(
                                                  trailingText,
                                                  style: TextStyle(
                                                    color: trailingColor,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            Icon(
                                              Icons.chevron_right,
                                              color: Colors.grey.shade400,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (context, index) => SizedBox(height: 10),
                            ),
                          ),
                    ],
                  ),
                ),
      ),
    );
  }
}
