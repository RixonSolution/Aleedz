import 'dart:io';

import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/store_share_summary_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/store_share_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StoreShareSummaryView extends ConsumerStatefulWidget {
  final String storeName;
  final String checkInTime;
  final int storeId;
  final int visitId;
  final int brandId;
  final int elementTypeId;
  final int elementId;
  final String elementTypeName;

  const StoreShareSummaryView({
    super.key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.visitId,
    required this.brandId,
    required this.elementTypeId,
    required this.elementId,
    required this.elementTypeName,
  });

  @override
  ConsumerState<StoreShareSummaryView> createState() =>
      _StoreShareSummaryViewState();
}

class _StoreShareSummaryViewState extends ConsumerState<StoreShareSummaryView> {
  final ImagePicker _imagePicker = ImagePicker();
  final Map<String, File> _localImages = {};
  final Set<String> _dirtyKeys = {};
  int? _selectedBrandId;
  bool _isLoading = true;
  bool _isSubmitting = false;

  String _keyForItem(StoreShareSummaryModel item) {
    final brand = item.brandId ?? 0;
    final element = item.storeShareElementId ?? 0;
    final type = item.storeShareElementTypeId ?? 0;
    return '$brand-$type-$element';
  }

  Future<void> _pickImage(StoreShareSummaryModel item) async {
    final picked = await _imagePicker.pickImage(source: ImageSource.camera);
    if (picked == null) return;
    final key = _keyForItem(item);
    setState(() {
      _localImages[key] = File(picked.path);
      _dirtyKeys.add(key);
    });
  }

  Future<void> _submitAll(StoreShareViewModel viewModel) async {
    if (_isSubmitting) return;

    final items =
        viewModel.summaryList
            .where((item) => _dirtyKeys.contains(_keyForItem(item)))
            .toList();
    if (items.isEmpty) {
      AppSnackBar.showError(context, 'Please update any item to submit.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      for (final item in items) {
        final key = _keyForItem(item);
        final image = _localImages[key];
        final success = await viewModel.submitStoreShareAdd(
          storeId: widget.storeId.toString(),
          storeShareElementId: (item.storeShareElementId ?? 0).toString(),
          brandId: (item.brandId ?? 0).toString(),
          visitId: widget.visitId.toString(),
          count: (item.quantity ?? 0).toString(),
          storeShareImage: image,
        );

        if (!success) {
          AppSnackBar.showError(
            context,
            'Unable to submit ${item.storeShareElementName ?? "item"}.',
          );
          return;
        }
        _dirtyKeys.remove(key);
        _localImages.remove(key);
      }

      AppSnackBar.showSuccess(context, 'Store share submitted successfully.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      } else {
        _isSubmitting = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final notifier = ref.read(storeShareModelProvider.notifier);
      try {
        await notifier.loadUser();
        await notifier.getBrandDropDown();
        _selectedBrandId = widget.brandId == 0 ? null : widget.brandId;
        await notifier.getStoreShareSummary(
          storeId: widget.storeId.toString(),
          brandId: (_selectedBrandId ?? 0).toString(),
          storeShareElementTypeId: widget.elementTypeId.toString(),
          storeShareElementId: widget.elementId.toString(),
          visitId: widget.visitId.toString(),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        } else {
          _isLoading = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeShareModelProvider);
    final items = viewModel.summaryList;
    final brandOptions = viewModel.brandList;
    final Map<String, List<StoreShareSummaryModel>> grouped = {};
    for (final item in items) {
      final name = (item.brandName ?? '').trim();
      final key = name.isEmpty ? 'Unknown Brand' : name;
      grouped.putIfAbsent(key, () => []).add(item);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Stack(
          children: [
            _isLoading
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
                          colors: [Color(0xFF1f2937), Color(0xFF0f172a)],
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
                                LabelService().getLabel(184),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(height: 40, width: 40),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.storeName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.elementTypeName,
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
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${LabelService().getLabel(14)} ${widget.checkInTime}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField<int>(
                        value: _selectedBrandId,
                        decoration: InputDecoration(
                          hintText: LabelService().getLabel(286),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: [
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text(LabelService().getLabel(286)),
                          ),
                          ...brandOptions.map((brand) {
                            return DropdownMenuItem<int>(
                              value: brand.brandId,
                              child: Text(brand.brandName),
                            );
                          }).toList(),
                        ],
                        onChanged:
                            brandOptions.isEmpty
                                ? null
                                : (int? brandId) async {
                                  setState(() {
                                    _isLoading = true;
                                    _selectedBrandId = brandId;
                                    _localImages.clear();
                                    _dirtyKeys.clear();
                                  });
                                  await ref
                                      .read(storeShareModelProvider.notifier)
                                      .getStoreShareSummary(
                                        storeId: widget.storeId.toString(),
                                        brandId:
                                            (_selectedBrandId ?? 0).toString(),
                                        storeShareElementTypeId:
                                            widget.elementTypeId.toString(),
                                        storeShareElementId:
                                            widget.elementId.toString(),
                                        visitId: widget.visitId.toString(),
                                      );
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } else {
                                    _isLoading = false;
                                  }
                                },
                      ),
                    ),
                    Expanded(
                      child:
                          items.isEmpty
                              ? Center(
                                child: Text(
                                  LabelService().getLabel(287),
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                              : ListView(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  120,
                                ),
                                children:
                                    grouped.entries.map((entry) {
                                      final brandItems = entry.value;
                                      final List<Widget> section = [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: Text(
                                            entry.key,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ];

                                      for (
                                        var i = 0;
                                        i < brandItems.length;
                                        i++
                                      ) {
                                        final item = brandItems[i];
                                        final itemKey = _keyForItem(item);
                                        final localImage =
                                            _localImages[itemKey];
                                        final qtyText =
                                            item.quantity?.toString() ?? '';

                                        section.add(
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0x19000000),
                                                    blurRadius: 14,
                                                    offset: Offset(0, 6),
                                                  ),
                                                ],
                                              ),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Container(
                                                      width: 35,
                                                      decoration: const BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Color(0xFF1D2B4A),
                                                            Color(0xFF1D2B4A),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end:
                                                              Alignment
                                                                  .bottomRight,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                    18,
                                                                  ),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                    18,
                                                                  ),
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '${i + 1}',
                                                          style:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              14,
                                                            ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    item.storeShareElementName ??
                                                                        '',
                                                                    style: const TextStyle(
                                                                      color: Color(
                                                                        0xFF111827,
                                                                      ),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 120,
                                                                    child: TextFormField(
                                                                      initialValue:
                                                                          qtyText,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      enabled:
                                                                          _selectedBrandId !=
                                                                          null,
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter
                                                                            .digitsOnly,
                                                                        LengthLimitingTextInputFormatter(
                                                                          3,
                                                                        ),
                                                                      ],
                                                                      onChanged: (
                                                                        value,
                                                                      ) {
                                                                        _dirtyKeys.add(
                                                                          _keyForItem(
                                                                            item,
                                                                          ),
                                                                        );
                                                                        item.quantity =
                                                                            int.tryParse(
                                                                              value,
                                                                            );
                                                                      },
                                                                      decoration: InputDecoration(
                                                                        hintText:
                                                                            'Qty',
                                                                        isDense:
                                                                            true,
                                                                        contentPadding: const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              10,
                                                                        ),
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                          borderSide: BorderSide(
                                                                            color:
                                                                                Colors.grey.shade300,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 12,
                                                            ),
                                                            GestureDetector(
                                                              onTap:
                                                                  _selectedBrandId ==
                                                                          null
                                                                      ? null
                                                                      : () =>
                                                                          _pickImage(
                                                                            item,
                                                                          ),
                                                              child: Container(
                                                                width: 80,
                                                                height: 80,
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      _selectedBrandId ==
                                                                              null
                                                                          ? Colors
                                                                              .grey
                                                                              .shade200
                                                                          : Colors
                                                                              .grey
                                                                              .shade100,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                  image:
                                                                      localImage !=
                                                                              null
                                                                          ? DecorationImage(
                                                                            image: FileImage(
                                                                              localImage,
                                                                            ),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )
                                                                          : null,
                                                                ),
                                                                child:
                                                                    localImage ==
                                                                            null
                                                                        ? const Icon(
                                                                          Icons
                                                                              .camera_alt,
                                                                          color:
                                                                              Colors.grey,
                                                                        )
                                                                        : null,
                                                              ),
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
                                        );
                                      }

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: section,
                                      );
                                    }).toList(),
                              ),
                    ),
                  ],
                ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child:
                  (!_isSubmitting &&
                          (_isLoading ||
                              _selectedBrandId == null ||
                              _dirtyKeys.isEmpty))
                      ? const SizedBox.shrink()
                      : SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed:
                              _isSubmitting
                                  ? null
                                  : () => _submitAll(viewModel),
                          child:
                              _isSubmitting
                                  ? LoadingAnimationWidget.discreteCircle(
                                    color: Colors.white,
                                    size: 24,
                                  )
                                  : Text(
                                    LabelService().getLabel(24),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
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
