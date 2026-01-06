import 'dart:io';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/coverage_details/google_map.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/view/screens/store/store_home.dart';
import 'package:aleedz/view/screens/today_plan/today_plan_view.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  DateTime _selectedDate = DateTime.now();
  bool _isInitialLoad = true;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool get _isTodaySelected => _isSameDay(_selectedDate, DateTime.now());

  bool _isFutureDate(DateTime date) {
    final today = DateTime.now();
    final candidate = DateTime(date.year, date.month, date.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    return candidate.isAfter(todayOnly);
  }

  Future<void> _updateDate(DateTime date) async {
    setState(() {
      _selectedDate = date;
    });
    await ref
        .read(coverageModelProvider.notifier)
        .loadDashboard(context, planDate: date);
  }

  Future<void> _changeDateBy(int days) async {
    final newDate = _selectedDate.add(Duration(days: days));
    if (_isFutureDate(newDate)) return;
    await _updateDate(newDate);
  }

  Future<void> _openDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year, now.month, now.day),
    );

    if (pickedDate != null) {
      await _updateDate(pickedDate);
    }
  }

  Widget _arrowButton({
    required IconData icon,
    required VoidCallback? onTap,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: enabled ? AppColors.whiteColor : Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: enabled ? const Color(0xFF111827) : Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  Widget _dateSelector(CoverageViewModel _) {
    final displayDate = DateFormat('dd MMMM yyyy').format(_selectedDate);
    final canGoForward =
        !_isFutureDate(_selectedDate.add(const Duration(days: 1)));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _arrowButton(
            icon: Icons.chevron_left,
            onTap: () => _changeDateBy(-1),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _openDatePicker(),
              child: Center(
                child: Text(
                  displayDate,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          _arrowButton(
            icon: Icons.chevron_right,
            onTap: canGoForward ? () => _changeDateBy(1) : null,
            enabled: canGoForward,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchCoverage();
    });
  }

  Future<void> loadUserAndFetchCoverage() async {
    final coverageNotifier = ref.read(coverageModelProvider.notifier);
    final storeNotifier = ref.read(storeModelProvider.notifier);
    final store = ref.read(storeModelProvider);

    try {
      await coverageNotifier.loadDashboard(context, planDate: _selectedDate);
    } finally {
      if (mounted) {
        setState(() {
          _isInitialLoad = false;
        });
      }
    }
    if (!mounted) return;

    await store.getROSLabels();
    if (!mounted) return;

    await storeNotifier.loadROSLabelsFromPrefs();
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
                            borderSide: BorderSide(color: AppColors.primary),
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
                            child: Icon(Icons.close, color: Colors.transparent),
                          ),
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        LabelService().getLabel(55),
                        style: TextStyle(
                          color: AppColors.blackColor,
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
                        style: TextStyle(color: AppColors.blackColor),
                        decoration: InputDecoration(
                          hintText: LabelService().getLabel(103),
                          hintStyle: TextStyle(color: AppColors.greyText),
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.blackColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
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
                                    LabelService().getLabel(102),
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
                    ),
                    const SizedBox(height: 12),
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

  Future<void> _ensureLocation(CoverageViewModel viewModel) async {
    if (viewModel.latitude != 0.0 || viewModel.longitude != 0.0) return;
    try {
      await viewModel.getLatLong();
    } catch (e) {
      debugPrint('Location error: $e');
      AppSnackBar.showError(context, 'Unable to fetch location');
    }
  }

  Future<void> _onStoreTap({
    required CoverageViewModel viewModel,
    required String allowMultiCheckIn,
    required String allowWithoutCheckIn,
    required store, // DashboardModel
  }) async {
    if (store.visitId == 0) {
      AppSnackBar.showError(context, LabelService().getLabel(195));
      return;
    }

    if (!_isTodaySelected) {
      AppSnackBar.showError(context, 'Actions are only available for today.');
      return;
    }
    if (allowWithoutCheckIn == 'N' && store.visitStatusId == 1) {
      AppSnackBar.showError(context, LabelService().getLabel(105));
      return;
    }

    if (allowMultiCheckIn == 'Y' && store.visitStatusId == 2) {
      NavigationService.navigateTo(
        StoreHome(
          storeName: store.storeName,
          checkInTime: store.checkInTime,
          grade: store.gradeName,
          address: store.address,
          storeId: store.storeId,
        ),
      );
      return;
    }

    final isAlreadyCheckedIn = viewModel.dashBoardList.any(
      (item) => item.visitStatusId == 2 && item.storeId != store.storeId,
    );

    if (isAlreadyCheckedIn) {
      AppSnackBar.showError(
        context,
        'You are already checked in at another store.',
      );
      return;
    }

    NavigationService.navigateTo(
      StoreHome(
        storeName: store.storeName,
        checkInTime: store.checkInTime,
        grade: store.gradeName,
        address: store.address,
        storeId: store.storeId,
      ),
    );
  }

  Future<void> _handleCheckIn(
    BuildContext context,
    CoverageViewModel viewModel,
    int index,
    String distancePermission,
    String checkInCamera,
  ) async {
    if (!_isTodaySelected) {
      AppSnackBar.showError(context, 'Actions are only available for today.');
      return;
    }
    await _ensureLocation(viewModel);
    if (viewModel.latitude == 0.0 && viewModel.longitude == 0.0) {
      AppSnackBar.showError(context, 'Location unavailable');
      return;
    }

    final limit = double.tryParse(distancePermission) ?? double.infinity;
    if (checkInCamera == 'Y') {
      final myLat = viewModel.latitude;
      final myLng = viewModel.longitude;

      final otherLat =
          double.tryParse(viewModel.dashBoardList[index].latitude) ?? 0.0;
      final otherLng =
          double.tryParse(viewModel.dashBoardList[index].longitude) ?? 0.0;

      final isOtherLocationEmpty = otherLat == 0.0 && otherLng == 0.0;
      final distance = viewModel.calculateDistanceInMeters(
        myLat,
        myLng,
        otherLat,
        otherLng,
      );

      if (isOtherLocationEmpty || distance < limit) {
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
      } else if (distance > limit) {
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
    if (!_isTodaySelected) {
      AppSnackBar.showError(context, 'Actions are only available for today.');
      return;
    }
    await _ensureLocation(viewModel);
    if (viewModel.latitude == 0.0 && viewModel.longitude == 0.0) {
      AppSnackBar.showError(context, 'Location unavailable');
      return;
    }

    final limit = double.tryParse(distancePermission) ?? double.infinity;
    if (checkoutCamera == 'Y') {
      final myLat = viewModel.latitude;
      final myLng = viewModel.longitude;

      final otherLat =
          double.tryParse(viewModel.dashBoardList[index].latitude) ?? 0.0;
      final otherLng =
          double.tryParse(viewModel.dashBoardList[index].longitude) ?? 0.0;

      final isOtherLocationEmpty = otherLat == 0.0 && otherLng == 0.0;
      final distance = viewModel.calculateDistanceInMeters(
        myLat,
        myLng,
        otherLat,
        otherLng,
      );

      if (isOtherLocationEmpty || distance < limit) {
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
      } else if (distance > limit) {
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
    final checkedOutCount =
        viewModel.dashBoardList
            .where((store) => store.visitStatusId == 3)
            .length;
    final totalStores = viewModel.dashBoardList.length;
    final bool isTodaySelected = _isTodaySelected;

    // print('distancePermission$distancePermission');

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body:
            _isInitialLoad && viewModel.loader
                ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                )
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
                                          Text(
                                            LabelService().getLabel(231),
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
                                                color: AppColors.primary,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                LabelService().getLabel(232),
                                                style: TextStyle(
                                                  color: Color(0xFFfbbf24),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '$checkedOutCount',
                                                  style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '/$totalStores',
                                                  style: const TextStyle(
                                                    color: AppColors.whiteColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            LabelService().getLabel(233),
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
                                          Text(
                                            LabelService().getLabel(234),
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
                                          Text(
                                            LabelService().getLabel(46),
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
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                        child: _dateSelector(viewModel),
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
                                LabelService().getLabel(12),
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
                                LabelService().getLabel(193),
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
                            child: LoadingAnimationWidget.discreteCircle(
                              color: AppColors.secondary,
                              size: 32,
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
                                String trailingText = ' ${store.planDate}';
                                Color trailingColor = AppColors.greyText;
                                Color statusBg = badgeBg;
                                Color statusText = badgeTextColor;
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
                                  statusBg = badgeBg;
                                  statusText = badgeTextColor;
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
                                  statusBg = badgeBg;
                                  statusText = badgeTextColor;
                                  badgeLabel =
                                      store.visitStatus.isNotEmpty
                                          ? store.visitStatus
                                          : 'Visited';
                                  numberBg = AppColors.success;
                                  numberText = AppColors.whiteColor;
                                  trailingText =
                                      '${store.checkInTime.isNotEmpty ? store.planDate : '--'}';
                                } else if (visitStatusId == 4) {
                                  badgeBg = AppColors.error.withOpacity(0.12);
                                  badgeTextColor = AppColors.error;
                                  statusBg = badgeBg;
                                  statusText = badgeTextColor;
                                  badgeLabel =
                                      store.visitStatus.isNotEmpty
                                          ? store.visitStatus
                                          : 'Cancelled';
                                  numberBg = AppColors.error;
                                  numberText = AppColors.whiteColor;
                                  cardOpacity = 0.55;
                                  trailingText = '';
                                }

                                if (!isTodaySelected) {
                                  statusTap = null;
                                }

                                final hasTime = trailingText.isNotEmpty;
                                final canDismiss =
                                    isTodaySelected && visitStatusId == 1;

                                return Dismissible(
                                  key: ValueKey(
                                    'store-${store.storeId}-${store.visitId}',
                                  ),
                                  direction:
                                      canDismiss
                                          ? DismissDirection.endToStart
                                          : DismissDirection.none,
                                  confirmDismiss: (direction) async {
                                    if (!canDismiss) return false;
                                    await showCancelPopup(
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
                                    return false;
                                  },
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.cancel,
                                          color: AppColors.error,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          LabelService().getLabel(102),
                                          style: TextStyle(
                                            color: AppColors.error,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Opacity(
                                    opacity: cardOpacity,
                                    child: IntrinsicHeight(
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        onTap:
                                            () => _onStoreTap(
                                              viewModel: viewModel,
                                              allowMultiCheckIn:
                                                  allowMultiCheckIn,
                                              allowWithoutCheckIn:
                                                  allowWithoutCheckIn,
                                              store: store,
                                            ),
                                        onLongPress: () async {
                                          if (canDismiss) {
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
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: cardBg,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: borderColor,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x1A000000),
                                                blurRadius: 12,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 35,
                                                decoration: BoxDecoration(
                                                  color: numberBg,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(16),
                                                        bottomLeft:
                                                            Radius.circular(16),
                                                      ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: TextStyle(
                                                      color: numberText,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                        14,
                                                        14,
                                                        14,
                                                        14,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        store.storeName,
                                                        style: TextStyle(
                                                          color:
                                                              AppColors
                                                                  .blackColor,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        store.address,
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        style: TextStyle(
                                                          color:
                                                              AppColors
                                                                  .greyText,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          InkWell(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  30,
                                                                ),
                                                            onTap: statusTap,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        14,
                                                                    vertical: 6,
                                                                  ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                    color:
                                                                        statusBg,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          30,
                                                                        ),
                                                                  ),
                                                              child: Text(
                                                                badgeLabel,
                                                                style: TextStyle(
                                                                  color:
                                                                      statusText,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          if (hasTime) ...[
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              trailingText,
                                                              style: TextStyle(
                                                                color:
                                                                    trailingColor,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
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
