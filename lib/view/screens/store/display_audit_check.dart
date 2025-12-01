import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/models/audit_model.dart';
import 'package:aleedz/models/product_selection_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayAuditCheck extends ConsumerStatefulWidget {
  String storeName,
      checkInTime,
      categoryName,
      lastUpdate,
      updateBy,
      brandId,
      address;
  int storeId, categoryId, visitId;
  DisplayAuditCheck({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.categoryId,
    required this.categoryName,
    required this.lastUpdate,
    required this.updateBy,
    required this.brandId,
    required this.address,
    required this.visitId,
  }) : super(key: key);

  @override
  ConsumerState<DisplayAuditCheck> createState() => _DisplayAuditCheckState();
}

class _DisplayAuditCheckState extends ConsumerState<DisplayAuditCheck> {
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final storeNotifier = ref.read(storeModelProvider.notifier);

      storeNotifier.loader = true;
      storeNotifier.notifyListeners();

      await storeNotifier.loadUser();
      await storeNotifier.getBrandDropDown();

      storeNotifier.getDisplayCheckMaster(
        storeId: widget.storeId.toString(),
        categoryId: widget.categoryId.toString(),
        brandId: widget.brandId,
      );
      await storeNotifier.checkAudit(
        widget.storeId,
        widget.categoryId,
        widget.brandId,
        widget.visitId,
      );
      storeNotifier.clearData();
    });
  }

  void _showImagePickerDialog(String direction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1f2937), Color(0xFF0f172a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pick an image',
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      LabelService().getLabel(112),
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    onTap: () {
                      ref
                          .read(storeModelProvider.notifier)
                          .pickFromCameras(direction);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      LabelService().getLabel(113),
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    onTap: () {
                      ref
                          .read(storeModelProvider.notifier)
                          .pickFromGallerys(direction);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBrandPlanogramImages(String brandName) {
    final storeViewModel = ref.read(storeModelProvider);
    final matchedBrand = storeViewModel.brandList.firstWhereOrNull(
      (brand) => brand.brandName.toLowerCase() == brandName.toLowerCase(),
    );

    if (matchedBrand == null) {
      AppSnackBar.showError(
        context,
        'No planogram images found for $brandName.',
      );
      return;
    }

    bool hasValidImage(String url) {
      final trimmed = url.trim();
      if (trimmed.isEmpty) return false;
      if (trimmed.endsWith('/')) return false;
      return !trimmed.toLowerCase().endsWith('noimage.jpg');
    }

    final planogramImages =
        [
          matchedBrand.planogramPicture1,
          matchedBrand.planogramPicture2,
          matchedBrand.planogramPicture3,
        ].where(hasValidImage).toList();

    if (planogramImages.isEmpty) {
      AppSnackBar.showError(
        context,
        'No planogram images found for $brandName.',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          title: Text(
            '$brandName Images',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    planogramImages.map((url) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            url,
                            height: 180,
                            width: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                height: 180,
                                width: 160,
                                color: AppColors.lightGreyBackground,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => _FullScreenImages(
                          title: '$brandName Images',
                          imageUrls: planogramImages,
                        ),
                  ),
                );
              },
              child: const Text('Open Full Screen'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeModelProvider);
    const double availableColWidth = 60;
    const double lessThanTwoColWidth = 70;

    String cameraPermission =
        viewModel.permission?.getPermissionValue(
          "DisplayCheckImagesMandatory",
        ) ??
        "N";
    // String cameraPermission = 'N';

    final header = Container(
      width: double.infinity,
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
                onTap: () => NavigationService.goBack(),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Display Audit Check',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
          const SizedBox(height: 4),
          Text(
            widget.address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${LabelService().getLabel(14)} ${widget.checkInTime}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check, color: AppColors.primary, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${LabelService().getLabel(14)} ${widget.checkInTime}',
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
    );

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.whiteColor,
        body:
            viewModel.loader
                ? const Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header,
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(
                              builder: (context) {
                                // Group audit items by brand name
                                final groupedAudit =
                                    <String, List<AuditItem>>{};
                                for (var item in viewModel.auditList) {
                                  groupedAudit
                                      .putIfAbsent(item.brandName, () => [])
                                      .add(item);
                                }

                                final brandNames = groupedAudit.keys.toList();

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: brandNames.length,
                                  itemBuilder: (context, brandIndex) {
                                    final brandName = brandNames[brandIndex];
                                    final brandItems = groupedAudit[brandName]!;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primary,
                                            width: 2,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x11000000),
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 12,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        brandName,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'last update ${widget.lastUpdate}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () =>
                                                            _showBrandPlanogramImages(
                                                              brandName,
                                                            ),
                                                    style: TextButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 6,
                                                          ),
                                                      minimumSize: Size.zero,
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      foregroundColor:
                                                          AppColors.primary,
                                                      backgroundColor: AppColors
                                                          .primary
                                                          .withValues(
                                                            alpha: 0.12,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      LabelService().getLabel(
                                                        192,
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                              child: Row(
                                                children: const [
                                                  Expanded(
                                                    child: Text(
                                                      'Products',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: availableColWidth,
                                                    child: Text(
                                                      'Available',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: lessThanTwoColWidth,
                                                    child: Text(
                                                      'Less than 2?',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            Column(
                                              children: [
                                                ...brandItems.asMap().entries.map((
                                                  entry,
                                                ) {
                                                  final index = entry.key + 1;
                                                  final item = entry.value;

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 10,
                                                        ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 24,
                                                                    child: Text(
                                                                      '$index.',
                                                                      style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color:
                                                                            AppColors.blackColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          item.productModelCode,
                                                                          style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.blackColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          item.productModelName,
                                                                          style: const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.blackColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  availableColWidth,
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  final existing = viewModel
                                                                      .selectedProducts
                                                                      .firstWhereOrNull(
                                                                        (e) =>
                                                                            e.productId ==
                                                                            item.productId,
                                                                      );

                                                                  if (existing !=
                                                                      null) {
                                                                    existing.displayCheck =
                                                                        existing.displayCheck ==
                                                                                1
                                                                            ? 0
                                                                            : 1;
                                                                    if (existing
                                                                            .displayCheck ==
                                                                        0) {
                                                                      existing
                                                                          .displayCheckCount = 0;
                                                                    }
                                                                  } else {
                                                                    viewModel.selectedProducts.add(
                                                                      ProductSelection(
                                                                        productId:
                                                                            item.productId,
                                                                        displayCheck:
                                                                            1,
                                                                        displayCheckCount:
                                                                            0,
                                                                        token:
                                                                            viewModel.user!.apiToken.toString(),
                                                                        storeId:
                                                                            widget.storeId.toString(),
                                                                        teamMemberId:
                                                                            viewModel.user!.teamMemberID.toString(),
                                                                      ),
                                                                    );
                                                                  }
                                                                  viewModel
                                                                      .notifyListeners();
                                                                },
                                                                child: Icon(
                                                                  viewModel.selectedProducts.any(
                                                                        (e) =>
                                                                            e.productId ==
                                                                                item.productId &&
                                                                            e.displayCheck ==
                                                                                1,
                                                                      )
                                                                      ? Icons
                                                                          .check_circle
                                                                      : Icons
                                                                          .check_circle_outline,
                                                                  size: 35,
                                                                  color:
                                                                      viewModel.selectedProducts.any(
                                                                            (
                                                                              e,
                                                                            ) =>
                                                                                e.productId ==
                                                                                    item.productId &&
                                                                                e.displayCheck ==
                                                                                    1,
                                                                          )
                                                                          ? AppColors
                                                                              .primary
                                                                          : Colors
                                                                              .grey
                                                                              .shade400,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  lessThanTwoColWidth,
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  final existing = viewModel
                                                                      .selectedProducts
                                                                      .firstWhereOrNull(
                                                                        (e) =>
                                                                            e.productId ==
                                                                            item.productId,
                                                                      );
                                                                  final isAvailable =
                                                                      existing
                                                                          ?.displayCheck ==
                                                                      1;
                                                                  if (!isAvailable) {
                                                                    ScaffoldMessenger.of(
                                                                      context,
                                                                    ).showSnackBar(
                                                                      SnackBar(
                                                                        content: Text(
                                                                          LabelService().getLabel(
                                                                            189,
                                                                          ),
                                                                        ),
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                      ),
                                                                    );
                                                                    return;
                                                                  }

                                                                  if (existing !=
                                                                      null) {
                                                                    existing.displayCheckCount =
                                                                        existing.displayCheckCount ==
                                                                                1
                                                                            ? 0
                                                                            : 1;
                                                                  } else {
                                                                    viewModel.selectedProducts.add(
                                                                      ProductSelection(
                                                                        productId:
                                                                            item.productId,
                                                                        displayCheckCount:
                                                                            1,
                                                                        displayCheck:
                                                                            0,
                                                                        token:
                                                                            viewModel.user!.apiToken.toString(),
                                                                        storeId:
                                                                            widget.storeId.toString(),
                                                                        teamMemberId:
                                                                            viewModel.user!.teamMemberID.toString(),
                                                                      ),
                                                                    );
                                                                  }
                                                                  viewModel
                                                                      .notifyListeners();
                                                                },
                                                                child: Icon(
                                                                  viewModel.selectedProducts.any(
                                                                        (e) =>
                                                                            e.productId ==
                                                                                item.productId &&
                                                                            e.displayCheckCount ==
                                                                                1,
                                                                      )
                                                                      ? Icons
                                                                          .check_circle
                                                                      : Icons
                                                                          .check_circle_outline,
                                                                  size: 35,
                                                                  color:
                                                                      viewModel.selectedProducts.any(
                                                                            (
                                                                              e,
                                                                            ) =>
                                                                                e.productId ==
                                                                                    item.productId &&
                                                                                e.displayCheckCount ==
                                                                                    1,
                                                                          )
                                                                          ? AppColors
                                                                              .primary
                                                                          : Colors
                                                                              .grey
                                                                              .shade400,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ],
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: TextField(
                                                controller: remarksController,
                                                maxLines: 5,
                                                decoration: InputDecoration(
                                                  hintText: LabelService()
                                                      .getLabel(52),
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    LabelService().getLabel(49),
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Consumer(
                                                        builder: (
                                                          context,
                                                          ref,
                                                          _,
                                                        ) {
                                                          final viewModel = ref
                                                              .watch(
                                                                storeModelProvider,
                                                              );
                                                          return GestureDetector(
                                                            onTap: () {
                                                              if (viewModel
                                                                      .leftImages
                                                                      .length <
                                                                  4) {
                                                                _showImagePickerDialog(
                                                                  'left',
                                                                );
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                      LabelService()
                                                                          .getLabel(
                                                                            114,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            child: Container(
                                                              height: 80,
                                                              width: 80,
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    Colors
                                                                        .grey
                                                                        .shade100,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                              child: const Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .camera_alt,
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Consumer(
                                                          builder: (
                                                            context,
                                                            ref,
                                                            _,
                                                          ) {
                                                            final viewModel =
                                                                ref.watch(
                                                                  storeModelProvider,
                                                                );
                                                            final leftImages =
                                                                viewModel
                                                                    .leftImages;
                                                            return SizedBox(
                                                              height: 80,
                                                              child: ListView.builder(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount:
                                                                    leftImages
                                                                        .length,
                                                                itemBuilder: (
                                                                  context,
                                                                  index,
                                                                ) {
                                                                  final file =
                                                                      leftImages[index];
                                                                  return Stack(
                                                                    children: [
                                                                      Container(
                                                                        margin: const EdgeInsets.only(
                                                                          right:
                                                                              10,
                                                                        ),
                                                                        height:
                                                                            70,
                                                                        width:
                                                                            80,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                8,
                                                                              ),
                                                                          image: DecorationImage(
                                                                            image: FileImage(
                                                                              file,
                                                                            ),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 4,
                                                                        right:
                                                                            4,
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            viewModel.leftImages.removeAt(
                                                                              index,
                                                                            );
                                                                            viewModel.notifyListeners();
                                                                          },
                                                                          child: Container(
                                                                            decoration: const BoxDecoration(
                                                                              color:
                                                                                  Colors.black54,
                                                                              shape:
                                                                                  BoxShape.circle,
                                                                            ),
                                                                            padding: const EdgeInsets.all(
                                                                              4,
                                                                            ),
                                                                            child: const Icon(
                                                                              Icons.close,
                                                                              size:
                                                                                  16,
                                                                              color:
                                                                                  Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),

                                                  /// --- Competitions Section ---
                                                  Text(
                                                    LabelService().getLabel(50),
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Consumer(
                                                        builder: (
                                                          context,
                                                          ref,
                                                          _,
                                                        ) {
                                                          final viewModel = ref
                                                              .watch(
                                                                storeModelProvider,
                                                              );
                                                          return GestureDetector(
                                                            onTap: () {
                                                              if (viewModel
                                                                      .rightImages
                                                                      .length <
                                                                  4) {
                                                                _showImagePickerDialog(
                                                                  'right',
                                                                );
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                      LabelService()
                                                                          .getLabel(
                                                                            114,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            child: Container(
                                                              height: 80,
                                                              width: 80,
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    Colors
                                                                        .grey
                                                                        .shade100,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                              child: const Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .camera_alt,
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Consumer(
                                                          builder: (
                                                            context,
                                                            ref,
                                                            _,
                                                          ) {
                                                            final viewModel =
                                                                ref.watch(
                                                                  storeModelProvider,
                                                                );
                                                            final rightImages =
                                                                viewModel
                                                                    .rightImages;
                                                            return SizedBox(
                                                              height: 80,
                                                              child: ListView.builder(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount:
                                                                    rightImages
                                                                        .length,
                                                                itemBuilder: (
                                                                  context,
                                                                  index,
                                                                ) {
                                                                  final file =
                                                                      rightImages[index];
                                                                  return Stack(
                                                                    children: [
                                                                      Container(
                                                                        margin: const EdgeInsets.only(
                                                                          right:
                                                                              10,
                                                                        ),
                                                                        height:
                                                                            70,
                                                                        width:
                                                                            80,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                8,
                                                                              ),
                                                                          image: DecorationImage(
                                                                            image: FileImage(
                                                                              file,
                                                                            ),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 4,
                                                                        right:
                                                                            4,
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            viewModel.rightImages.removeAt(
                                                                              index,
                                                                            );
                                                                            viewModel.notifyListeners();
                                                                          },
                                                                          child: Container(
                                                                            decoration: const BoxDecoration(
                                                                              color:
                                                                                  Colors.black54,
                                                                              shape:
                                                                                  BoxShape.circle,
                                                                            ),
                                                                            padding: const EdgeInsets.all(
                                                                              4,
                                                                            ),
                                                                            child: const Icon(
                                                                              Icons.close,
                                                                              size:
                                                                                  16,
                                                                              color:
                                                                                  Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 20),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    12,
                                                    0,
                                                    12,
                                                    16,
                                                  ),
                                                child: SizedBox(
                                                width: double.infinity,
                                                height: 52,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    final hasBrandImages =
                                                        viewModel
                                                            .leftImages
                                                            .isNotEmpty;
                                                    final hasCompetitionImages =
                                                        viewModel
                                                            .rightImages
                                                            .isNotEmpty;

                                                    if (!hasBrandImages) {
                                                      AppSnackBar.showError(
                                                        context,
                                                        'Brand images are required before submitting.',
                                                      );
                                                      return;
                                                    }

                                                    if (!hasCompetitionImages) {
                                                      AppSnackBar.showError(
                                                        context,
                                                        'Competition images are required before submitting.',
                                                      );
                                                      return;
                                                    }

                                                    if (cameraPermission ==
                                                            'Y' ||
                                                        (cameraPermission ==
                                                                'N' &&
                                                            hasBrandImages &&
                                                            hasCompetitionImages)) {
                                                      await viewModel
                                                          .auditMediaSubmit(
                                                            context,
                                                            widget.storeId,
                                                            widget.categoryId
                                                                .toString(),
                                                            remarksController
                                                                .text,
                                                            widget.brandId,
                                                            widget.visitId,
                                                            checkInImages1:
                                                                viewModel
                                                                    .leftImages,
                                                            checkInImages2:
                                                                viewModel
                                                                    .rightImages,
                                                          );

                                                      List<Map<String, dynamic>>
                                                      dataList =
                                                          viewModel
                                                              .selectedProducts
                                                              .map(
                                                                (product) =>
                                                                    product
                                                                        .toJson(),
                                                              )
                                                              .toList();

                                                      await viewModel
                                                          .addDisplayCheck(
                                                            dataList,
                                                            context,
                                                            widget.storeId,
                                                            widget.categoryId,
                                                          );
                                                      await viewModel
                                                          .checkSummary(
                                                            widget.storeId,
                                                            viewModel
                                                                    .selectedBrand
                                                                    ?.brandId ??
                                                                0,
                                                            widget.visitId,
                                                          );
                                                      NavigationService.goBack();
                                                    } else {
                                                      AppSnackBar.showError(
                                                        context,
                                                        LabelService().getLabel(
                                                          186,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    "Submit",
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.whiteColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class _FullScreenImages extends StatelessWidget {
  const _FullScreenImages({required this.title, required this.imageUrls});

  final String title;
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder:
            (_, index) => InteractiveViewer(
              child: Center(
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => Container(
                        color: AppColors.lightGreyBackground,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                ),
              ),
            ),
      ),
    );
  }
}
