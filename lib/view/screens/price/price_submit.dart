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

    Future.microtask(() async {
      final notifier = ref.read(priceModelProvider.notifier);
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
    });
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
    setState(() {
      _selectedBrandId = item.brandID ?? _selectedBrandId;
      _selectedProductCategoryId =
          item.productCategoryID ?? _selectedProductCategoryId;
      _currentBrandName = item.brandName ?? _currentBrandName;
      _currentProductName = item.productCategoryName ?? _currentProductName;
    });
    await viewModel.pricePromotionList(
      brandId: _selectedBrandId.toString(),
      productCategoryId: _selectedProductCategoryId.toString(),
      storeId: widget.storeId.toString(),
      visiteId: widget.visiteId.toString(),
    );
  }

  void _openFilterSheet(PriceViewModel viewModel) async {
    if (viewModel.brandList.isEmpty) {
      await viewModel.getBrandDropDown();
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
                          const Text(
                            'Filter Price Promotions',
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
                      const Text(
                        'Brand',
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
                          hintText: 'Select brand',
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
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : viewModel.brands.isEmpty
                                ? Center(
                                  child: Text(
                                    'No categories found for this brand',
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
                                                          ? 'Updated'
                                                          : 'Pending',
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Removes focus from any text field
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: Stack(
            children: [
              viewModel.loader
                  ? const Center(child: CircularProgressIndicator())
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
                                  onTap: () => NavigationService.goBack(),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Price Promotions',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () => _openFilterSheet(viewModel),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.filter_alt_outlined,
                                      size: 18,
                                      color: Colors.white,
                                    ),
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
                                viewModel.priceList[index].productID.toString(),
                              ),
                            );
                            final netPriceController = TextEditingController(
                              text: getNetPrice(
                                viewModel.priceList[index].productID.toString(),
                              ),
                            );

                            final promotionController = TextEditingController(
                              text: getPromotiion(
                                viewModel.priceList[index].productID.toString(),
                              ),
                            );

                            final product = viewModel.priceList[index];

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      blurRadius: 14,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
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
                                          SizedBox(
                                            width: 15,
                                            height: 25,
                                            child: Checkbox(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              activeColor: AppColors.primary,
                                              value: isOutOfStock,
                                              onChanged: (value) {
                                                setState(() {});
                                                viewModel.updateProductEntry(
                                                  productId:
                                                      product.productID
                                                          .toString(),
                                                  storeId:
                                                      widget.storeId.toString(),
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
                                                  isOutOfStock: value,
                                                  price: '0',
                                                  netPrice: '0',
                                                  promotion: '',
                                                  imagePath: '',
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.productmodelname ??
                                                      '',
                                                  style: const TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'SKU: ${product.productModelCode ?? '-'} • ${product.brandName ?? ''}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
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
                                                    setState(() {});
                                                    viewModel
                                                        .updateProductEntry(
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
                                                  final imagePath =
                                                      getChecklistImagePath(
                                                        product.productID
                                                            .toString(),
                                                      );
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
                                                color: const Color(0xFFFFF4E8),
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
                                                    'RRP (Retail Price)',
                                                    style: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  TextField(
                                                    controller: priceController,
                                                    enabled:
                                                        !(isOutOfStock ??
                                                            false),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (value) {
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
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                          isDense: true,
                                                          border:
                                                              InputBorder.none,
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
                                                color: const Color(0xFFFFF4E8),
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
                                                    'Net Price',
                                                    style: TextStyle(
                                                      color: AppColors.primary,
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
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                          isDense: true,
                                                          border:
                                                              InputBorder.none,
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
                                                  'Active Promotion',
                                                  style: TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: promotionController,
                                              enabled: !(isOutOfStock ?? false),
                                              keyboardType: TextInputType.text,
                                              maxLines: 2,
                                              minLines: 1,
                                              onChanged: (value) {
                                                viewModel.updateProductEntry(
                                                  productId:
                                                      product.productID
                                                          .toString(),
                                                  storeId:
                                                      widget.storeId.toString(),
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
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                                hintText:
                                                    'Add promotion details',
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
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  minimum: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: GestureDetector(
                    onTap:
                        viewModel.loader
                            ? null
                            : () async {
                              await viewModel.submitAllPrices(
                                widget.storeId,
                                widget.visiteId.toString(),
                              );
                              AppSnackBar.showSuccess(
                                context,
                                'Price Promotions submitted}',
                              );
                            },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child:
                            viewModel.loader
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
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
    );
  }
}
