import 'dart:io';

import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/models/brand_store_share_model.dart';
import 'package:aleedz/models/shelf_share_brand_summary_model.dart';
import 'package:aleedz/models/shelf_share_display_location_model.dart';
import 'package:aleedz/viewmodel/store_share_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ShelfShareDetailView extends ConsumerStatefulWidget {
  final String storeName;
  final String checkInTime;
  final String address;
  final int storeId;
  final int visitId;
  final int productCategoryId;
  final String productCategoryName;

  const ShelfShareDetailView({
    super.key,
    required this.storeName,
    required this.checkInTime,
    required this.address,
    required this.storeId,
    required this.visitId,
    required this.productCategoryId,
    required this.productCategoryName,
  });

  @override
  ConsumerState<ShelfShareDetailView> createState() =>
      _ShelfShareDetailViewState();
}

class _ShelfShareDetailViewState extends ConsumerState<ShelfShareDetailView> {
  final ImagePicker _imagePicker = ImagePicker();
  final Map<String, bool> _slotEnabled = {};
  final Map<String, File> _slotImages = {};
  final Map<String, TextEditingController> _facingControllers = {};
  final Map<String, TextEditingController> _stockControllers = {};

  int? _selectedBrandId;
  int _expandedShelfShareId = 0;
  bool _loading = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  Future<void> _loadData() async {
    final notifier = ref.read(storeShareModelProvider.notifier);
    await notifier.loadUser();
    await notifier.getShelfShareAllBrands();
    if (!_hasUsableShelfShareBrands(notifier)) {
      await notifier.getBrandDropDown();
    }

    final initialBrandId = _initialBrandId(notifier);
    if (initialBrandId != null) {
      _selectedBrandId = initialBrandId;
      await notifier.getShelfShareBrandSummaryByCategory(
        storeId: widget.storeId,
        productCategoryId: widget.productCategoryId,
        brandId: initialBrandId,
      );
    }
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }

  bool _hasUsableShelfShareBrands(StoreShareViewModel viewModel) {
    return viewModel.shelfShareBrandList.any(
      (brand) => (brand.brandID ?? 0) > 0,
    );
  }

  List<BrandStoreShareModel> _effectiveBrandOptions(
    StoreShareViewModel viewModel,
  ) {
    final shelfShareBrands =
        viewModel.shelfShareBrandList
            .where((brand) => (brand.brandID ?? 0) > 0)
            .toList();
    if (shelfShareBrands.isNotEmpty) {
      return shelfShareBrands;
    }

    final genericBrands =
        viewModel.brandList
            .where((brand) => brand.brandId > 0)
            .map(
              (brand) => BrandStoreShareModel(
                brandID: brand.brandId,
                brandName: brand.brandName,
              ),
            )
            .toList();
    return genericBrands;
  }

  int? _initialBrandId(StoreShareViewModel viewModel) {
    final brands = _effectiveBrandOptions(viewModel);
    if (brands.isNotEmpty) {
      return brands.first.brandID;
    }

    return null;
  }

  @override
  void dispose() {
    for (final controller in _facingControllers.values) {
      controller.dispose();
    }
    for (final controller in _stockControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _summaryKey(ShelfShareBrandSummaryModel item) {
    return '${item.shelfShareId ?? 0}-${item.brandId ?? 0}';
  }

  TextEditingController _controllerFor(
    Map<String, TextEditingController> map,
    String key,
    String initialValue,
  ) {
    return map.putIfAbsent(
      key,
      () => TextEditingController(text: initialValue),
    );
  }

  Future<void> _selectBrand(int brandId) async {
    setState(() {
      _selectedBrandId = brandId;
      _expandedShelfShareId = 0;
    });
    await ref
        .read(storeShareModelProvider.notifier)
        .getShelfShareBrandSummaryByCategory(
          storeId: widget.storeId,
          productCategoryId: widget.productCategoryId,
          brandId: brandId,
        );
  }

  Future<void> _toggleExpanded(ShelfShareBrandSummaryModel item) async {
    final shelfShareId = item.shelfShareId ?? 0;
    if (shelfShareId == 0) return;

    if (_expandedShelfShareId == shelfShareId) {
      setState(() {
        _expandedShelfShareId = 0;
      });
      return;
    }

    await ref
        .read(storeShareModelProvider.notifier)
        .getShelfShareDisplayLocation(shelfShareId);

    if (!mounted) return;
    setState(() {
      _expandedShelfShareId = shelfShareId;
    });
  }

  Future<void> _pickImage(String key) async {
    if (_slotEnabled[key] != true) return;

    final source = await showDialog<ImageSource?>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          content: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF111827), Color(0xFF0B1120)],
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
                    const Text(
                      'Choose Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(dialogContext),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.camera_alt, color: Colors.white),
                  title: const Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(dialogContext, ImageSource.camera),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.photo_library, color: Colors.white),
                  title: const Text(
                    'Gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap:
                      () => Navigator.pop(dialogContext, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;
    final picked = await _imagePicker.pickImage(source: source);
    if (picked == null) return;
    if (!mounted) return;

    setState(() {
      _slotImages[key] = File(picked.path);
    });
  }

  String _slotKey(int shelfShareId, int locationId) =>
      '$shelfShareId-$locationId';

  Widget _buildPreviewButton(String key) {
    final image = _slotImages[key];
    final enabled = _slotEnabled[key] == true;

    return InkWell(
      onTap: enabled ? () => _pickImage(key) : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? Colors.grey.shade400 : Colors.grey.shade300,
          ),
        ),
        child:
            image != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(image, fit: BoxFit.cover),
                )
                : Icon(
                  enabled ? Icons.image_outlined : Icons.image_not_supported,
                  color: enabled ? Colors.grey.shade800 : Colors.grey.shade500,
                  size: 26,
                ),
      ),
    );
  }

  Widget _buildSlotRow(int shelfShareId, int locationId, String slot) {
    final key = _slotKey(shelfShareId, locationId);
    final enabled = _slotEnabled[key] == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Checkbox(
              value: enabled,
              activeColor: AppColors.primary,
              onChanged: (checked) {
                setState(() {
                  _slotEnabled[key] = checked ?? false;
                  if (checked != true) {
                    _slotImages.remove(key);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: Text(
              slot,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _buildPreviewButton(key),
        ],
      ),
    );
  }

  Future<void> _submitSummary(ShelfShareBrandSummaryModel summary) async {
    if (_submitting) return;
    final shelfShareId = summary.shelfShareId ?? 0;
    final brandId = summary.brandId ?? 0;
    final facing =
        int.tryParse(
          _controllerFor(
            _facingControllers,
            _summaryKey(summary),
            '${summary.facingCount ?? 0}',
          ).text,
        ) ??
        0;
    final stock =
        int.tryParse(
          _controllerFor(
            _stockControllers,
            _summaryKey(summary),
            '${summary.stockCount ?? 0}',
          ).text,
        ) ??
        0;

    setState(() {
      _submitting = true;
    });
    final ok = await ref
        .read(storeShareModelProvider.notifier)
        .submitShelfShareAdd(
          shelfShareId: shelfShareId,
          storeId: widget.storeId,
          productCategoryId: widget.productCategoryId,
          brandId: brandId,
          facingCount: facing,
          stockCount: stock,
        );
    if (!mounted) return;
    setState(() {
      _submitting = false;
    });
    if (ok) {
      AppSnackBar.showSuccess(context, 'Shelf share saved');
    } else {
      AppSnackBar.showError(context, 'Unable to save shelf share');
    }
  }

  Future<void> _submitLocations(ShelfShareBrandSummaryModel summary) async {
    final locations =
        ref.read(storeShareModelProvider).shelfShareDisplayLocationList;
    if (locations.isEmpty) {
      AppSnackBar.showError(context, 'No locations loaded');
      return;
    }

    for (final location in locations) {
      final key = _slotKey(
        summary.shelfShareId ?? 0,
        location.shelfShareDisplayLocationId ?? 0,
      );
      final enabled = _slotEnabled[key] == true;
      if (!enabled) continue;

      final ok = await ref
          .read(storeShareModelProvider.notifier)
          .submitShelfShareDisplayLocation(
            shelfShareDisplayId: location.shelfShareDisplayId ?? 0,
            shelfShareId: summary.shelfShareId ?? 0,
            shelfShareDisplayLocationId:
                location.shelfShareDisplayLocationId ?? 0,
            isShelfShareDisplay: true,
          );
      if (!ok) {
        AppSnackBar.showError(context, 'Unable to save location');
        return;
      }
    }

    AppSnackBar.showSuccess(context, 'Locations saved');
  }

  Widget _buildBrandCard(
    ShelfShareBrandSummaryModel summary,
    int index,
    List<ShelfShareDisplayLocationModel> locations,
  ) {
    final key = _summaryKey(summary);
    final facingController = _controllerFor(
      _facingControllers,
      key,
      '${summary.facingCount ?? 0}',
    );
    final stockController = _controllerFor(
      _stockControllers,
      key,
      '${summary.stockCount ?? 0}',
    );
    final isExpanded = _expandedShelfShareId == (summary.shelfShareId ?? 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F1F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black87, width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${index + 1}. ${summary.brandName ?? '--'}',
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const SizedBox(
                  width: 78,
                  child: Text(
                    'Facing',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const SizedBox(
                  width: 78,
                  child: Text(
                    'Stock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: 78,
                  child: TextFormField(
                    controller: facingController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 78,
                  child: TextFormField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _toggleExpanded(summary),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  isExpanded ? 'Hide Locations' : 'Show Locations',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (isExpanded)
              for (final location in locations)
                _buildSlotRow(
                  summary.shelfShareId ?? 0,
                  location.shelfShareDisplayLocationId ?? 0,
                  location.shelfShareDisplayLocationName ??
                      'Location ${location.shelfShareDisplayLocationId ?? 0}',
                ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _submitSummary(summary),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _submitLocations(summary),
                      child: const Text(
                        'Save Locations',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeShareModelProvider);
    final brandOptions = _effectiveBrandOptions(viewModel);
    final summaries = viewModel.shelfShareBrandSummaryList;
    final locations = viewModel.shelfShareDisplayLocationList;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body:
            _loading
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
                                onTap: () => NavigationService.goBack(),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Shelf Share',
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
                            widget.productCategoryName,
                            style: const TextStyle(
                              color: Color(0xFFCBD5F5),
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
                              color: Colors.white.withValues(alpha: 0.1),
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
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int?>(
                            value: _selectedBrandId,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text('All Brands'),
                              ),
                              ...brandOptions.map(
                                (brand) => DropdownMenuItem<int?>(
                                  value: brand.brandID,
                                  child: Text(brand.brandName ?? '--'),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedBrandId = value;
                                _expandedShelfShareId = 0;
                              });
                              if (value == null || value <= 0) return;
                              _selectBrand(value);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6EDEE),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.orange, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'All Brands (Select Brand)',
                                style: TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (summaries.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: Text('No shelf share data found'),
                                  ),
                                )
                              else
                                for (
                                  var index = 0;
                                  index < summaries.length;
                                  index++
                                )
                                  _buildBrandCard(
                                    summaries[index],
                                    index,
                                    _expandedShelfShareId ==
                                            (summaries[index].shelfShareId ?? 0)
                                        ? locations
                                        : const <
                                          ShelfShareDisplayLocationModel
                                        >[],
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
