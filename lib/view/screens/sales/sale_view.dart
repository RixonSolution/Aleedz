import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/sale_viewmodel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SaleView extends ConsumerStatefulWidget {
  String storeName, checkInTime, address;
  int storeId;
  SaleView({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.address,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<SaleView> createState() => _DisplayAuditCheckSummaryState();
}

class _DisplayAuditCheckSummaryState extends ConsumerState<SaleView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      String formattedDate2 = DateFormat(
        'yyyy-MM-dd',
      ).format(_selectedDate); // e.g., 2025-06-05

      ref
          .read(saleModelProvider.notifier)
          .loadsale(context, widget.storeId.toString(), formattedDate2);
    });

    clcTotal();
  }

  void clcTotal() {
    totalQuantity = 0;
    totalPrice = 0;
    for (var item in ref.read(saleModelProvider.notifier).saleList) {
      final qty = int.tryParse(item.saleQuantity?.toString() ?? '0') ?? 0;
      final price = double.tryParse(item.saleValue?.toString() ?? '0') ?? 0;

      totalQuantity += qty;
      totalPrice += qty * price;
    }
  }

  FocusNode remarksFocus = FocusNode();

  bool deleteLoader = false;

  DateTime _selectedDate = DateTime.now();

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  final NumberFormat _amountFormatter = NumberFormat('#,##0.##');

  String _formatAmount(num value) => _amountFormatter.format(value);

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  void calculateTotal() {
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0.0;
    final total = quantity * price;

    totalController.text = total.toStringAsFixed(2);
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF111827), Color(0xFF0B1120)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LabelService().getLabel(265),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  LabelService().getLabel(266),
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
                        foregroundColor: AppColors.whiteColor,
                      ),
                      onPressed:
                          () =>
                              Navigator.of(context).pop(false), // Close dialog
                      child: Text(LabelService().getLabel(102)),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(LabelService().getLabel(100)),
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

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    void Function(String)? onChanged,
    int? maxLength,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: label,
            filled: true,
            counterText: "", // hides character counter
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    quantityController.dispose();
    priceController.dispose();
    totalController.dispose();
    super.dispose();
  }

  bool _isFutureDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final candidate = DateTime(date.year, date.month, date.day);
    return candidate.isAfter(today);
  }

  void _updateDate(DateTime date, SaleViewModel viewModel) {
    setState(() {
      _selectedDate = date;
    });
    final formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(date); // backend expects this format
    viewModel.loadsale(context, widget.storeId.toString(), formattedDate);
  }

  Future<void> _openDatePicker(SaleViewModel viewModel) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year, now.month, now.day),
    );

    if (pickedDate != null) {
      _updateDate(pickedDate, viewModel);
    }
  }

  void _changeDateBy(int days, SaleViewModel viewModel) {
    final candidate = _selectedDate.add(Duration(days: days));
    if (days > 0 && _isFutureDate(candidate)) return;
    _updateDate(candidate, viewModel);
  }

  Widget _arrowButton({required IconData icon, required VoidCallback? onTap}) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFF4F5F7) : const Color(0xFFE9E9EC),
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

  Widget _dateSelector(SaleViewModel viewModel) {
    final displayDate = DateFormat('dd MMMM yyyy').format(_selectedDate);
    final canGoForward =
        !_isFutureDate(_selectedDate.add(const Duration(days: 1)));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _arrowButton(
                icon: Icons.chevron_left,
                onTap: () => _changeDateBy(-1, viewModel),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _openDatePicker(viewModel),
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
                onTap: canGoForward ? () => _changeDateBy(1, viewModel) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _saleCard({
    required SaleViewModel viewModel,
    required int index,
    required String formattedDate2,
  }) {
    final item = viewModel.saleList[index];
    final double qty = _toDouble(item.saleQuantity);
    final double price = _toDouble(item.saleValue);
    final double lineTotal = qty * price;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Dismissible(
        key: ValueKey(item.saleId ?? '${item.productModelCode}_$index'),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          if (direction != DismissDirection.endToStart) return false;

          final shouldDelete = await _showDeleteDialog(context);
          if (!shouldDelete) return false;

          viewModel.loader = true;
          viewModel.notifyListeners();

          await viewModel.deleteSale(
            context,
            storeId: widget.storeId.toString(),
            saleId: item.saleId.toString(),
          );
          await viewModel.saleView(
            context,
            storeId: widget.storeId.toString(),
            saleDate: formattedDate2,
          );
          clcTotal();

          viewModel.loader = false;
          viewModel.notifyListeners();
          return true;
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.swipe_left, color: Colors.grey, size: 24),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.delete, color: Colors.red, size: 28),
        ),
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 35,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 29, 43, 74),
                        Color.fromARGB(255, 29, 43, 74),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productModelName ?? '-',
                                style: const TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${LabelService().getLabel(267)} ${item.productModelCode ?? '-'}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${LabelService().getLabel(268)} ${_formatAmount(price)}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${LabelService().getLabel(269)} ${_formatAmount(qty)}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatAmount(lineTotal),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
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
    );
  }

  Widget _summaryRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(SaleViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF0B1120)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryRow('Total Items', _formatAmount(totalQuantity)),
          Divider(color: Colors.white.withOpacity(0.16), height: 18),
          _summaryRow(
            'Products Sold',
            _formatAmount(viewModel.saleList.length),
          ),
          Divider(color: Colors.white.withOpacity(0.16), height: 18),
          _summaryRow(
            LabelService().getLabel(270),
            _formatAmount(totalPrice),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
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

  InputDecoration _sheetInputDecoration(String hint, {Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefix,
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

  Widget _totalAmountTile(double amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF0B1120)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            LabelService().getLabel(270),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${_formatAmount(amount)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  void _openAddSaleSheet(SaleViewModel viewModel) {
    if (quantityController.text.isEmpty) {
      quantityController.text = '1';
    }
    viewModel.selectedBrand = null;
    viewModel.selectedProductCategory = null;
    viewModel.selectedSaleSearch = null;
    viewModel.productCategory = [];
    viewModel.saleSearch = [];
    viewModel.notifyListeners();
    calculateTotal();
    bool isSubmitting = false;
    final saleDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

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
            return AnimatedBuilder(
              animation: viewModel,
              builder: (context, _) {
                final totalAmount =
                    _toDouble(quantityController.text) *
                    _toDouble(priceController.text);

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
                                LabelService().getLabel(271),
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

                          _fieldLabel(LabelService().getLabel(49)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            value: viewModel.selectedBrand?.brandId,
                            decoration: _sheetInputDecoration(
                              LabelService().getLabel(133),
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
                            onChanged:
                                (viewModel.brandList.isEmpty)
                                    ? null
                                    : (int? brandId) async {
                                      if (brandId == null) return;
                                      final selected = viewModel.brandList
                                          .firstWhere(
                                            (c) => c.brandId == brandId,
                                          );
                                      await viewModel.selectBrand(
                                        widget.storeId,
                                        selected,
                                      );
                                      setModalState(() {});
                                    },
                          ),

                          const SizedBox(height: 16),
                          _fieldLabel('Category'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            value:
                                viewModel
                                    .selectedProductCategory
                                    ?.productCategoryID,
                            isExpanded: true,
                            decoration: _sheetInputDecoration(
                              LabelService().getLabel(255),
                            ),
                            items:
                                viewModel.productCategory
                                    .map(
                                      (category) => DropdownMenuItem<int>(
                                        value: category.productCategoryID,
                                        child: Text(
                                          category.productCategoryName ?? '',
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                viewModel.productCategory.isEmpty
                                    ? null
                                    : (int? categoryId) async {
                                      if (categoryId != null) {
                                        final selected = viewModel
                                            .productCategory
                                            .firstWhere(
                                              (c) =>
                                                  c.productCategoryID ==
                                                  categoryId,
                                            );
                                        await viewModel.selectProductCategory(
                                          widget.storeId,
                                          selected,
                                        );
                                        setModalState(() {});
                                      }
                                    },
                          ),

                          const SizedBox(height: 16),
                          _fieldLabel('Search Product'),
                          const SizedBox(height: 8),
                          DropdownSearch<int>(
                            items:
                                viewModel.saleSearch
                                    .map((model) => model.productID!)
                                    .toList(),
                            selectedItem:
                                viewModel.selectedSaleSearch?.productID,
                            itemAsString: (int id) {
                              final model = viewModel.saleSearch.firstWhere(
                                (m) => m.productID == id,
                              );
                              return model.productModelName ?? '';
                            },
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: _sheetInputDecoration(
                                'Type to search products...',
                                prefix: const Icon(Icons.search),
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
                                viewModel.saleSearch.isEmpty
                                    ? null
                                    : (int? id) {
                                      if (id != null) {
                                        final selected = viewModel.saleSearch
                                            .firstWhere(
                                              (m) => m.productID == id,
                                            );
                                        viewModel.selectSearchModel(selected);
                                        setModalState(() {});
                                      }
                                    },
                          ),

                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _fieldLabel(LabelService().getLabel(160)),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: quantityController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 4,
                                      onChanged: (_) {
                                        calculateTotal();
                                        setModalState(() {});
                                      },
                                      decoration: _sheetInputDecoration(
                                        '1',
                                      ).copyWith(counterText: ''),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _fieldLabel(LabelService().getLabel(171)),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: priceController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 7,
                                      onChanged: (_) {
                                        calculateTotal();
                                        setModalState(() {});
                                      },
                                      decoration: _sheetInputDecoration(
                                        '0',
                                      ).copyWith(counterText: ''),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),
                          _totalAmountTile(totalAmount),
                          const SizedBox(height: 18),

                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: InkWell(
                              onTap:
                                  isSubmitting
                                      ? null
                                      : () async {
                                        if (viewModel.selectedBrand == null) {
                                          AppSnackBar.showError(
                                            context,
                                            'Please select a brand',
                                          );
                                          return;
                                        }
                                        if (viewModel.selectedProductCategory ==
                                            null) {
                                          AppSnackBar.showError(
                                            context,
                                            'Please select a category',
                                          );
                                          return;
                                        }
                                        if (viewModel.selectedSaleSearch ==
                                            null) {
                                          AppSnackBar.showError(
                                            context,
                                            'Please select a product',
                                          );
                                          return;
                                        }
                                        if (quantityController.text.isEmpty) {
                                          AppSnackBar.showError(
                                            context,
                                            LabelService().getLabel(158),
                                          );
                                          return;
                                        }
                                        if (priceController.text.isEmpty) {
                                          AppSnackBar.showError(
                                            context,
                                            LabelService().getLabel(169),
                                          );
                                          return;
                                        }

                                        FocusScope.of(context).unfocus();
                                        setModalState(() {
                                          isSubmitting = true;
                                        });

                                        await viewModel.addSale(
                                          context,
                                          productCategoryId:
                                              viewModel
                                                  .selectedSaleSearch!
                                                  .productID
                                                  .toString(),
                                          storeId: widget.storeId.toString(),
                                          saleCount: quantityController.text,
                                          salePrice: priceController.text,
                                          saleDate: saleDate,
                                          saleType: '1',
                                        );

                                        quantityController.clear();
                                        priceController.clear();
                                        totalController.clear();
                                        clcTotal();

                                        setModalState(() {
                                          isSubmitting = false;
                                        });
                                        if (Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
                                        }
                                        setState(() {});
                                      },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child:
                                      isSubmitting
                                          ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child:
                                                LoadingAnimationWidget.discreteCircle(
                                                  color: AppColors.secondary,

                                                  size: 32,
                                                ),
                                          )
                                          : Text(
                                            LabelService().getLabel(272),
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
                          const SizedBox(height: 40),
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
    );
  }

  Widget _addSaleButton(SaleViewModel viewModel) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: GestureDetector(
            onTap: () => _openAddSaleSheet(viewModel),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  LabelService().getLabel(271),
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

  double totalQuantity = 0;
  double totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(saleModelProvider);

    String formattedDate2 = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDate); // e.g., 2025-06-05

    calculateTotal();
    clcTotal();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Removes focus from any text field
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,

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
                              LabelService().getLabel(179),
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

                  // const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        _dateSelector(viewModel),
                        SizedBox(height: 5),

                        viewModel.loader
                            ? Center(
                              child: LoadingAnimationWidget.discreteCircle(
                                color: Theme.of(context).colorScheme.primary,
                                size: 32,
                              ),
                            )
                            : Column(
                              children: [
                                ...viewModel.saleList
                                    .asMap()
                                    .entries
                                    .map(
                                      (entry) => _saleCard(
                                        viewModel: viewModel,
                                        index: entry.key,
                                        formattedDate2: formattedDate2,
                                      ),
                                    )
                                    .toList(),
                                if (viewModel.saleList.isNotEmpty)
                                  _summaryCard(viewModel),
                                const SizedBox(height: 120),
                              ],
                            ),
                      ],
                    ),
                  ),
                ],
              ),
              _addSaleButton(viewModel),
            ],
          ),
        ),
      ),
    );
  }
}
