import 'dart:convert';
import 'dart:io';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/coverage_details/google_map.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/view/screens/store/store_home.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;

class CoverageView extends ConsumerStatefulWidget {
  const CoverageView({super.key});

  @override
  ConsumerState<CoverageView> createState() => _CoverageViewState();
}

class _CoverageViewState extends ConsumerState<CoverageView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadData();
    });
  }

  void loadData() async {
    ref.read(coverageModelProvider.notifier).loadCoverageData(context);
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

                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(vertical: 15),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.secondary,
                    //       border: Border(
                    //         bottom: BorderSide(
                    //           color: AppColors.primary,
                    //           width: 4.0,
                    //         ),
                    //       ),
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         checkStatus,
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      NavigationService.resetTo(
                        DashboardView(initialIndex: 0),
                      ); // or any index like 2
                    },
                    child: Image.asset(
                      AppIcons.backArrow,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Text(
                    LabelService().getLabel(16),
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(AppIcons.locationIcon, height: 30, width: 30),
                ],
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(color: AppColors.primary, height: 0),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LabelService().getLabel(17),
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Center(
                      child: Text(
                        "${viewModel.storeCount ?? 0}",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                onChanged: (value) {
                  viewModel.getCoverageList(context, searchKeyword: value);
                },
                decoration: InputDecoration(
                  hintText: LabelService().getLabel(18),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondary),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonFormField<int>(
                value: viewModel.selectedChannel?.channelId,
                decoration: InputDecoration(
                  hintText: LabelService().getLabel(19),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondary),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 12,
                  ),
                ),

                items:
                    viewModel.channelList.map((channel) {
                      return DropdownMenuItem<int>(
                        value: channel.channelId,
                        child: Text(channel.channelName),
                      );
                    }).toList(),
                onChanged: (int? channelId) {
                  final selected = viewModel.channelList.firstWhere(
                    (c) => c.channelId == channelId,
                  );
                  viewModel.selectChannel(selected, context);
                },
              ),
            ),

            SizedBox(height: 5),
            viewModel.loader
                ? Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                )
                : Flexible(
                  child: ListView.separated(
                    physics: ScrollPhysics(),
                    itemCount: viewModel.stores.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Container(
                        color:
                            viewModel.stores[index].visitStatusId == 0
                                ? AppColors.whiteColor
                                : AppColors.darkGreyBackground,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 15,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  final allowMultiCheckIn = viewModel.permission
                                      ?.getPermissionValue(
                                        'AllowMultipleCheckIn',
                                      );
                                  final allowStoreInWithoutCheckIn = viewModel
                                      .permission
                                      ?.getPermissionValue(
                                        'Allow_StoreIn_WithoutCheckIn',
                                      );

                                  final selectedStore = viewModel.stores[index];

                                  // 1. Check: StoreIn not allowed without check-in
                                  if (allowStoreInWithoutCheckIn == 'N' &&
                                      selectedStore.visitStatusId == 0) {
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
                                        storeName: selectedStore.storeName,
                                        checkInTime: selectedStore.checkInTime,
                                        grade: 'A',
                                        address: selectedStore.address,
                                        storeId: selectedStore.storeId,
                                      ),
                                    );
                                    return;
                                  }

                                  // 3. If multi-check-in not allowed, check if user is already checked into another store
                                  final isAlreadyCheckedIn = viewModel.stores
                                      .any(
                                        (store) =>
                                            store.visitStatusId != 0 &&
                                            store.storeId !=
                                                selectedStore.storeId,
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
                                      storeName: selectedStore.storeName,
                                      checkInTime: selectedStore.checkInTime,
                                      grade: 'A',
                                      address: selectedStore.address,
                                      storeId: selectedStore.storeId,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        viewModel.stores[index].storeName,
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        viewModel.stores[index].address,
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Last Visted: ${viewModel.stores[index].lastVisitedDate}',
                                            style: TextStyle(
                                              color: AppColors.blackColor,
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

                            viewModel.stores[index].visitStatusId == 0
                                ? InkWell(
                                  onTap: () async {
                                    if (checkInCamera == 'Y') {
                                      // await viewModel.getLatLong();
                                      double myLat = viewModel.latitude;
                                      double myLng = viewModel.longitude;

                                      double otherLat = double.parse(
                                        viewModel.stores[index].latitude,
                                      );
                                      double otherLng = double.parse(
                                        viewModel.stores[index].longitude,
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
                                      final pickedFile = await picker.pickImage(
                                        source: ImageSource.camera,
                                      );

                                      if (pickedFile != null) {
                                        final imageFile = File(pickedFile.path);

                                        showImagePopup(
                                          context: context,
                                          title:
                                              viewModel.stores[index].storeName,
                                          checkStatus:
                                              viewModel
                                                          .stores[index]
                                                          .visitStatusId ==
                                                      0
                                                  ? LabelService().getLabel(14)
                                                  : LabelService().getLabel(15),
                                          checkStatus1: 'Cancel',
                                          checkRemarks:
                                              viewModel
                                                          .stores[index]
                                                          .visitStatusId ==
                                                      0
                                                  ? LabelService().getLabel(21)
                                                  : LabelService().getLabel(22),
                                          onSubmit: (value) async {
                                            if (viewModel
                                                    .stores[index]
                                                    .visitStatusId ==
                                                0) {
                                              viewModel.coverageCheckIn(
                                                context,
                                                viewModel.stores[index].storeId,
                                                remarks: value,
                                                checkInImgFile: imageFile,
                                              );
                                            } else {
                                              viewModel.coverageCheckout(
                                                context,
                                                viewModel
                                                    .stores[index]
                                                    .visitStatusId,
                                                remarks: value,
                                                checkOutImgFile: imageFile,
                                              );
                                            }
                                          },
                                          cancel: (value) async {
                                            viewModel.cancelVisite(
                                              context,
                                              viewModel.stores[index].storeId,
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
                                )
                                : InkWell(
                                  onTap: () async {
                                    if (checkoutCamera == 'Y') {
                                      // await viewModel.getLatLong();
                                      double myLat = viewModel.latitude;
                                      double myLng = viewModel.longitude;

                                      double otherLat = double.parse(
                                        viewModel.stores[index].latitude,
                                      );
                                      double otherLng = double.parse(
                                        viewModel.stores[index].longitude,
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
                                              viewModel.stores[index].storeName,
                                          checkStatus:
                                              viewModel
                                                          .stores[index]
                                                          .visitStatusId ==
                                                      0
                                                  ? LabelService().getLabel(14)
                                                  : LabelService().getLabel(15),
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
                                                    .stores[index]
                                                    .storeName,
                                            checkStatus:
                                                viewModel
                                                            .stores[index]
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
                                                            .stores[index]
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
                                                      .stores[index]
                                                      .visitStatusId ==
                                                  0) {
                                                viewModel.coverageCheckIn(
                                                  context,
                                                  viewModel
                                                      .stores[index]
                                                      .storeId,
                                                  remarks: value,
                                                  checkInImgFile:
                                                      imageFile, // ✅ Required parameter now
                                                );
                                              } else {
                                                viewModel.coverageCheckout(
                                                  context,
                                                  viewModel
                                                      .stores[index]
                                                      .visitStatusId,
                                                  remarks: value,
                                                  checkOutImgFile: imageFile,
                                                );
                                              }
                                            },
                                            cancel: (value) async {
                                              viewModel.cancelVisite(
                                                context,
                                                viewModel.stores[index].storeId,
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
                                    children: [
                                      Text(
                                        '${LabelService().getLabel(14)} : ${viewModel.stores[index].checkInTime}',
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
                                ),
                          ],
                        ),
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
    );
  }
}
