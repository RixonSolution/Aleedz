import 'dart:io';

import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/models/brand_list_model.dart';
import 'package:aleedz/models/price_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/price_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PriceSubmit extends ConsumerStatefulWidget {
  String storeName, checkInTime, brandName, productName;
  int storeId, brandId, visiteId, productCategoryId;
  PriceSubmit({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.brandId,
    required this.visiteId,
    required this.brandName,
    required this.productName,
    required this.productCategoryId,
  }) : super(key: key);

  @override
  ConsumerState<PriceSubmit> createState() => _DisplayAuditCheckSummaryState();
}

class _DisplayAuditCheckSummaryState extends ConsumerState<PriceSubmit> {
  late int _selectedBrandId;
  late int _selectedProductCategoryId;
  late String _currentBrandName;
  late String _currentProductName;
  late final int _defaultBrandId;
  late final int _defaultProductCategoryId;
  late final String _defaultBrandName;
  late final String _defaultProductName;
  bool _filterApplied = false;
  bool _hasUnsavedChanges = false;

  void _showImagePickerDialog(
    String direction, {
    required Function(String) onImageSelected,
  }) {
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
                    final path = await ref
                        .read(priceModelProvider.notifier)
                        .pickFromCamera(direction);
                    if (path != null) onImageSelected(path);
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
                    final path = await ref
                        .read(priceModelProvider.notifier)
                        .pickFromGallery(direction);
                    if (path != null) onImageSelected(path);
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
    _selectedBrandId = widget.brandId;
    _selectedProductCategoryId = widget.productCategoryId;
    _currentBrandName = widget.brandName;
    _currentProductName = widget.productName;
    _defaultBrandId = widget.brandId;
    _defaultProductCategoryId = widget.productCategoryId;
    _defaultBrandName = widget.brandName;
    _defaultProductName = widget.productName;

    Future.microtask(() async {
      final notifier = ref.read(priceModelProvider.notifier);
      notifier.loader = true;
      notifier.notifyListeners();
      await notifier.loadUser();
      if (notifier.brandList.isEmpty) {
        await notifier.getBrandDropDown();
      }
      await notifier.pricePromotion(
        widget.storeId,
        _selectedBrandId,
        widget.visiteId.toString(),
        showLoader: false,
      );
      await notifier.pricePromotionList(
        brandId: _selectedBrandId.toString(),
        productCategoryId: _selectedProductCategoryId.toString(),
        storeId: widget.storeId.toString(),
        visiteId: widget.visiteId.toString(),
      );
      notifier.loader = false;
      notifier.notifyListeners();
    });
  }

  void _markUnsavedChange() {
    if (!_hasUnsavedChanges && mounted) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<bool> _confirmExitIfNeeded() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Text(
              LabelService().getLabel(196),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  LabelService().getLabel(94),
                  style: const TextStyle(color: Color(0xFF111827)),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(
                  LabelService().getLabel(95),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (result == true) {
      _hasUnsavedChanges = false;
    }
    return result ?? false;
  }

  Future<void> _handleBackNavigation() async {
    final shouldExit = await _confirmExitIfNeeded();
    if (shouldExit) {
      NavigationService.goBack();
    }
  }

  String? getChecklistImagePath(String productId) {
    final viewModel = ref.watch(priceModelProvider);

    final matchingEntries = viewModel.productEntries.where(
      (e) => e.productId == productId,
    );

    if (matchingEntries.isNotEmpty) {
      return matchingEntries.first.priceImage;
    }

    return null;
  }

  bool? getOutOfStock(String productId) {
    final viewModel = ref.watch(priceModelProvider);

    final matchingEntries = viewModel.productEntries.where(
      (e) => e.productId == productId,
    );

    if (matchingEntries.isNotEmpty) {
      return matchingEntries.first.isOutOfStock;
    }

    return false;
  }

  String? getPrice(String productId) {
    final viewModel = ref.watch(priceModelProvider);

    final matchingEntries = viewModel.productEntries.where(
      (e) => e.productId == productId,
    );

    if (matchingEntries.isNotEmpty) {
      return matchingEntries.first.price;
    }

    return null;
  }

  String? getNetPrice(String productId) {
    final viewModel = ref.watch(priceModelProvider);

    final matchingEntries = viewModel.productEntries.where(
      (e) => e.productId == productId,
    );

    if (matchingEntries.isNotEmpty) {
      return matchingEntries.first.netPrice;
    }

    return null;
  }

  String? getPromotiion(String productId) {
    final viewModel = ref.watch(priceModelProvider);

    final matchingEntries = viewModel.productEntries.where(
      (e) => e.productId == productId,
    );

    if (matchingEntries.isNotEmpty) {
      return matchingEntries.first.promotion;
    }

    return null;
  }

  Future<void> _applyFilter(PriceModel item, PriceViewModel viewModel) async {
    Navigator.of(context).pop();
    final newBrand = item.brandID ?? _selectedBrandId;
    final newCategory = item.productCategoryID ?? _selectedProductCategoryId;
    setState(() {
      _selectedBrandId = newBrand;
      _selectedProductCategoryId = newCategory;
      _currentBrandName = item.brandName ?? _currentBrandName;
      _currentProductName = item.productCategoryName ?? _currentProductName;
      _filterApplied =
          _selectedBrandId != _defaultBrandId ||
          _selectedProductCategoryId != _defaultProductCategoryId;
    });
    await viewModel.pricePromotionList(
      brandId: _selectedBrandId.toString(),
      productCategoryId: _selectedProductCategoryId.toString(),
      storeId: widget.storeId.toString(),
      visiteId: widget.visiteId.toString(),
    );
  }

  Future<void> _resetFilters(PriceViewModel viewModel) async {
    setState(() {
      _selectedBrandId = _defaultBrandId;
      _selectedProductCategoryId = _defaultProductCategoryId;
      _currentBrandName = _defaultBrandName;
      _currentProductName = _defaultProductName;
      _filterApplied = false;
    });
    await viewModel.pricePromotionList(
      brandId: _selectedBrandId.toString(),
      productCategoryId: _selectedProductCategoryId.toString(),
      storeId: widget.storeId.toString(),
      visiteId: widget.visiteId.toString(),
    );
  }

  Future<void> _openFilterSheet(PriceViewModel viewModel) async {
    if (viewModel.user == null) {
      await viewModel.loadUser();
    }
    if (viewModel.brandList.isEmpty) {
      await viewModel.getBrandDropDown();
    }
    if (viewModel.brands.isEmpty) {
      await viewModel.pricePromotion(
        widget.storeId,
        _selectedBrandId,
        widget.visiteId.toString(),
        showLoader: false,
      );
    }

    BrandListModel? selectedBrand =
        viewModel.brandList.isNotEmpty
            ? viewModel.brandList.firstWhere(
              (b) => b.brandId == _selectedBrandId,
              orElse: () => viewModel.brandList.first,
            )
            : null;
    bool localLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                          Text(
                            LabelService().getLabel(292),
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 20,
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
                      Divider(color: Colors.grey.shade300, height: 1),
                      const SizedBox(height: 16),
                      Text(
                        LabelService().getLabel(49),
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: selectedBrand?.brandId,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          hintText: LabelService().getLabel(133),
                        ),
                        items:
                            viewModel.brandList
                                .map(
                                  (brand) => DropdownMenuItem<int>(
                                    value: brand.brandId,
                                    child: Text(brand.brandName),
                                  ),
                                )
                                .toList(),
                        onChanged: (int? brandId) async {
                          if (brandId == null) return;
                          selectedBrand = viewModel.brandList.firstWhere(
                            (b) => b.brandId == brandId,
                          );
                          setModalState(() {
                            localLoading = true;
                          });
                          await viewModel.pricePromotion(
                            widget.storeId,
                            brandId,
                            widget.visiteId.toString(),
                            showLoader: false,
                          );
                          setModalState(() {
                            localLoading = false;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child:
                            localLoading
                                ? Center(
                                  child: LoadingAnimationWidget.discreteCircle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 32,
                                  ),
                                )
                                : viewModel.brands.isEmpty
                                ? Center(
                                  child: Text(
                                    LabelService().getLabel(293),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                                : ListView.separated(
                                  itemCount: viewModel.brands.length,
                                  separatorBuilder:
                                      (_, __) => const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final item = viewModel.brands[index];
                                    final isUpdated =
                                        item.updatedBy?.toString() == '1';
                                    return GestureDetector(
                                      onTap:
                                          () => _applyFilter(item, viewModel),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x19000000),
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10,
                                              ),
                                              child: Text(
                                                '${index + 1}.',
                                                style: const TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.productCategoryName
                                                            ?.toString() ??
                                                        '',
                                                    style: const TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          isUpdated
                                                              ? AppColors
                                                                  .primary
                                                                  .withOpacity(
                                                                    0.12,
                                                                  )
                                                              : Colors
                                                                  .grey
                                                                  .shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      isUpdated
                                                          ? LabelService()
                                                              .getLabel(379)
                                                          : LabelService()
                                                              .getLabel(380),
                                                      style: TextStyle(
                                                        color:
                                                            isUpdated
                                                                ? AppColors
                                                                    .primary
                                                                : Colors
                                                                    .grey
                                                                    .shade600,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      LabelService().getLabel(
                                                        67,
                                                      ),
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade600,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      item.noOfModels
                                                              ?.toString() ??
                                                          '0',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 12),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      LabelService().getLabel(
                                                        68,
                                                      ),
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade600,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      item.nofModelUpdated ??
                                                          '0',
                                                      style: const TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(priceModelProvider);
    final labelService = LabelService();

    return WillPopScope(
      onWillPop: _confirmExitIfNeeded,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Removes focus from any text field
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: Stack(
              children: [
                viewModel.loader
                    ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                    )
                    : Column(
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
                                    onTap: _handleBackNavigation,
                                    child: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    LabelService().getLabel(294),
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
                              const SizedBox(height: 6),
                              Text(
                                _currentBrandName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _currentProductName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  InkWell(
                                    onTap: () async {
                                      if (_filterApplied) {
                                        await _resetFilters(viewModel);
                                      } else {
                                        await _openFilterSheet(viewModel);
                                      }
                                    },
                                    child: _FilterIcon(active: _filterApplied),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            primary: true,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 88),
                            itemCount: viewModel.priceList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final isOutOfStock = getOutOfStock(
                                viewModel.priceList[index].productID.toString(),
                              );

                              final priceController = TextEditingController(
                                text: getPrice(
                                  viewModel.priceList[index].productID
                                      .toString(),
                                ),
                              );
                              final netPriceController = TextEditingController(
                                text: getNetPrice(
                                  viewModel.priceList[index].productID
                                      .toString(),
                                ),
                              );

                              final promotionController = TextEditingController(
                                text: getPromotiion(
                                  viewModel.priceList[index].productID
                                      .toString(),
                                ),
                              );

                              final product = viewModel.priceList[index];
                              final imagePath = getChecklistImagePath(
                                product.productID.toString(),
                              );
                              final hasPrice =
                                  priceController.text.trim().isNotEmpty &&
                                  priceController.text.trim() != '0';
                              final hasNetPrice =
                                  netPriceController.text.trim().isNotEmpty &&
                                  netPriceController.text.trim() != '0';
                              final hasPromotion =
                                  promotionController.text.trim().isNotEmpty;
                              final hasImage = (imagePath ?? '').isNotEmpty;
                              final hasOutOfStock = isOutOfStock == true;
                              final isPrefilled =
                                  hasPrice ||
                                  hasNetPrice ||
                                  hasPromotion ||
                                  hasImage ||
                                  hasOutOfStock;

                              void handleOutOfStockChange(bool? value) {
                                final newValue = value ?? false;
                                _markUnsavedChange();
                                setState(() {});
                                viewModel.updateProductEntry(
                                  productId: product.productID.toString(),
                                  storeId: widget.storeId.toString(),
                                  visitId: widget.visiteId.toString(),
                                  token: viewModel.user?.apiToken ?? '',
                                  teamMemberId:
                                      viewModel.user?.teamMemberID.toString(),
                                  isOutOfStock: newValue,
                                  price: '0',
                                  netPrice: '0',
                                  promotion: '',
                                  imagePath: '',
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  12,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        isPrefilled
                                            ? AppColors.primary.withOpacity(
                                              0.08,
                                            )
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x14000000),
                                        blurRadius: 14,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                    border: Border.all(
                                      color:
                                          isPrefilled
                                              ? AppColors.primary.withOpacity(
                                                0.35,
                                              )
                                              : Colors.transparent,
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
                                                    product.productmodelname ??
                                                        '',
                                                    style: const TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    '${labelService.getLabel(267)} ${product.productModelCode ?? '-'} • ${product.brandName ?? ''}',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                if (getOutOfStock(
                                                      product.productID
                                                          .toString(),
                                                    ) ==
                                                    false) {
                                                  _showImagePickerDialog(
                                                    'left',
                                                    onImageSelected: (
                                                      String path,
                                                    ) {
                                                      _markUnsavedChange();
                                                      setState(() {});
                                                      viewModel.updateProductEntry(
                                                        productId:
                                                            product.productID
                                                                .toString(),
                                                        storeId:
                                                            widget.storeId
                                                                .toString(),
                                                        visitId:
                                                            widget.visiteId
                                                                .toString(),
                                                        token:
                                                            viewModel
                                                                .user
                                                                ?.apiToken ??
                                                            '',
                                                        teamMemberId:
                                                            viewModel
                                                                .user
                                                                ?.teamMemberID
                                                                .toString(),
                                                        imagePath: path,
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors
                                                          .lightGreyBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                ),
                                                child: Builder(
                                                  builder: (_) {
                                                    if (imagePath != null &&
                                                        imagePath.isNotEmpty) {
                                                      return Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                            child: Image.file(
                                                              File(imagePath),
                                                              width: 70,
                                                              height: 70,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 4,
                                                            right: 4,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                _markUnsavedChange();
                                                                setState(() {});
                                                                viewModel.updateProductEntry(
                                                                  productId:
                                                                      product
                                                                          .productID
                                                                          .toString(),
                                                                  storeId:
                                                                      widget
                                                                          .storeId
                                                                          .toString(),
                                                                  visitId:
                                                                      widget
                                                                          .visiteId
                                                                          .toString(),
                                                                  token:
                                                                      viewModel
                                                                          .user
                                                                          ?.apiToken ??
                                                                      '',
                                                                  teamMemberId:
                                                                      viewModel
                                                                          .user
                                                                          ?.teamMemberID
                                                                          .toString(),
                                                                  imagePath: '',
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration: const BoxDecoration(
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
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    } else {
                                                      return const Icon(
                                                        Icons.camera_alt,
                                                        size: 28,
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 14),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 10,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFFFF4E8,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFFFD8B2,
                                                    ),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      LabelService().getLabel(
                                                        296,
                                                      ),
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.primary,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    TextField(
                                                      controller:
                                                          priceController,
                                                      enabled:
                                                          !(isOutOfStock ??
                                                              false),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        _markUnsavedChange();
                                                        viewModel.updateProductEntry(
                                                          productId:
                                                              product.productID
                                                                  .toString(),
                                                          storeId:
                                                              widget.storeId
                                                                  .toString(),
                                                          visitId:
                                                              widget.visiteId
                                                                  .toString(),
                                                          token:
                                                              viewModel
                                                                  .user
                                                                  ?.apiToken ??
                                                              '',
                                                          teamMemberId:
                                                              viewModel
                                                                  .user
                                                                  ?.teamMemberID
                                                                  .toString(),
                                                          price: value,
                                                        );
                                                      },
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            AppColors
                                                                .blackColor,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                            isDense: true,
                                                            border:
                                                                InputBorder
                                                                    .none,
                                                            hintText: '0',
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 10,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFFFF4E8,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFFFD8B2,
                                                    ),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      LabelService().getLabel(
                                                        70,
                                                      ),
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.primary,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    TextField(
                                                      controller:
                                                          netPriceController,
                                                      enabled:
                                                          !(isOutOfStock ??
                                                              false),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        _markUnsavedChange();
                                                        viewModel.updateProductEntry(
                                                          productId:
                                                              product.productID
                                                                  .toString(),
                                                          storeId:
                                                              widget.storeId
                                                                  .toString(),
                                                          visitId:
                                                              widget.visiteId
                                                                  .toString(),
                                                          token:
                                                              viewModel
                                                                  .user
                                                                  ?.apiToken ??
                                                              '',
                                                          teamMemberId:
                                                              viewModel
                                                                  .user
                                                                  ?.teamMemberID
                                                                  .toString(),
                                                          netPrice: value,
                                                        );
                                                      },
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            AppColors
                                                                .blackColor,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                            isDense: true,
                                                            border:
                                                                InputBorder
                                                                    .none,
                                                            hintText: '0',
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF0E6),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFFFC9A3),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.local_offer_outlined,
                                                    color: AppColors.primary,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    LabelService().getLabel(
                                                      297,
                                                    ),
                                                    style: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              TextField(
                                                controller: promotionController,
                                                enabled:
                                                    !(isOutOfStock ?? false),
                                                keyboardType:
                                                    TextInputType.text,
                                                maxLines: 2,
                                                minLines: 1,
                                                onChanged: (value) {
                                                  _markUnsavedChange();
                                                  viewModel.updateProductEntry(
                                                    productId:
                                                        product.productID
                                                            .toString(),
                                                    storeId:
                                                        widget.storeId
                                                            .toString(),
                                                    visitId:
                                                        widget.visiteId
                                                            .toString(),
                                                    token:
                                                        viewModel
                                                            .user
                                                            ?.apiToken ??
                                                        '',
                                                    teamMemberId:
                                                        viewModel
                                                            .user
                                                            ?.teamMemberID
                                                            .toString(),
                                                    promotion: value,
                                                  );
                                                },
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  border: InputBorder.none,
                                                  hintText: LabelService()
                                                      .getLabel(381),
                                                ),
                                                style: const TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        GestureDetector(
                                          onTap:
                                              () => handleOutOfStockChange(
                                                !(isOutOfStock ?? false),
                                              ),
                                          behavior: HitTestBehavior.opaque,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 25,
                                                child: Checkbox(
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  activeColor:
                                                      AppColors.primary,
                                                  value: isOutOfStock,
                                                  onChanged:
                                                      handleOutOfStockChange,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                LabelService().getLabel(72),
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                if (!viewModel.loader)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SafeArea(
                      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: GestureDetector(
                        onTap: () async {
                          _hasUnsavedChanges = false;
                          await viewModel.submitAllPrices(
                            widget.storeId,
                            widget.visiteId.toString(),
                          );
                          AppSnackBar.showSuccess(
                            context,
                            LabelService().getLabel(382),
                          );
                        },
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              LabelService().getLabel(73),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
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
