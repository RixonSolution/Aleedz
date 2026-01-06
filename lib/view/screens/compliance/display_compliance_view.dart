import 'dart:io';

import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/viewmodel/sale_viewmodel.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DisplayComplianceView extends ConsumerStatefulWidget {
  final String storeName;
  final String checkInTime;
  final int storeId;
  final int visiteId;

  const DisplayComplianceView({
    super.key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.visiteId,
  });

  @override
  ConsumerState<DisplayComplianceView> createState() =>
      _DisplayComplianceViewState();
}

class _WordLimitFormatter extends TextInputFormatter {
  _WordLimitFormatter(this.maxWords);

  final int maxWords;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final words = RegExp(r'\S+').allMatches(newValue.text).toList();
    if (words.length <= maxWords) {
      return newValue;
    }

    final endIndex = words[maxWords - 1].end;
    final truncated = newValue.text.substring(0, endIndex).trimRight();
    return TextEditingValue(
      text: truncated,
      selection: TextSelection.collapsed(offset: truncated.length),
    );
  }
}

class _DisplayComplianceViewState extends ConsumerState<DisplayComplianceView> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _remarksController = TextEditingController();
  bool _isSubmitting = false;

  InputDecoration _sheetInputDecoration(String hint, {Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: const Color(0xFFF7F8FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Widget _optionButtons({
    required bool? value,
    required void Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          _optionButton(
            label: LabelService().getLabel(95),
            selected: value == true,
            onTap: () => onChanged(true),
          ),
          _optionButton(
            label: LabelService().getLabel(94),
            selected: value == false,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }

  Widget _optionButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showImagePickerDialog(StoreViewModel viewModel) {
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
                    final pickedImage = await _imagePicker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedImage != null &&
                        viewModel.displayComplianceImages.length < 4) {
                      viewModel.displayComplianceImages.add(
                        File(pickedImage.path),
                      );
                      viewModel.notifyListeners();
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
                    final pickedImages = await _imagePicker.pickMultiImage();
                    if (pickedImages.isNotEmpty) {
                      for (var image in pickedImages) {
                        if (viewModel.displayComplianceImages.length >= 4) {
                          break;
                        }
                        viewModel.displayComplianceImages.add(File(image.path));
                      }
                      viewModel.notifyListeners();
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

  void _showSwipeHintSnack() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.swipe_left, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                LabelService().getLabel(202),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _openAddComplianceSheet(
    StoreViewModel viewModel,
    SaleViewModel saleViewModel,
  ) {
    bool? displayYes;
    bool? guidelineYes;
    bool? posmYes;
    int? selectedLocationId;
    final quantityController = TextEditingController(text: '1');
    _remarksController.clear();
    _isSubmitting = false;
    saleViewModel.selectedBrand = null;
    saleViewModel.selectedProductCategory = null;
    saleViewModel.selectedSaleSearch = null;
    saleViewModel.productCategory = [];
    saleViewModel.saleSearch = [];
    saleViewModel.notifyListeners();
    viewModel.displayComplianceImages.clear();
    viewModel.notifyListeners();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Builder(
              builder: (sheetContext) {
                void showSheetError(String message) {
                  final messenger = ScaffoldMessenger.of(sheetContext);
                  messenger.hideCurrentSnackBar();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }

                return StatefulBuilder(
                  builder: (context, setModalState) {
                    return AnimatedBuilder(
                      animation: Listenable.merge([saleViewModel, viewModel]),
                      builder: (context, _) {
                        final locationOptions =
                            viewModel.displayLocationList
                                .where(
                                  (item) =>
                                      item.displayLocationId != null &&
                                      (item.displayLocationName ?? '')
                                          .isNotEmpty,
                                )
                                .toList();
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(ctx).viewInsets.bottom,
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                16,
                                20,
                                36,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LabelService().getLabel(197),
                                        style: const TextStyle(
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
                                  Divider(
                                    color: Colors.grey.shade300,
                                    height: 1,
                                  ),
                                  const SizedBox(height: 16),

                                  Text(
                                    LabelService().getLabel(133),
                                    style: TextStyle(
                                      color: Color(0xFF111827),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<int>(
                                    value: saleViewModel.selectedBrand?.brandId,
                                    decoration: _sheetInputDecoration(
                                      LabelService().getLabel(133),
                                    ),
                                    items:
                                        saleViewModel.brandList
                                            .map(
                                              (brand) => DropdownMenuItem<int>(
                                                value: brand.brandId,
                                                child: Text(brand.brandName),
                                              ),
                                            )
                                            .toList(),
                                    onChanged:
                                        saleViewModel.brandList.isEmpty
                                            ? null
                                            : (int? brandId) async {
                                              if (brandId == null) return;
                                              final selected = saleViewModel
                                                  .brandList
                                                  .firstWhere(
                                                    (c) => c.brandId == brandId,
                                                  );
                                              await saleViewModel.selectBrand(
                                                widget.storeId,
                                                selected,
                                              );
                                              if (!ctx.mounted) return;
                                              setModalState(() {});
                                            },
                                  ),
                                  const SizedBox(height: 14),

                                  Text(
                                    LabelService().getLabel(214),
                                    style: TextStyle(
                                      color: Color(0xFF111827),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<int>(
                                    value:
                                        saleViewModel
                                            .selectedProductCategory
                                            ?.productCategoryID,
                                    isExpanded: true,
                                    decoration: _sheetInputDecoration(
                                      LabelService().getLabel(214),
                                    ),
                                    items:
                                        saleViewModel.productCategory
                                            .map(
                                              (
                                                category,
                                              ) => DropdownMenuItem<int>(
                                                value:
                                                    category.productCategoryID,
                                                child: Text(
                                                  category.productCategoryName ??
                                                      '',
                                                ),
                                              ),
                                            )
                                            .toList(),
                                    onChanged:
                                        saleViewModel.productCategory.isEmpty
                                            ? null
                                            : (int? categoryId) async {
                                              if (categoryId == null) return;
                                              final selected = saleViewModel
                                                  .productCategory
                                                  .firstWhere(
                                                    (c) =>
                                                        c.productCategoryID ==
                                                        categoryId,
                                                  );
                                              await saleViewModel
                                                  .selectProductCategory(
                                                    widget.storeId,
                                                    selected,
                                                  );
                                              if (!ctx.mounted) return;
                                              setModalState(() {});
                                            },
                                  ),
                                  const SizedBox(height: 14),

                                  Text(
                                    LabelService().getLabel(215),
                                    style: TextStyle(
                                      color: Color(0xFF111827),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownSearch<int>(
                                    items:
                                        saleViewModel.saleSearch
                                            .map((model) => model.productID!)
                                            .toList(),
                                    selectedItem:
                                        saleViewModel
                                            .selectedSaleSearch
                                            ?.productID,
                                    itemAsString: (int id) {
                                      final model = saleViewModel.saleSearch
                                          .firstWhere((m) => m.productID == id);
                                      return model.productModelName ?? '';
                                    },
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              _sheetInputDecoration(
                                                'Type to search products...',
                                                prefixIcon: const Icon(
                                                  Icons.search,
                                                ),
                                              ),
                                        ),
                                    popupProps: PopupProps.menu(
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                        decoration: _sheetInputDecoration(
                                          LabelService().getLabel(135),
                                        ),
                                      ),
                                    ),
                                    onChanged:
                                        saleViewModel.saleSearch.isEmpty
                                            ? null
                                            : (int? id) {
                                              if (id == null) return;
                                              final selected = saleViewModel
                                                  .saleSearch
                                                  .firstWhere(
                                                    (m) => m.productID == id,
                                                  );
                                              saleViewModel.selectSearchModel(
                                                selected,
                                              );
                                              setModalState(() {});
                                            },
                                  ),
                                  const SizedBox(height: 14),

                                  Text(
                                    LabelService().getLabel(216),
                                    style: TextStyle(
                                      color: Color(0xFF111827),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<int>(
                                    value: selectedLocationId,
                                    decoration: _sheetInputDecoration(
                                      LabelService().getLabel(216),
                                    ),
                                    items:
                                        locationOptions
                                            .map(
                                              (item) => DropdownMenuItem<int>(
                                                value: item.displayLocationId,
                                                child: Text(
                                                  item.displayLocationName ??
                                                      '',
                                                ),
                                              ),
                                            )
                                            .toList(),
                                    onChanged:
                                        locationOptions.isEmpty
                                            ? null
                                            : (int? locationId) {
                                              setModalState(() {
                                                selectedLocationId = locationId;
                                              });
                                            },
                                  ),
                                  const SizedBox(height: 18),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LabelService().getLabel(198),
                                        style: const TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      _optionButtons(
                                        value: displayYes,
                                        onChanged: (value) {
                                          setModalState(() {
                                            displayYes = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LabelService().getLabel(199),
                                        style: const TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      _optionButtons(
                                        value: guidelineYes,
                                        onChanged: (value) {
                                          setModalState(() {
                                            guidelineYes = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LabelService().getLabel(200),
                                        style: const TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      _optionButtons(
                                        value: posmYes,
                                        onChanged: (value) {
                                          setModalState(() {
                                            posmYes = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LabelService().getLabel(201),
                                        style: const TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: TextField(
                                          controller: quantityController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(3),
                                          ],
                                          decoration: _sheetInputDecoration(
                                            '1',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    LabelService().getLabel(217),
                                    style: TextStyle(
                                      color: Color(0xFF111827),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _remarksController,
                                    maxLines: 2,
                                    minLines: 1,
                                    inputFormatters: [_WordLimitFormatter(100)],
                                    decoration: _sheetInputDecoration(
                                      LabelService().getLabel(217),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    LabelService().getLabel(218),
                                    style: TextStyle(
                                      color: Color(0xFF111827),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (viewModel
                                                  .displayComplianceImages
                                                  .length <
                                              4) {
                                            _showImagePickerDialog(viewModel);
                                          } else {
                                            showSheetError(
                                              LabelService().getLabel(114),
                                            );
                                          }
                                        },
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          height: 80,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                viewModel
                                                    .displayComplianceImages
                                                    .length,
                                            itemBuilder: (context, index) {
                                              final file =
                                                  viewModel
                                                      .displayComplianceImages[index];
                                              return Stack(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          right: 10,
                                                        ),
                                                    height: 70,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      image: DecorationImage(
                                                        image: FileImage(file),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 4,
                                                    right: 4,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        viewModel
                                                            .displayComplianceImages
                                                            .removeAt(index);
                                                        viewModel
                                                            .notifyListeners();
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                              color:
                                                                  AppColors
                                                                      .secondary,
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
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 46,
                                    child:
                                        _isSubmitting
                                            ? Center(
                                              child:
                                                  LoadingAnimationWidget.discreteCircle(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                    size: 32,
                                                  ),
                                            )
                                            : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primary,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (saleViewModel
                                                        .selectedBrand ==
                                                    null) {
                                                  showSheetError(
                                                    'Please select brand',
                                                  );
                                                  return;
                                                }
                                                if (saleViewModel
                                                        .selectedProductCategory ==
                                                    null) {
                                                  showSheetError(
                                                    'Please select category',
                                                  );
                                                  return;
                                                }
                                                if (saleViewModel
                                                        .selectedSaleSearch ==
                                                    null) {
                                                  showSheetError(
                                                    'Please select model',
                                                  );
                                                  return;
                                                }
                                                if (selectedLocationId ==
                                                    null) {
                                                  showSheetError(
                                                    'Please select location',
                                                  );
                                                  return;
                                                }
                                                if (displayYes == null) {
                                                  showSheetError(
                                                    'Please select display',
                                                  );
                                                  return;
                                                }
                                                if (guidelineYes == null) {
                                                  showSheetError(
                                                    'Please select guideline',
                                                  );
                                                  return;
                                                }
                                                if (posmYes == null) {
                                                  showSheetError(
                                                    'Please select POSM',
                                                  );
                                                  return;
                                                }
                                                if (quantityController
                                                    .text
                                                    .isEmpty) {
                                                  showSheetError(
                                                    'Please enter quantity',
                                                  );
                                                  return;
                                                }
                                                if (_remarksController
                                                    .text
                                                    .isEmpty) {
                                                  showSheetError(
                                                    'Please enter remarks',
                                                  );
                                                  return;
                                                }
                                                if (viewModel
                                                    .displayComplianceImages
                                                    .isEmpty) {
                                                  showSheetError(
                                                    LabelService().getLabel(
                                                      115,
                                                    ),
                                                  );
                                                  return;
                                                }

                                                bool sheetClosed = false;
                                                setState(() {
                                                  _isSubmitting = true;
                                                });
                                                setModalState(() {});

                                                try {
                                                  final success = await viewModel
                                                      .submitDisplayCompliance(
                                                        storeId:
                                                            widget.storeId
                                                                .toString(),
                                                        productId:
                                                            saleViewModel
                                                                .selectedSaleSearch
                                                                ?.productID
                                                                .toString() ??
                                                            '0',
                                                        displayLocationId:
                                                            selectedLocationId
                                                                .toString(),
                                                        display:
                                                            displayYes == true
                                                                ? 1
                                                                : 0,
                                                        displayGuidlineId:
                                                            guidelineYes == true
                                                                ? 1
                                                                : 0,
                                                        posmAvailable:
                                                            posmYes == true
                                                                ? 1
                                                                : 0,
                                                        quantity:
                                                            quantityController
                                                                .text,
                                                        remarks:
                                                            _remarksController
                                                                .text,
                                                        visitId:
                                                            widget.visiteId
                                                                .toString(),
                                                        pictureId: '1',
                                                        images:
                                                            viewModel
                                                                .displayComplianceImages,
                                                      );

                                                  if (!success) {
                                                    showSheetError(
                                                      'Unable to submit display compliance',
                                                    );
                                                    return;
                                                  }

                                                  _remarksController.clear();
                                                  quantityController.text = '1';
                                                  viewModel
                                                      .displayComplianceImages
                                                      .clear();
                                                  await viewModel
                                                      .getDisplayComplianceList(
                                                        storeId:
                                                            widget.storeId
                                                                .toString(),
                                                        displayLocationId: '0',
                                                        brandId: '0',
                                                        visitId:
                                                            widget.visiteId
                                                                .toString(),
                                                      );

                                                  if (mounted) {
                                                    sheetClosed = true;
                                                    Navigator.of(ctx).pop();
                                                  }
                                                } finally {
                                                  if (mounted) {
                                                    setState(() {
                                                      _isSubmitting = false;
                                                    });
                                                    if (!sheetClosed) {
                                                      setModalState(() {});
                                                    }
                                                  } else {
                                                    _isSubmitting = false;
                                                  }
                                                }
                                              },
                                              child: Text(
                                                LabelService().getLabel(24),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _addComplianceButton(
    StoreViewModel viewModel,
    SaleViewModel saleViewModel,
  ) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: GestureDetector(
            onTap: () => _openAddComplianceSheet(viewModel, saleViewModel),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  LabelService().getLabel(219),
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

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final notifier = ref.read(storeModelProvider.notifier);
      final saleNotifier = ref.read(saleModelProvider.notifier);
      notifier.loader = true;
      notifier.notifyListeners();
      await notifier.loadUser();
      await notifier.getDisplayLocationList();
      await saleNotifier.loadUser();
      await saleNotifier.getBrandDropDown();
      await notifier.getDisplayComplianceList(
        storeId: widget.storeId.toString(),
        displayLocationId: '0',
        brandId: '0',
        visitId: widget.visiteId.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeModelProvider);
    final saleViewModel = ref.watch(saleModelProvider);
    final items = viewModel.displayComplianceList;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Stack(
          children: [
            Column(
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
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            LabelService().getLabel(197),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                            onPressed: _showSwipeHintSnack,
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
                Expanded(
                  child:
                      viewModel.loader
                          ? Center(
                            child: LoadingAnimationWidget.discreteCircle(
                              color: Theme.of(context).colorScheme.primary,
                              size: 32,
                            ),
                          )
                          : ListView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                            children: [
                              if (items.isEmpty)
                                Center(
                                  child: Text(
                                    LabelService().getLabel(220),
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ListView.builder(
                                itemCount: items.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  final dateLabel = item.formattedDate;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Dismissible(
                                      key: ValueKey(
                                        item.displayComplianceId ??
                                            '${item.brandName}_$index',
                                      ),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) async {
                                        if (direction !=
                                            DismissDirection.endToStart) {
                                          return false;
                                        }
                                        final id =
                                            item.displayComplianceId
                                                ?.toString();
                                        if (id == null) {
                                          AppSnackBar.showError(
                                            context,
                                            'Unable to remove this record',
                                          );
                                          return false;
                                        }

                                        final success = await viewModel
                                            .deleteDisplayCompliance(
                                              displayComplianceId: id,
                                            );
                                        if (!success) {
                                          AppSnackBar.showError(
                                            context,
                                            'Unable to remove this record',
                                          );
                                          return false;
                                        }
                                        await viewModel
                                            .getDisplayComplianceList(
                                              storeId:
                                                  widget.storeId.toString(),
                                              displayLocationId: '0',
                                              brandId: '0',
                                              visitId:
                                                  widget.visiteId.toString(),
                                            );
                                        return true;
                                      },
                                      background: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.swipe_left,
                                          color: Colors.grey,
                                          size: 24,
                                        ),
                                      ),
                                      secondaryBackground: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 28,
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
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
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                width: 35,
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFF1D2B4A),
                                                      Color(0xFF1D2B4A),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(18),
                                                        bottomLeft:
                                                            Radius.circular(18),
                                                      ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    14,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              item.brandName ??
                                                                  '',
                                                              style: const TextStyle(
                                                                color: Color(
                                                                  0xFF111827,
                                                                ),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              item.displayLocationName ??
                                                                  '',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .grey
                                                                        .shade600,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              item.productCategoryName ??
                                                                  '',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .grey
                                                                        .shade600,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              '${LabelService().getLabel(162)}: ${item.quantity ?? 0}',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .grey
                                                                        .shade600,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                            if (dateLabel
                                                                .isNotEmpty)
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          6,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .secondary
                                                                      .withOpacity(
                                                                        0.08,
                                                                      ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                                child: Text(
                                                                  dateLabel,
                                                                  style: const TextStyle(
                                                                    color: Color(
                                                                      0xFF111827,
                                                                    ),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Container(
                                                        width: 90,
                                                        height: 100,
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade200,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.image_outlined,
                                                          color: Colors.black45,
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
                                },
                              ),
                            ],
                          ),
                ),
              ],
            ),
            if (widget.visiteId != 0)
              _addComplianceButton(viewModel, saleViewModel),
          ],
        ),
      ),
    );
  }
}
