import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/sale_viewmodel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SaleView extends ConsumerStatefulWidget {
  String storeName, checkInTime;
  int storeId;
  SaleView({
    Key? key,
    required this.storeName,
    required this.checkInTime,
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
    setState(() {});
    for (var item in ref.read(saleModelProvider.notifier).saleList) {
      final qty = int.tryParse(item.saleQuantity?.toString() ?? '0') ?? 0;
      final price = int.tryParse(item.saleValue?.toString() ?? '0') ?? 0;

      totalQuantity += qty;
      totalPrice += qty * price;
    }
    setState(() {});
  }

  FocusNode remarksFocus = FocusNode();

  bool deleteLoader = false;
  DateTime _selectedDate = DateTime.now(); // default is today

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  void calculateTotal() {
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0.0;
    final total = quantity * price;

    totalController.text = total.toStringAsFixed(0);
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _showLogoutDialog(
    BuildContext context,

    void Function()? onPressed,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.secondary,
            title: const Text(
              'Delete',
              style: TextStyle(color: AppColors.whiteColor),
            ),
            content: const Text(
              'Are you sure you want to delete?',
              style: TextStyle(color: AppColors.whiteColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Close dialog
                child: const Text(
                  'No',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
              TextButton(
                onPressed: onPressed,
                child: const Text(
                  'Yes',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
            ],
          ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    void Function(String)? onChanged,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: label,
            filled: true,
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

  int totalQuantity = 0;
  int totalPrice = 0;

  final List<String> modelNames = [
    "Model A",
    "Model B",
    "Model C",
    "Model D",
    "Model E",
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(saleModelProvider);
    String formattedDate = DateFormat('dd MMM yyyy').format(_selectedDate);
    String formattedDate2 = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDate); // e.g., 2025-06-05

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Removes focus from any text field
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0), // Optional padding
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: AppColors.secondary),
              width: double.infinity,
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      LabelService().getLabel(77),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      totalQuantity.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      totalPrice.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        NavigationService.goBack();
                      },
                      child: Image.asset(
                        AppIcons.backArrow,
                        height: 30,
                        width: 30,
                      ),
                    ),
                    Text(
                      'Daily Sales',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      AppIcons.locationIcon,
                      height: 30,
                      width: 30,
                      color: AppColors.whiteColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(color: AppColors.primary, height: 0),
              ),

              SizedBox(height: 5),
              Center(
                child: Text(
                  widget.storeName,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Checked In ${widget.checkInTime}',
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _pickDate,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.keyboard_arrow_left, size: 40),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right, size: 40),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.blackColor),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100, // Light grey background
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<int>(
                          value: viewModel.selectedBrand?.brandId,
                          decoration: const InputDecoration(
                            hintText: 'Brand',
                            border: InputBorder.none, // Removes underline
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                          ),
                          items:
                              viewModel.brandList.map((brand) {
                                return DropdownMenuItem<int>(
                                  value: brand.brandId,
                                  child: Text(brand.brandName),
                                );
                              }).toList(),
                          onChanged: (int? branddlId) {
                            final selected = viewModel.brandList.firstWhere(
                              (c) => c.brandId == branddlId,
                            );
                            viewModel.selectBrand(widget.storeId, selected);
                          },
                        ),
                      ),
                    ),
                    if (viewModel.productCategory.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Colors.grey.shade100, // Light grey background
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButtonFormField<int>(
                            value:
                                viewModel
                                    .selectedProductCategory
                                    ?.productCategoryID,
                            isExpanded: true, // Optional: makes it full-width
                            decoration: const InputDecoration(
                              hintText: 'Product Category',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 12,
                              ),
                            ),
                            items:
                                viewModel.productCategory.map((category) {
                                  return DropdownMenuItem<int>(
                                    value: category.productCategoryID,
                                    child: Text(
                                      category.productCategoryName ?? '',
                                    ),
                                  );
                                }).toList(),
                            onChanged: (int? categoryId) {
                              if (categoryId != null) {
                                final selected = viewModel.productCategory
                                    .firstWhere(
                                      (c) => c.productCategoryID == categoryId,
                                    );
                                viewModel.selectProductCategory(
                                  widget.storeId,
                                  selected,
                                );
                              }
                            },
                            // This makes sure a hint is shown when no value is selected
                            hint: const Text('Select Product Category'),
                          ),
                        ),
                      ),
                    if (viewModel.saleSearch.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownSearch<int>(
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
                              dropdownSearchDecoration: InputDecoration(
                                hintText: LabelService().getLabel(74),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  hintText: "Search model name...",
                                ),
                              ),
                            ),
                            onChanged: (int? id) {
                              if (id != null) {
                                final selected = viewModel.saleSearch
                                    .firstWhere((m) => m.productID == id);
                                viewModel.selectSearchModel(selected);
                              }
                            },
                          ),
                        ),
                      ),

                    if (viewModel.saleSearch.isNotEmpty &&
                        viewModel.productCategory.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Row(
                          children: [
                            buildTextField(
                              LabelService().getLabel(75),
                              quantityController,
                              onChanged: (_) => calculateTotal(),
                            ),
                            buildTextField(
                              LabelService().getLabel(76),
                              priceController,
                              onChanged: (_) => calculateTotal(),
                            ),
                            buildTextField(
                              LabelService().getLabel(77),
                              totalController,
                              readOnly: true,
                            ),
                          ],
                        ),
                      ),
                    if (viewModel.saleSearch.isNotEmpty &&
                        viewModel.productCategory.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child:
                              viewModel.loader
                                  ? Center(child: CircularProgressIndicator())
                                  : ElevatedButton(
                                    onPressed: () async {
                                      if (quantityController.text.isEmpty) {
                                        AppSnackBar.showError(
                                          context,
                                          'Please add quantity',
                                        );
                                      } else if (priceController.text.isEmpty) {
                                        AppSnackBar.showError(
                                          context,
                                          'Please add price',
                                        );
                                      } else {
                                        FocusScope.of(
                                          context,
                                        ).unfocus(); // Removes focus from any text field

                                        await viewModel.addSale(
                                          context,
                                          productCategoryId:
                                              viewModel
                                                  .selectedProductCategory!
                                                  .productCategoryID
                                                  .toString(),
                                          storeId: widget.storeId.toString(),
                                          saleCount: quantityController.text,
                                          salePrice: priceController.text,
                                          saleDate: formattedDate2,
                                          saleType: '1',
                                        );
                                        quantityController.clear();
                                        priceController.clear();
                                        totalController.clear();
                                        clcTotal();

                                        setState(() {});
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius
                                                .zero, // Removes rounded corners
                                      ),
                                      backgroundColor: AppColors.secondary,
                                    ),
                                    child: Text(
                                      LabelService().getLabel(79),
                                      style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                      top: 5,
                      bottom: 10,
                    ),
                    child: Text(
                      LabelService().getLabel(56),
                      style: TextStyle(color: AppColors.greyText, fontSize: 12),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(color: AppColors.secondary),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            '#',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Sales Description',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Text(
                            LabelService().getLabel(75),

                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            LabelService().getLabel(77),
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              viewModel.loader
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.saleList.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () {
                            _showLogoutDialog(context, () async {
                              NavigationService.goBack();
                              viewModel.loader = true;
                              viewModel.notifyListeners();

                              await viewModel.deleteSale(
                                context,
                                storeId: widget.storeId.toString(),
                                saleId:
                                    viewModel.saleList[index].saleId.toString(),
                              );
                              await viewModel.saleView(
                                context,
                                storeId: widget.storeId.toString(),
                                saleDate: formattedDate2,
                              );
                              clcTotal();

                              viewModel.loader = false;
                              viewModel.notifyListeners();
                            });
                          },
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      '${index + 1}.',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              child: SizedBox(
                                                width: 190,
                                                // color: Colors.red,
                                                child: Text(
                                                  viewModel
                                                      .saleList[index]
                                                      .saleId
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              child: SizedBox(
                                                width: 190,
                                                // color: Colors.red,
                                                child: Text(
                                                  viewModel
                                                          .saleList[index]
                                                          .productCategoryName ??
                                                      '',
                                                  style: TextStyle(
                                                    color: AppColors.greyText,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              child: SizedBox(
                                                width: 190,
                                                // color: Colors.red,
                                                child: Text(
                                                  'Price: ${viewModel.saleList[index].saleValue}',
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // color: Colors.red,
                                    width: 40,
                                    padding: const EdgeInsets.only(right: 0),
                                    child: Text(
                                      viewModel.saleList[index].saleQuantity
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    // color: Colors.red,
                                    width: 70,
                                    padding: const EdgeInsets.only(right: 00),
                                    child: Text(
                                      '${(int.tryParse(viewModel.saleList[index].saleQuantity?.toString() ?? '0') ?? 0) * (int.tryParse(viewModel.saleList[index].saleValue?.toString() ?? '0') ?? 0)}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Divider(
                                color: Colors.grey[300],
                                thickness: 1,
                                indent: 12,
                                endIndent: 12,
                              ),
                            ],
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
  }
}
