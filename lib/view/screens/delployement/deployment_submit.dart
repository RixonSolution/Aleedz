import 'dart:io';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/models/activity_category_Id_model.dart';
import 'package:aleedz/models/market_activity_list.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/deployement_viewmodel.dart';
import 'package:aleedz/viewmodel/issues_veiwmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shimmer/shimmer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DeployementSubmitView extends ConsumerStatefulWidget {
  String checkInTime, storeName, activityCategoryName;
  int storeId, divisionId, activityTypeId, activitiCategoryId;

  DeployementSubmitView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.activityCategoryName,
    required this.divisionId,
    required this.activityTypeId,
    required this.activitiCategoryId,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<DeployementSubmitView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<DeployementSubmitView> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final Map<int, int> _imagePageIndex = {};
  ActivityCategoryModel? _selectedDeploymentCategory;
  int? _defaultDeploymentCategoryId;
  bool _filterApplied = false;
  List<ActivityCategoryModel> _deploymentCategories = [];
  List<String> _sheetBarcodes = [];

  List<String> _imageUrls(MarketActivityList item) {
    final urls = <String>[];
    if (item.imageActivity != null && item.imageActivity!.isNotEmpty) {
      urls.add(item.imageActivity!);
    }
    if (item.imageActivity2 != null && item.imageActivity2!.isNotEmpty) {
      urls.add(item.imageActivity2!);
    }
    return urls;
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  InputDecoration _sheetInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF7F8FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }

  Future<bool> _confirmDeleteDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          content: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1f2937), Color(0xFF0f172a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LabelService().getLabel(100),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  LabelService().getLabel(99),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(LabelService().getLabel(94)),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(LabelService().getLabel(95)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return result ?? false;
  }

  void _showImagePickerDialog({VoidCallback? onImagesUpdated}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1f2937), Color(0xFF0f172a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LabelService().getLabel(111),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.camera_alt, color: Colors.white),
                  title: Text(
                    LabelService().getLabel(112),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedImage = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedImage != null &&
                        ref
                                .read(issuesModelProvider.notifier)
                                .beforeActivityImages
                                .length <
                            4) {
                      ref
                          .read(issuesModelProvider.notifier)
                          .beforeActivityImages
                          .add(File(pickedImage.path));
                      ref.read(issuesModelProvider.notifier).notifyListeners();
                      onImagesUpdated?.call();
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.photo_library, color: Colors.white),
                  title: Text(
                    LabelService().getLabel(113),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedImages = await ImagePicker().pickMultiImage();
                    if (pickedImages.isNotEmpty) {
                      for (var image in pickedImages) {
                        if (ref
                                .read(issuesModelProvider.notifier)
                                .beforeActivityImages
                                .length >=
                            4) {
                          break;
                        }
                        ref
                            .read(issuesModelProvider.notifier)
                            .beforeActivityImages
                            .add(File(image.path));
                      }
                      ref.read(issuesModelProvider.notifier).notifyListeners();
                      onImagesUpdated?.call();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _defaultDeploymentCategoryId = widget.activitiCategoryId;
    Future.microtask(loadUserAndFetchActivity);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    barcodeController.dispose();
    super.dispose();
  }

  Future<void> loadUserAndFetchActivity() async {
    await _fetchActivitiesForCategory(widget.activitiCategoryId);
  }

  Future<void> _fetchActivitiesForCategory(int categoryId) async {
    await ref
        .read(issuesModelProvider.notifier)
        .getMarketActivityList(
          storeId: widget.storeId.toString(),
          activityCategoryId: categoryId.toString(),
          activityTypeId: '0',
          brandId: '3',
        );
    setState(() {
      widget.activitiCategoryId = categoryId;
      _filterApplied =
          _defaultDeploymentCategoryId != null &&
          categoryId != _defaultDeploymentCategoryId;
    });
  }

  Widget _fieldLabel(String text, {bool required = true}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }

  Future<void> _ensureDeploymentCategories() async {
    final deploymentNotifier = ref.read(deploymentModelProvider.notifier);
    if (deploymentNotifier.user == null) {
      await deploymentNotifier.loadUser();
    }
    if (deploymentNotifier.deploymentList.isEmpty) {
      await deploymentNotifier.getDeploymentList(
        divisionId: widget.divisionId.toString(),
        categoryTypeId: widget.activityTypeId.toString(),
      );
    }
    final loadedList = deploymentNotifier.deploymentList;
    ActivityCategoryModel? selectedCategory;
    if (loadedList.isNotEmpty) {
      selectedCategory = loadedList.firstWhere(
        (c) => c.activityCategoryID == widget.activitiCategoryId,
        orElse: () => loadedList.first,
      );
    }
    setState(() {
      _deploymentCategories = loadedList;
      _selectedDeploymentCategory ??= selectedCategory;
    });
  }

  Future<void> _clearDeploymentFilters() async {
    ActivityCategoryModel? defaultCategory;
    if (_deploymentCategories.isNotEmpty) {
      defaultCategory = _deploymentCategories.firstWhere(
        (c) => c.activityCategoryID == _defaultDeploymentCategoryId,
        orElse: () => _deploymentCategories.first,
      );
    }
    setState(() {
      _selectedDeploymentCategory = defaultCategory;
      _filterApplied = false;
    });
    await _fetchActivitiesForCategory(_defaultDeploymentCategoryId ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(issuesModelProvider);
    final isListLoading =
        viewModel.loader && viewModel.marketActivityList.isEmpty;
    final labelService = LabelService();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
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
                            onTap: () => NavigationService.goBack(),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            labelService.getLabel(121),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.storeName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.activityCategoryName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                  Icons.access_time_filled,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${labelService.getLabel(14)} ${widget.checkInTime}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          InkWell(
                            onTap: () async {
                              if (_filterApplied) {
                                await _clearDeploymentFilters();
                                return;
                              }
                              await _ensureDeploymentCategories();
                              if (_deploymentCategories.isEmpty) {
                                AppSnackBar.showError(
                                  context,
                                  'No deployment categories found',
                                );
                                return;
                              }
                              _openFilterSheet();
                            },
                            child: _FilterIcon(active: _filterApplied),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child:
                      isListLoading
                          ? Center(child: LoadingAnimationWidget.discreteCircle(color: Theme.of(context).colorScheme.primary, size: 32))
                          : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 140, top: 4),
                            itemCount: viewModel.marketActivityList.length,
                            itemBuilder: (context, index) {
                              final item = viewModel.marketActivityList[index];
                              final itemKey = item.activityID ?? index;
                              final images = _imageUrls(item);
                              final statusLabel =
                                  (item.quantity?.isNotEmpty ?? false)
                                      ? 'Qty ${item.quantity}'
                                      : 'Open';

                              return Dismissible(
                                key: ValueKey(
                                  'issue_${item.activityID ?? index}',
                                ),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  if (direction !=
                                      DismissDirection.endToStart) {
                                    return false;
                                  }
                                  final shouldDelete =
                                      await _confirmDeleteDialog();
                                  if (!shouldDelete) return false;

                                  await viewModel.removeActivity(
                                    activityId: item.activityID.toString(),
                                    activityTypeId:
                                        item.activityTypeID.toString(),
                                  );
                                  return true;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x19000000),
                                          blurRadius: 18,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                      border: const Border(
                                        left: BorderSide(
                                          color: AppColors.primary,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.activityTypeName ??
                                                          '',
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFF111827,
                                                        ),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      item.activityCategoryName ??
                                                          '',
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFF111827,
                                                        ),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      '#${item.activityID ?? '-'} • ${item.storeName ?? widget.storeName}',
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.greyText,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      '${item.activityDateTime ?? ''}',
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.greyText,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFFFF4EC,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Text(
                                                  statusLabel,
                                                  style: const TextStyle(
                                                    color: Color(0xFFf97316),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (images.isNotEmpty) ...[
                                            const SizedBox(height: 14),
                                            SizedBox(
                                              height: 180,
                                              child: Stack(
                                                children: [
                                                  PageView.builder(
                                                    controller: PageController(
                                                      initialPage:
                                                          _imagePageIndex[itemKey] ??
                                                          0,
                                                    ),
                                                    itemCount: images.length,
                                                    onPageChanged: (page) {
                                                      setState(() {
                                                        _imagePageIndex[itemKey] =
                                                            page;
                                                      });
                                                    },
                                                    itemBuilder: (
                                                      context,
                                                      imgIndex,
                                                    ) {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        child: CachedNetworkImage(
                                                          imageUrl:
                                                              '${ApiConstants.baseUrl}/${images[imgIndex]}',
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              (
                                                                context,
                                                                url,
                                                              ) => Shimmer.fromColors(
                                                                baseColor:
                                                                    Colors
                                                                        .grey[300]!,
                                                                highlightColor:
                                                                    Colors
                                                                        .grey[100]!,
                                                                child: Container(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                          errorWidget:
                                                              (
                                                                context,
                                                                url,
                                                                error,
                                                              ) => const Icon(
                                                                Icons.error,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Positioned(
                                                    bottom: 8,
                                                    left: 0,
                                                    right: 0,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: List.generate(images.length, (
                                                        dotIndex,
                                                      ) {
                                                        final isActive =
                                                            (_imagePageIndex[itemKey] ??
                                                                0) ==
                                                            dotIndex;
                                                        return AnimatedContainer(
                                                          duration:
                                                              const Duration(
                                                                milliseconds:
                                                                    200,
                                                              ),
                                                          margin:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 4,
                                                              ),
                                                          height: 8,
                                                          width:
                                                              isActive ? 16 : 8,
                                                          decoration: BoxDecoration(
                                                            color:
                                                                isActive
                                                                    ? AppColors
                                                                        .primary
                                                                    : Colors
                                                                        .white
                                                                        .withOpacity(
                                                                          0.7,
                                                                        ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  4,
                                                                ),
                                                            boxShadow:
                                                                isActive
                                                                    ? [
                                                                      BoxShadow(
                                                                        color: AppColors
                                                                            .primary
                                                                            .withOpacity(
                                                                              0.4,
                                                                            ),
                                                                        blurRadius:
                                                                            6,
                                                                        offset:
                                                                            const Offset(
                                                                              0,
                                                                              2,
                                                                            ),
                                                                      ),
                                                                    ]
                                                                    : [],
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 14),
                                          if ((item.activityDescription ?? '')
                                              .isNotEmpty)
                                            Text(
                                              item.activityDescription ?? '',
                                              style: const TextStyle(
                                                color: Color(0xFF4B5563),
                                                fontSize: 14,
                                                height: 1.5,
                                              ),
                                            ),
                                          const SizedBox(height: 12),
                                          Divider(
                                            color: Colors.grey.shade300,
                                            height: 1,
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 18,
                                                backgroundColor:
                                                    AppColors.primary,
                                                child: Text(
                                                  _initials(
                                                    item.teamMemberName,
                                                  ),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  item.teamMemberName ?? '',
                                                  style: const TextStyle(
                                                    color: Color(0xFF4B5563),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFFFF4EC,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: const Text(
                                                  'Open',
                                                  style: TextStyle(
                                                    color: Color(0xFFf97316),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
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
                          ),
                ),
              ],
            ),
            _AddDeploymentButton(
              onTap: () {
                _openAddDeploymentSheet(viewModel);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Deployment Category',
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(ctx).pop(),
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2F3F5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.activityCategoryName,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Store: ${widget.storeName}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select Category',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: _selectedDeploymentCategory?.activityCategoryID,
                        decoration: _sheetInputDecoration(
                          'Choose deployment category',
                        ),
                        items:
                            _deploymentCategories
                                .map(
                                  (cat) => DropdownMenuItem<int>(
                                    value: cat.activityCategoryID,
                                    child: Text(cat.activityCategoryName ?? ''),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) async {
                          if (value == null) return;
                          final selected = _deploymentCategories.firstWhere(
                            (c) => c.activityCategoryID == value,
                          );
                          setState(() {
                            _selectedDeploymentCategory = selected;
                            widget.activitiCategoryId =
                                selected.activityCategoryID ??
                                widget.activitiCategoryId;
                            widget.activityCategoryName =
                                selected.activityCategoryName ??
                                widget.activityCategoryName;
                            _filterApplied =
                                _defaultDeploymentCategoryId !=
                                selected.activityCategoryID;
                          });
                          setModalState(() {});
                          Navigator.of(ctx).pop();
                          await _fetchActivitiesForCategory(
                            selected.activityCategoryID ??
                                widget.activitiCategoryId,
                          );
                        },
                      ),
                      SizedBox(height: MediaQuery.of(ctx).padding.bottom + 32),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openAddDeploymentSheet(IssuesViewModel viewModel) {
    // reset inputs each time sheet opens
    descriptionController.clear();
    barcodeController.clear();
    viewModel.beforeActivityImages.clear();
    _sheetBarcodes.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        bool localSubmitting = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            void addBarcode(String code) {
              final value = code.trim();
              if (value.isEmpty) {
                AppSnackBar.showError(context, 'Enter or scan a barcode first');
                return;
              }
              if (_sheetBarcodes.contains(value)) {
                AppSnackBar.showError(context, 'Barcode already added');
                return;
              }
              setModalState(() {
                _sheetBarcodes.add(value);
              });
              barcodeController.clear();
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add New Deployment',
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2F3F5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: Colors.grey.shade300, height: 1),
                      const SizedBox(height: 16),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          minLines: 2,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: LabelService().getLabel(118),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      BarcodeScannerUI(
                        controller: barcodeController,
                        onAddBarcode: addBarcode,
                      ),
                      if (_sheetBarcodes.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (int i = 0; i < _sheetBarcodes.length; i++)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4E8),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFFFFD8B2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _sheetBarcodes[i],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        setModalState(() {
                                          _sheetBarcodes.removeAt(i);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFD8B2)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0F000000),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Photo',
                                      style: const TextStyle(
                                        color: Color(0xFF111827),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const Text(
                                      ' *',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                GestureDetector(
                                  onTap: () {
                                    if (viewModel.beforeActivityImages.length <
                                        4) {
                                      _showImagePickerDialog(
                                        onImagesUpdated:
                                            () => setModalState(() {}),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            LabelService().getLabel(114),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 110,
                                child:
                                    viewModel.beforeActivityImages.isEmpty
                                        ? Center(
                                          child: Text(
                                            'No photos added',
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                        : Container(
                                          margin: const EdgeInsets.only(
                                            top: 30,
                                          ),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                viewModel
                                                    .beforeActivityImages
                                                    .length,
                                            itemBuilder: (context, index) {
                                              final file =
                                                  viewModel
                                                      .beforeActivityImages[index];
                                              return Stack(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          right: 10,
                                                        ),
                                                    height: 120,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      border: Border.all(
                                                        color: const Color(
                                                          0xFFFFD8B2,
                                                        ),
                                                      ),
                                                      image: DecorationImage(
                                                        image: FileImage(file),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 6,
                                                    right: 6,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        viewModel
                                                            .beforeActivityImages
                                                            .removeAt(index);
                                                        viewModel
                                                            .notifyListeners();
                                                        setModalState(() {});
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                              color:
                                                                  Colors
                                                                      .black54,
                                                              shape:
                                                                  BoxShape
                                                                      .circle,
                                                            ),
                                                        padding:
                                                            const EdgeInsets.all(
                                                              4,
                                                            ),
                                                        child: const Icon(
                                                          Icons.close,
                                                          size: 16,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child:
                            localSubmitting || viewModel.loader
                                ? Center(
                                  child: LoadingAnimationWidget.discreteCircle(color: Theme.of(context).colorScheme.primary, size: 32),
                                )
                                : ElevatedButton(
                                  onPressed: () async {
                                    if (descriptionController.text.isEmpty) {
                                      AppSnackBar.showError(
                                        context,
                                        LabelService().getLabel(157),
                                      );
                                      return;
                                    }
                                    if (viewModel
                                        .beforeActivityImages
                                        .isEmpty) {
                                      AppSnackBar.showError(
                                        context,
                                        LabelService().getLabel(115),
                                      );
                                      return;
                                    }
                                    setModalState(() {
                                      localSubmitting = true;
                                    });
                                    await viewModel.marketActivityAdd(
                                      storeID: widget.storeId.toString(),
                                      activityTypeId:
                                          widget.activityTypeId.toString(),
                                      activityCategoryId:
                                          widget.activitiCategoryId.toString(),
                                      brandId: '3',
                                      activityDescription:
                                          descriptionController.text,
                                      statusId: '1',
                                      quantity: '1',
                                      deployementReason: '1',
                                      beforeActivityPictures:
                                          viewModel.beforeActivityImages,
                                    );
                                    descriptionController.clear();
                                    barcodeController.clear();
                                    viewModel.beforeActivityImages.clear();
                                    _sheetBarcodes.clear();
                                    setModalState(() {
                                      localSubmitting = false;
                                    });
                                    if (mounted) Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FilterIcon extends StatelessWidget {
  final bool active;
  const _FilterIcon({required this.active});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.filter_alt_outlined,
            color: active ? AppColors.primary : Colors.white,
            size: 18,
          ),
        ),
        if (active)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              height: 16,
              width: 16,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 12, color: AppColors.primary),
            ),
          ),
      ],
    );
  }
}

class _AddDeploymentButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddDeploymentButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Add New Deployment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BarcodeScannerUI extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onAddBarcode;
  const BarcodeScannerUI({
    Key? key,
    required this.controller,
    required this.onAddBarcode,
  }) : super(key: key);

  @override
  State<BarcodeScannerUI> createState() => _BarcodeScannerUIState();
}

class _BarcodeScannerUIState extends State<BarcodeScannerUI> {
  bool hasScanned = false;
  MobileScannerController cameraController = MobileScannerController();
  bool _torchOn = false;
  bool _showScanner = false;

  void _handleScan(String value) {
    widget.controller.text = value;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Scanned: $value')));
    Future.delayed(const Duration(milliseconds: 300), () {
      hasScanned = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.qr_code_scanner, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter / Scan Barcode',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                onPressed: () => widget.onAddBarcode(widget.controller.text),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                hasScanned = false;
                _showScanner = !_showScanner;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _showScanner ? 'Hide Scanner' : 'Scan Barcode',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        if (_showScanner) ...[
          const SizedBox(height: 8),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: MobileScanner(
                    controller: cameraController,
                    onDetect: (capture) {
                      if (hasScanned) return;
                      final barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        final String? rawValue = barcode.rawValue;
                        if (rawValue != null) {
                          hasScanned = true;
                          _handleScan(rawValue);
                          break;
                        }
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
                    color: Colors.white,
                    onPressed: () async {
                      await cameraController.toggleTorch();
                      setState(() {
                        _torchOn = !_torchOn;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
