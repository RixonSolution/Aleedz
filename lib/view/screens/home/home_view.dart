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
                                'Cancel',
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
                          hintText: 'Cancel Remarks',
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
                                  'No',
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
                                  "Please enter your cancel remarks.",
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
                                  'Yes',
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                NavigationService.navigateTo(
                                  OpenIssuesScreen(),
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
                                          AppIcons.toddayPlan,
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 85,
                                          child: Text(
                                            LabelService().getLabel(80),
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.labelStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${viewModel.openIssueCount ?? 0}",
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
                                    height: 30,
                                    width: 30,
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
                                viewModel.storeTimeSpend.toString(),
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
                                    height: 30,
                                    width: 30,
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
                                viewModel.storeTotalTravel.toString(),
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
                      const SizedBox(height: 10),

                      GestureDetector(
                        onTap: () {
                          if (viewModel.dashBoardList.isEmpty) {
                            AppSnackBar.showError(
                              context,
                              "No journeys are planned for today.",
                            );
                          } else {
                            NavigationService.navigateTo(TodayPlanView());
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreyBackground,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LabelService().getLabel(51),
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(
                                '(${viewModel.userVisited}/${viewModel.userPlan})',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Divider(color: AppColors.primary, height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8,
                              top: 5,
                              bottom: 5,
                            ),
                            child: Text(
                              'Long press on the row to cancel the check-in record.',
                              style: TextStyle(
                                color: AppColors.greyText,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
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

                                        print('myLat $myLat, myLong $myLng');
                                        print(
                                          'otherLat $otherLat, otherLng $otherLng',
                                        );

                                        bool isOtherLocationEmpty =
                                            otherLat == 0.0 && otherLng == 0.0;

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

                                        // If otherLat/otherLng are 0.0 — directly proceed to camera

                                        if (isOtherLocationEmpty) {
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
                                                          1
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
                                                          1
                                                      ? LabelService().getLabel(
                                                        21,
                                                      )
                                                      : LabelService().getLabel(
                                                        22,
                                                      ),
                                              onSubmit: (value) async {
                                                {
                                                  await viewModel
                                                      .dashboardCheckIn(
                                                        context,
                                                        viewModel
                                                            .dashBoardList[index]
                                                            .visitId,
                                                        remarks: value,
                                                        checkInImgFile:
                                                            imageFile,
                                                      );
                                                  NavigationService.navigateTo(
                                                    StoreHome(
                                                      storeName:
                                                          viewModel
                                                              .dashBoardList[index]
                                                              .storeName,
                                                      checkInTime:
                                                          viewModel
                                                              .dashBoardList[index]
                                                              .checkInTime,
                                                      grade:
                                                          viewModel
                                                              .dashBoardList[index]
                                                              .gradeName,

                                                      address:
                                                          viewModel
                                                              .dashBoardList[index]
                                                              .address,
                                                      storeId:
                                                          viewModel
                                                              .dashBoardList[index]
                                                              .storeId,
                                                    ),
                                                  );
                                                }
                                              },
                                              cancel: (value) async {
                                                viewModel.cancelVisite(
                                                  context,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .storeId,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .visitId,
                                                  remarks: value,
                                                );
                                              },
                                              imageFile:
                                                  imageFile, // 🔹 pass the image to dialog
                                            );
                                          }
                                        } else if (distance <
                                            double.parse(distancePermission)) {
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
                                                          1
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
                                                          1
                                                      ? LabelService().getLabel(
                                                        21,
                                                      )
                                                      : LabelService().getLabel(
                                                        22,
                                                      ),
                                              onSubmit: (value) async {
                                                {
                                                  await viewModel
                                                      .dashboardCheckIn(
                                                        context,
                                                        viewModel
                                                            .dashBoardList[index]
                                                            .visitId,
                                                        remarks: value,
                                                        checkInImgFile:
                                                            imageFile,
                                                      );
                                                  NavigationService.navigateTo(
                                                    StoreHome(
                                                      storeName:
                                                          viewModel
                                                              .dashBoardList[index]
                                                              .storeName,
                                                      checkInTime:
                                                          viewModel
                                                              .dashBoardList[index]
                                                              .checkInTime,
                                                      grade:
                                                          viewModel
                                                              .dashBoardList[index]
                                                              .gradeName,
                                                      address:
                                                          viewModel
                                                              .dashBoardList[index]
                                                              .address,
                                                      storeId:
                                                          viewModel
                                                              .dashBoardList[index]
                                                              .storeId,
                                                    ),
                                                  );
                                                }
                                              },
                                              cancel: (value) async {
                                                viewModel.cancelVisite(
                                                  context,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .storeId,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .visitId,
                                                  remarks: value,
                                                );
                                              },
                                              imageFile:
                                                  imageFile, // 🔹 pass the image to dialog
                                            );
                                          }
                                        } else if (distance >
                                            double.parse(distancePermission)) {
                                          showLocationPopup(
                                            context: context,
                                            title:
                                                viewModel
                                                    .dashBoardList[index]
                                                    .storeName,
                                            checkStatus: LabelService()
                                                .getLabel(14),

                                            meter: distance.toStringAsFixed(2),
                                            myLat: myLat,
                                            myLng: myLng,
                                            otherLat: otherLat,
                                            otherLng: otherLng,
                                            checkStatus1: 'Cancel',
                                            cancel: (value) async {
                                              viewModel.cancelVisite(
                                                context,
                                                viewModel
                                                    .dashBoardList[index]
                                                    .storeId,
                                                viewModel
                                                    .dashBoardList[index]
                                                    .visitId,
                                                remarks: value,
                                              );
                                            },
                                          );
                                        }
                                      } else {
                                        {
                                          await viewModel.dashboardCheckIn(
                                            context,
                                            viewModel
                                                .dashBoardList[index]
                                                .visitId,
                                            remarks: '',
                                          );
                                          NavigationService.navigateTo(
                                            StoreHome(
                                              storeName:
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .storeName,
                                              checkInTime:
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .checkInTime,
                                              grade:
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .gradeName,

                                              address:
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .address,
                                              storeId:
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .storeId,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Check In ',
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

                                        bool isOtherLocationEmpty =
                                            otherLat == 0.0 && otherLng == 0.0;

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

                                        if (isOtherLocationEmpty) {
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
                                                          1
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
                                                          1
                                                      ? LabelService().getLabel(
                                                        21,
                                                      )
                                                      : LabelService().getLabel(
                                                        22,
                                                      ),
                                              onSubmit: (value) {
                                                viewModel.coverageCheckout(
                                                  context,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .visitId,
                                                  remarks: value,
                                                  checkOutImgFile: imageFile,
                                                );
                                              },
                                              cancel: (value) async {
                                                viewModel.cancelVisite(
                                                  context,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .storeId,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .visitId,
                                                  remarks: value,
                                                );
                                              },

                                              imageFile:
                                                  imageFile, // 🔹 pass the image to dialog
                                            );
                                          }
                                        } else if (distance >
                                            double.parse(distancePermission)) {
                                          showLocationPopup(
                                            context: context,
                                            title:
                                                viewModel
                                                    .dashBoardList[index]
                                                    .storeName,
                                            checkStatus: LabelService()
                                                .getLabel(15),
                                            meter: distance.toStringAsFixed(2),
                                            myLat: myLat,
                                            myLng: myLng,
                                            otherLat: otherLat,
                                            otherLng: otherLng,
                                            checkStatus1: 'Cancel',
                                            cancel: (value) async {
                                              viewModel.cancelVisite(
                                                context,
                                                viewModel
                                                    .dashBoardList[index]
                                                    .storeId,
                                                viewModel
                                                    .dashBoardList[index]
                                                    .visitId,
                                                remarks: value,
                                              );
                                            },
                                          );
                                        } else if (distance <
                                            double.parse(distancePermission)) {
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
                                                          1
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
                                                          1
                                                      ? LabelService().getLabel(
                                                        21,
                                                      )
                                                      : LabelService().getLabel(
                                                        22,
                                                      ),
                                              onSubmit: (value) {
                                                viewModel.coverageCheckout(
                                                  context,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .visitId,
                                                  remarks: value,
                                                  checkOutImgFile: imageFile,
                                                );
                                              },
                                              cancel: (value) async {
                                                viewModel.cancelVisite(
                                                  context,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .storeId,
                                                  viewModel
                                                      .dashBoardList[index]
                                                      .visitId,
                                                  remarks: value,
                                                );
                                              },

                                              imageFile:
                                                  imageFile, // 🔹 pass the image to dialog
                                            );
                                          }
                                        }
                                      } else {
                                        viewModel.coverageCheckout(
                                          context,
                                          viewModel
                                              .dashBoardList[index]
                                              .visitId,
                                          remarks: '',
                                        );
                                        // AppSnackBar.showError(
                                        //   context,
                                        //   "You don't have camera permission.",
                                        // );
                                      }
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                        'Visited ',
                                        style: TextStyle(
                                          color: AppColors.success,
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
                                        'Cancelled ',
                                        style: TextStyle(
                                          color: AppColors.error,
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
                                        horizontal: 0,
                                        vertical: 12,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 0,
                                      ),
                                      child: Stack(
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
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                    ),
                                                child: Text(
                                                  '${index + 1}.',
                                                  style: TextStyle(
                                                    color: Colors.transparent,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onLongPress: () async {
                                                    if (visitStatusId == 1) {
                                                      showCancelPopup(
                                                        context: context,
                                                        title:
                                                            viewModel
                                                                .dashBoardList[index]
                                                                .storeName,

                                                        cancel: (value) async {
                                                          viewModel.cancelVisite(
                                                            context,
                                                            viewModel
                                                                .dashBoardList[index]
                                                                .storeId,
                                                            viewModel
                                                                .dashBoardList[index]
                                                                .visitId,
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

                                                    final selectedStore =
                                                        viewModel
                                                            .dashBoardList[index];

                                                    // 1. Check: StoreIn not allowed without check-in
                                                    if (allowStoreInWithoutCheckIn ==
                                                            'N' &&
                                                        selectedStore
                                                                .visitStatusId ==
                                                            1) {
                                                      AppSnackBar.showError(
                                                        context,
                                                        "You must check in before entering the store.",
                                                      );
                                                      return;
                                                    }

                                                    // 2. If multi-check-in allowed, allow navigation
                                                    if (allowMultiCheckIn ==
                                                            'Y' &&
                                                        visitStatusId == 2) {
                                                      NavigationService.navigateTo(
                                                        StoreHome(
                                                          storeName:
                                                              selectedStore
                                                                  .storeName,
                                                          checkInTime:
                                                              selectedStore
                                                                  .checkInTime,
                                                          grade:
                                                              viewModel
                                                                  .dashBoardList[index]
                                                                  .gradeName,
                                                          address:
                                                              selectedStore
                                                                  .address,
                                                          storeId:
                                                              selectedStore
                                                                  .storeId,
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
                                                    // NavigationService.navigateTo(
                                                    //   StoreHome(
                                                    //     storeName:
                                                    //         selectedStore
                                                    //             .storeName,
                                                    //     checkInTime:
                                                    //         selectedStore
                                                    //             .checkInTime,
                                                    //     grade:
                                                    //         viewModel
                                                    //             .dashBoardList[index]
                                                    //             .gradeName,
                                                    //     address:
                                                    //         selectedStore
                                                    //             .address,
                                                    //     storeId:
                                                    //         selectedStore
                                                    //             .storeId,
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          right: 5,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                              TextOverflow
                                                                  .ellipsis,
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
                                                                    viewModel.dashBoardList[index].planDate ==
                                                                            'Pending'
                                                                        ? AppColors
                                                                            .primary
                                                                        : AppColors
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
