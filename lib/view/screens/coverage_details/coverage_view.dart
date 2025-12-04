import 'dart:io';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/models/store_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/coverage_details/google_map.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/view/screens/store/store_home.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CoverageView extends ConsumerStatefulWidget {
  const CoverageView({super.key});

  @override
  ConsumerState<CoverageView> createState() => _CoverageViewState();
}

class _CoverageViewState extends ConsumerState<CoverageView> {
  InputDecoration _inputDecoration({String? hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.blackColor.withOpacity(0.45),
        fontSize: 14,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 1.8),
      ),
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

  Future<void> _ensureLocation(CoverageViewModel viewModel) async {
    if (viewModel.latitude == 0.0 && viewModel.longitude == 0.0) {
      try {
        await viewModel.getLatLong();
      } catch (e) {
        debugPrint('Location error: $e');
        AppSnackBar.showError(context, 'Unable to fetch location');
      }
    }
  }

  Future<void> _onStoreTap(
    CoverageViewModel viewModel,
    StoreModel selectedStore,
  ) async {
    final allowMultiCheckIn = viewModel.permission?.getPermissionValue(
      'AllowMultipleCheckIn',
    );
    final allowStoreInWithoutCheckIn = viewModel.permission?.getPermissionValue(
      'Allow_StoreIn_WithoutCheckIn',
    );

    if (allowStoreInWithoutCheckIn == 'N' && selectedStore.visitStatusId == 0) {
      AppSnackBar.showError(context, LabelService().getLabel(195));
      return;
    }

    if (allowMultiCheckIn == 'Y') {
      NavigationService.navigateTo(
        StoreHome(
          storeName: selectedStore.storeName,
          checkInTime: selectedStore.checkInTime,
          grade: selectedStore.gradeName,
          address: selectedStore.address,
          storeId: selectedStore.storeId,
        ),
      );
      return;
    }

    final isAlreadyCheckedIn = viewModel.stores.any(
      (store) =>
          store.visitStatusId != 0 && store.storeId != selectedStore.storeId,
    );

    if (isAlreadyCheckedIn) {
      AppSnackBar.showError(context, LabelService().getLabel(106));
      return;
    }

    NavigationService.navigateTo(
      StoreHome(
        storeName: selectedStore.storeName,
        checkInTime: selectedStore.checkInTime,
        grade: selectedStore.gradeName,
        address: selectedStore.address,
        storeId: selectedStore.storeId,
      ),
    );
  }

  Future<void> _onCheckBadgeTap({
    required CoverageViewModel viewModel,
    required StoreModel store,
    required int index,
    required String distancePermission,
    required String checkInCamera,
    required String checkoutCamera,
  }) async {
    await _ensureLocation(viewModel);

    if (viewModel.latitude == 0.0 && viewModel.longitude == 0.0) {
      AppSnackBar.showError(context, 'Location unavailable');
      return;
    }

    final myLat = viewModel.latitude;
    final myLng = viewModel.longitude;
    final otherLat = double.tryParse(store.latitude) ?? 0.0;
    final otherLng = double.tryParse(store.longitude) ?? 0.0;

    final distance = viewModel.calculateDistanceInMeters(
      myLat,
      myLng,
      otherLat,
      otherLng,
    );

    final hasCameraPermission =
        store.visitStatusId == 0 ? checkInCamera == 'Y' : checkoutCamera == 'Y';

    await handleCheckInOrOut(
      context: context,
      hasCameraPermission: hasCameraPermission,
      store: store,
      myLat: myLat,
      myLng: myLng,
      distance: distance,
      distancePermission: distancePermission,
      index: index,
    );
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
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          backgroundColor:
              Colors
                  .transparent, // Make dialog transparent to handle full custom layout
          child: Align(
            alignment: Alignment.center, // Position to top if needed
            child: Material(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              color: AppColors.whiteColor,
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF111827), Color(0xFF0B1120)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF111827), Color(0xFF0B1120)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Icon(Icons.close),
                          ),
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
                    Padding(
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
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary.withOpacity(0.95),
                                      AppColors.primary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
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
                          // if (checkStatus1 != '' && checkStatus != 'Check out')
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
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          backgroundColor:
              Colors
                  .transparent, // Make dialog transparent to handle full custom layout
          child: Align(
            alignment: Alignment.center, // Position to top if needed
            child: Material(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              color: AppColors.whiteColor,
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF111827), Color(0xFF0B1120)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF111827), Color(0xFF0B1120)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Icon(Icons.close),
                          ),
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

  Future<void> handleCheckInOrOut({
    required BuildContext context,
    required bool hasCameraPermission,
    required StoreModel store,
    required double myLat,
    required double myLng,
    required double distance,
    required String distancePermission,
    required int index,
  }) async {
    final viewModel = ref.watch(coverageModelProvider);

    bool isOtherLocationEmpty =
        store.latitude == "0.0" && store.longitude == "0.0";

    final limit = double.tryParse(distancePermission);
    bool isLocationValid =
        isOtherLocationEmpty || distance < (limit ?? double.infinity);

    if (!hasCameraPermission) {
      if (isLocationValid) {
        // ✅ Proceed without image if location is valid
        if (store.visitStatusId == 0) {
          await viewModel.coverageCheckIn(
            context,
            store.storeId,
            remarks: '', // You can prompt for remarks if needed
          );
          NavigationService.navigateTo(
            StoreHome(
              storeName: store.storeName,
              checkInTime: viewModel.stores[index].checkInTime,
              grade: store.gradeName,
              address: store.address,
              storeId: store.storeId,
            ),
          );
        } else {
          await viewModel.coverageCheckout(
            context,
            store.visitStatusId,
            remarks: '',
          );
        }
      } else {
        // ❌ Invalid location
        showLocationPopup(
          context: context,
          title: store.storeName,
          checkStatus:
              store.visitStatusId == 0
                  ? LabelService().getLabel(14)
                  : LabelService().getLabel(15),
          meter: distance.toStringAsFixed(2),
          myLat: myLat,
          myLng: myLng,
          otherLat: double.tryParse(store.latitude) ?? 0.0,
          otherLng: double.tryParse(store.longitude) ?? 0.0,
        );
      }
      return;
    }

    // ✅ Camera is allowed and location is valid → pick image and show popup
    if (isLocationValid) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) {
        AppSnackBar.showError(context, "No image captured.");
        return;
      }

      final imageFile = File(pickedFile.path);
      setState(() {});

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        showImagePopup(
          context: context,
          title: store.storeName,
          checkStatus:
              store.visitStatusId == 0
                  ? LabelService().getLabel(14)
                  : LabelService().getLabel(15),
          checkStatus1: LabelService().getLabel(102),
          checkRemarks:
              store.visitStatusId == 0
                  ? LabelService().getLabel(21)
                  : LabelService().getLabel(22),
          imageFile: imageFile,
          onSubmit: (value) async {
            if (store.visitStatusId == 0) {
              await viewModel.coverageCheckIn(
                context,
                store.storeId,
                remarks: value,
                checkInImgFile: imageFile,
              );
              NavigationService.navigateTo(
                StoreHome(
                  storeName: store.storeName,
                  checkInTime: viewModel.stores[index].checkInTime,
                  grade: store.gradeName,
                  address: store.address,
                  storeId: store.storeId,
                ),
              );
            } else {
              await viewModel.coverageCheckout(
                context,
                store.visitStatusId,
                remarks: value,
                checkOutImgFile: imageFile,
              );
            }
          },
          cancel: (value) async {
            await viewModel.cancelVisite(
              context,
              store.storeId,
              0,
              remarks: value,
            );
          },
        );
      });
    } else {
      // ❌ Location invalid even with camera
      showLocationPopup(
        context: context,
        title: store.storeName,
        checkStatus:
            store.visitStatusId == 0
                ? LabelService().getLabel(14)
                : LabelService().getLabel(15),
        meter: distance.toStringAsFixed(2),
        myLat: myLat,
        myLng: myLng,
        otherLat: double.tryParse(store.latitude) ?? 0.0,
        otherLng: double.tryParse(store.longitude) ?? 0.0,
      );
    }
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
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF111827), Color(0xFF0B1120)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          NavigationService.resetTo(
                            DashboardView(initialIndex: 0),
                          );
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          LabelService().getLabel(16),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // viewModel.getCoverageList(
                          //   context,
                          //   forceRefresh: true,
                          // );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF111827), Color(0xFF0B1120)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(Icons.refresh, size: 22),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Total Store Coverage ${viewModel.storeCount ?? 0}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                onChanged: (value) {
                  viewModel.getCoverageList(
                    context,
                    searchKeyword: value,
                    forceRefresh: true,
                  );
                },
                decoration: _inputDecoration(hint: LabelService().getLabel(18)),
              ),
            ),
            SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonFormField<int>(
                value: viewModel.selectedChannel?.channelId,
                decoration: _inputDecoration(hint: LabelService().getLabel(19)),
                style: const TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 14,
                ),
                hint: Text(
                  LabelService().getLabel(19),
                  style: TextStyle(
                    color: AppColors.blackColor.withOpacity(0.45),
                    fontSize: 14,
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
                  viewModel.selectChannel(
                    selected,
                    context,
                    forceRefresh: true,
                  );
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
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                    itemBuilder: (context, index) {
                      final store = viewModel.stores[index];
                      final checkInTime = store.checkInTime.trim();

                      final bool isPlan = store.visitStatusId == 0;
                      final bool hasCheckInTime =
                          checkInTime.isNotEmpty && checkInTime != '0';
                      final bool isChecked =
                          store.visitStatusId == 2 ||
                          store.visitStatusId == 3 ||
                          hasCheckInTime;

                      Color cardBg = AppColors.whiteColor;
                      Color borderColor = Colors.grey.shade200;
                      double borderWidth = 1;
                      Color numberColor = AppColors.secondary;
                      Color numberText = AppColors.whiteColor;
                      Color statusBg = AppColors.secondary.withOpacity(0.08);
                      Color statusTextColor = AppColors.secondary;
                      String statusLabel = LabelService().getLabel(
                        isPlan ? 14 : 15,
                      );

                      if (isChecked) {
                        cardBg = AppColors.primary.withOpacity(0.08);
                        borderColor = AppColors.primary;
                        numberColor = AppColors.primary;
                        statusBg = store.visitStatusId == 2
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.12);
                        statusTextColor = store.visitStatusId == 2
                            ? AppColors.whiteColor
                            : AppColors.primary;
                        statusLabel = LabelService().getLabel(15);
                      }

                      if (store.visitStatusId == 4) {
                        cardBg = AppColors.error.withOpacity(0.05);
                        borderColor = AppColors.error;
                        numberColor = AppColors.error;
                        statusBg = AppColors.error.withOpacity(0.12);
                        statusTextColor = AppColors.error;
                        statusLabel = LabelService().getLabel(102);
                      }

                      return IntrinsicHeight(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _onStoreTap(viewModel, store),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: borderColor,
                                width: borderWidth,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                  offset: Offset(0, 6),
                                ),
                                BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                                ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: numberColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: numberText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      14,
                                      14,
                                      14,
                                      14,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          store.storeName,
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          store.address,
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 13,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            store.completionStatus == '1'
                                                ? Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 8,
                                                  ),
                                                )
                                                : Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 8,
                                                  ),
                                                ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '${store.lastVisitedDate}',
                                              style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              onTap:
                                                  () => _onCheckBadgeTap(
                                                    viewModel: viewModel,
                                                    store: store,
                                                    index: index,
                                                    distancePermission:
                                                        distancePermission,
                                                    checkInCamera:
                                                        checkInCamera,
                                                    checkoutCamera:
                                                        checkoutCamera,
                                                  ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: statusBg,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Text(
                                                  statusLabel,
                                                  style: TextStyle(
                                                    color: statusTextColor,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (hasCheckInTime) ...[
                                              const SizedBox(width: 10),
                                              Text(
                                                checkInTime,
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 12),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
