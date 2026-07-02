import 'dart:io';

import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
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
  final Map<String, List<ShelfShareDisplayLocationModel>> _locationsByCard = {};
  final Map<String, bool> _locationLoadingByCard = {};
  final Map<String, bool> _submittingByCard = {};

  int _selectedBrandId = 0;
  bool _loading = true;
  bool _filterLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  Future<void> _loadData() async {
    if (mounted) {
      setState(() {
        _slotEnabled.clear();
        _slotImages.clear();
        _locationsByCard.clear();
        _locationLoadingByCard.clear();
        _submittingByCard.clear();
        _selectedBrandId = 0;
      });
    }
    final notifier = ref.read(storeShareModelProvider.notifier);
    await notifier.loadUser();
    await notifier.getShelfShareAllBrands();
    await _loadSummaryForBrand(0);
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
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

  String _slotKey(String summaryKey, int locationId) => '$summaryKey-$locationId';

  List<ShelfShareBrandSummaryModel> _orderedSummaries(
    StoreShareViewModel viewModel,
  ) {
    final summaries = List<ShelfShareBrandSummaryModel>.from(
      viewModel.shelfShareBrandSummaryList,
    );
    final brandOrder = <int, int>{};
    for (var i = 0; i < viewModel.shelfShareBrandList.length; i++) {
      brandOrder[viewModel.shelfShareBrandList[i].brandID ?? 0] = i;
    }

    summaries.sort((a, b) {
      final aOrder = brandOrder[a.brandId ?? 0] ?? 1 << 30;
      final bOrder = brandOrder[b.brandId ?? 0] ?? 1 << 30;
      return aOrder.compareTo(bOrder);
    });
    return summaries;
  }

  Future<void> _loadCardLocations(StoreShareViewModel notifier) async {
    final summaries = List<ShelfShareBrandSummaryModel>.from(
      notifier.shelfShareBrandSummaryList,
    );
    if (summaries.isEmpty) return;

    if (!mounted) return;
    setState(() {
      for (final summary in summaries) {
        _locationLoadingByCard[_summaryKey(summary)] = true;
      }
    });

    for (final summary in summaries) {
      final key = _summaryKey(summary);
      await notifier.getShelfShareDisplayLocation(summary.shelfShareId ?? 0);
      if (!mounted) return;

      final locations = List<ShelfShareDisplayLocationModel>.from(
        ref.read(storeShareModelProvider).shelfShareDisplayLocationList,
      );

      setState(() {
        _locationsByCard[key] = locations;
        _locationLoadingByCard[key] = false;
        for (final location in locations) {
          final slotKey = _slotKey(
            key,
            location.shelfShareDisplayLocationId ?? 0,
          );
          final enabled = (location.isShelfShareDisplay ?? 0) == 1;
          _slotEnabled[slotKey] = enabled;
          if (!enabled) {
            _slotImages.remove(slotKey);
          }
        }
      });
    }
  }

  Future<void> _loadSummaryForBrand(int brandId) async {
    final notifier = ref.read(storeShareModelProvider.notifier);
    await notifier.getShelfShareBrandSummaryByCategory(
      storeId: widget.storeId,
      productCategoryId: widget.productCategoryId,
      brandId: brandId,
      visitId: widget.visitId,
    );
    if (!mounted) return;
    await _loadCardLocations(notifier);
  }

  Future<void> _selectBrand(int brandId) async {
    if (mounted) {
      setState(() {
        _selectedBrandId = brandId;
        _filterLoading = true;
        _slotEnabled.clear();
        _slotImages.clear();
        _locationsByCard.clear();
        _locationLoadingByCard.clear();
        _submittingByCard.clear();
      });
    }

    await _loadSummaryForBrand(brandId);

    if (!mounted) return;
    setState(() {
      _filterLoading = false;
    });
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

  Future<void> _pickImage(String key, bool enabled) async {
    if (!enabled) return;

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

  Widget _buildPreviewButton(String key, bool enabled) {
    final image = _slotImages[key];

    return InkWell(
      onTap: enabled ? () => _pickImage(key, enabled) : null,
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

  Widget _buildSlotRow(
    String summaryKey,
    ShelfShareDisplayLocationModel location,
  ) {
    final locationId = location.shelfShareDisplayLocationId ?? 0;
    final key = _slotKey(summaryKey, locationId);
    final enabled = (location.isShelfShareDisplay ?? 0) == 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: enabled ? const Color(0xFFEFF6FF) : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: enabled ? AppColors.primary : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Icon(
              enabled ? Icons.check_rounded : Icons.remove,
              size: enabled ? 14 : 10,
              color: enabled ? AppColors.primary : Colors.transparent,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              location.shelfShareDisplayLocationName ??
                  'Location $locationId',
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _buildPreviewButton(key, enabled),
        ],
      ),
    );
  }

  Future<bool> _submitSummary(ShelfShareBrandSummaryModel summary) async {
    final key = _summaryKey(summary);
    if (_submittingByCard[key] == true) return false;
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
      _submittingByCard[key] = true;
    });
    final ok = await ref.read(storeShareModelProvider.notifier).submitShelfShareAdd(
          shelfShareId: shelfShareId,
          storeId: widget.storeId,
          productCategoryId: widget.productCategoryId,
          brandId: brandId,
          facingCount: facing,
          stockCount: stock,
          visitId: widget.visitId,
        );
    if (!mounted) return false;
    setState(() {
      _submittingByCard[key] = false;
    });
    if (ok) {
      AppSnackBar.showSuccess(context, 'Shelf share saved');
      return true;
    }
    AppSnackBar.showError(context, 'Unable to save shelf share');
    return false;
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
    final isLoadingLocations = _locationLoadingByCard[key] == true;
    final isSubmitting = _submittingByCard[key] == true;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. ${summary.brandName ?? '--'}',
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const SizedBox(
                  width: 68,
                  child: Text(
                    'Facing',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const SizedBox(
                  width: 68,
                  child: Text(
                    'Stock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
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
                  width: 68,
                  child: TextFormField(
                    controller: facingController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
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
                  width: 68,
                  child: TextFormField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
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
              if (isLoadingLocations)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else if (locations.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'No locations available',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else
              for (final location in locations)
                _buildSlotRow(key, location),
            const SizedBox(height: 6),
            Center(
              child: SizedBox(
                width: 140,
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7931E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    await _submitSummary(summary);
                  },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeShareModelProvider);
    final summaries = _orderedSummaries(viewModel);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: _loading
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadData,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
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
                fontSize: 15,
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
                fontSize: 12,
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
                        child: DropdownButtonFormField<int>(
                          initialValue: _selectedBrandId,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            hintText: 'Select Brand',
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: [
                            const DropdownMenuItem<int>(
                              value: 0,
                              child: Text('All Brands'),
                            ),
                            ...viewModel.shelfShareBrandList.map(
                              (brand) => DropdownMenuItem<int>(
                                value: brand.brandID ?? 0,
                                child: Text(brand.brandName ?? '--'),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _selectBrand(value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                              if (_filterLoading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                )
                              else if (summaries.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: Text('No shelf share data found'),
                                  ),
                                )
                              else
                                for (var index = 0; index < summaries.length; index++)
                                  _buildBrandCard(
                                    summaries[index],
                                    index,
                                    _locationsByCard[_summaryKey(summaries[index])] ??
                                        const <ShelfShareDisplayLocationModel>[],
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }
}
