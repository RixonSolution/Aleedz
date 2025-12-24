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
import 'package:loading_animation_widget/loading_animation_widget.dart';

class IssuesView extends ConsumerStatefulWidget {
  String storeName, checkInTime;
  int storeId;

  IssuesView({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<IssuesView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<IssuesView> {
  DateTime _selectedDate = DateTime.now();
  double totalQuantity = 0;
  double totalPrice = 0.0;

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
      final price = double.tryParse(item.saleValue?.toString() ?? '0') ?? 0;

      totalQuantity += qty;
      totalPrice += qty * price;
      setState(() {});
    }
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
            title: Text(
              LabelService().getLabel(100),
              style: TextStyle(color: AppColors.whiteColor),
            ),
            content: Text(
              LabelService().getLabel(99),
              style: TextStyle(color: AppColors.whiteColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Close dialog
                child: Text(
                  LabelService().getLabel(94),
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
              TextButton(
                onPressed: onPressed,
                child: Text(
                  LabelService().getLabel(95),
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
            ],
          ),
    );
  }

  List<Map<String, dynamic>> pendingSales = [];

  void addPendingSale() {
    final viewModel = ref.watch(saleModelProvider);

    if (viewModel.selectedSaleSearch != null &&
        quantityController.text.isNotEmpty &&
        priceController.text.isNotEmpty) {
      setState(() {
        pendingSales.add({
          'productCategoryId':
              viewModel.selectedSaleSearch!.productID.toString(),
          'storeId': widget.storeId.toString(),
          'saleCount': quantityController.text,
          'salePrice': priceController.text,
          'saleDate':
              DateFormat('dd MMM yyyy').format(_selectedDate).toString(),
          'saleType': '1',
        });
      });

      // Clear Inputs
      quantityController.clear();
      priceController.clear();
    }
  }

  Future<void> submitAllSales() async {
    final viewModel = ref.watch(saleModelProvider);

    for (var sale in pendingSales) {
      await viewModel.addSale(
        context,
        productCategoryId: sale['productCategoryId'],
        storeId: sale['storeId'],
        saleCount: sale['saleCount'],
        salePrice: sale['salePrice'],
        saleDate: sale['saleDate'],
        saleType: sale['saleType'],
      );
    }

    setState(() {
      pendingSales.clear(); // Clear after submitting
    });
    AppSnackBar.showSuccess(context, 'Sale submitted.');
  }

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredProducts = [];
  int quantity = 1;
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController naeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  double totalAmount = 0.0;

  void calculateTotal() {
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0.0;
    final total = quantity * price;

    totalController.text = total.toStringAsFixed(2);
    setState(() {});
  }

  List<Map<String, dynamic>> invoiceList = [];

  String formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(saleModelProvider);
    String formattedDate = DateFormat('dd MMM yyyy').format(_selectedDate);

    String formattedDate2 = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDate); // e.g., 2025-06-05

    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    calculateTotal();
    clcTotal();

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,

        body:
            viewModel.loader
                ? Center(child: LoadingAnimationWidget.discreteCircle(color: Theme.of(context).colorScheme.primary, size: 32))
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 10),
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
                          const Text(
                            'Sellout',
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
                    const SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(color: AppColors.primary, height: 0),
                    ),
                    const SizedBox(height: 5),

                    Expanded(
                      child: ListView(
                        children: [
                          WeeklyCalendar(
                            selectedDate: _selectedDate,
                            onDateSelected: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                              print(
                                'Selected Date: ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
                              );
                              viewModel.loadsale(
                                context,
                                widget.storeId.toString(),
                                formattedDate2,
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          // brand
                          Container(
                            // margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              // border: Border.all(color: AppColors.blackColor),
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
                                      color:
                                          Colors
                                              .grey
                                              .shade100, // Light grey background
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: DropdownButtonFormField<int>(
                                      value: viewModel.selectedBrand?.brandId,
                                      decoration: InputDecoration(
                                        hintText: LabelService().getLabel(164),
                                        border:
                                            InputBorder
                                                .none, // Removes underline
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
                                        final selected = viewModel.brandList
                                            .firstWhere(
                                              (c) => c.brandId == branddlId,
                                            );
                                        viewModel.selectBrand(
                                          widget.storeId,
                                          selected,
                                        );
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
                                            Colors
                                                .grey
                                                .shade100, // Light grey background
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: DropdownButtonFormField<int>(
                                        value:
                                            viewModel
                                                .selectedProductCategory
                                                ?.productCategoryID,
                                        isExpanded:
                                            true, // Optional: makes it full-width
                                        decoration: InputDecoration(
                                          hintText: LabelService().getLabel(
                                            165,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical: 12,
                                          ),
                                        ),
                                        items:
                                            viewModel.productCategory.map((
                                              category,
                                            ) {
                                              return DropdownMenuItem<int>(
                                                value:
                                                    category.productCategoryID,
                                                child: Text(
                                                  category.productCategoryName ??
                                                      '',
                                                ),
                                              );
                                            }).toList(),
                                        onChanged: (int? categoryId) {
                                          if (categoryId != null) {
                                            final selected = viewModel
                                                .productCategory
                                                .firstWhere(
                                                  (c) =>
                                                      c.productCategoryID ==
                                                      categoryId,
                                                );
                                            viewModel.selectProductCategory(
                                              widget.storeId,
                                              selected,
                                            );
                                          }
                                        },
                                        // This makes sure a hint is shown when no value is selected
                                        hint: Text(
                                          LabelService().getLabel(167),
                                        ),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: DropdownSearch<int>(
                                        items:
                                            viewModel.saleSearch
                                                .map(
                                                  (model) => model.productID!,
                                                )
                                                .toList(),
                                        selectedItem:
                                            viewModel
                                                .selectedSaleSearch
                                                ?.productID,
                                        itemAsString: (int id) {
                                          final model = viewModel.saleSearch
                                              .firstWhere(
                                                (m) => m.productID == id,
                                              );
                                          return model.productModelName ?? '';
                                        },
                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                    hintText: LabelService()
                                                        .getLabel(74),
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 0,
                                                          vertical: 12,
                                                        ),
                                                  ),
                                            ),
                                        popupProps: PopupProps.menu(
                                          showSearchBox: true,
                                          searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                              hintText: LabelService().getLabel(
                                                168,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onChanged: (int? id) {
                                          if (id != null) {
                                            final selected = viewModel
                                                .saleSearch
                                                .firstWhere(
                                                  (m) => m.productID == id,
                                                );
                                            viewModel.selectSearchModel(
                                              selected,
                                            );
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
                                          maxLength: 4,
                                        ),
                                        buildTextField(
                                          LabelService().getLabel(76),
                                          priceController,
                                          onChanged: (_) => calculateTotal(),
                                          maxLength: 7,
                                        ),
                                        buildTextField(
                                          LabelService().getLabel(77),
                                          totalController,
                                          readOnly: true,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),
                          if (viewModel.saleSearch.isNotEmpty &&
                              viewModel.productCategory.isNotEmpty)
                            viewModel.loader
                                ? Center(child: LoadingAnimationWidget.discreteCircle(color: Theme.of(context).colorScheme.primary, size: 32))
                                : InkWell(
                                  onTap: () async {
                                    if (quantityController.text.isEmpty) {
                                      AppSnackBar.showError(
                                        context,
                                        LabelService().getLabel(158),
                                      );
                                    } else if (priceController.text.isEmpty) {
                                      AppSnackBar.showError(
                                        context,
                                        LabelService().getLabel(169),
                                      );
                                    } else {
                                      FocusScope.of(
                                        context,
                                      ).unfocus(); // Removes focus from any text field

                                      // await viewModel.addSale(
                                      //   context,
                                      //   productCategoryId:
                                      //       viewModel
                                      //           .selectedSaleSearch!
                                      //           .productID
                                      //           .toString(),
                                      //   storeId: widget.storeId.toString(),
                                      //   saleCount: quantityController.text,
                                      //   salePrice: priceController.text,
                                      //   saleDate: formattedDate2,
                                      //   saleType: '1',
                                      // );
                                      addPendingSale();
                                      quantityController.clear();
                                      priceController.clear();
                                      totalController.clear();
                                      clcTotal();

                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Center(
                                        child: Text(
                                          LabelService().getLabel(170),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                          SizedBox(height: 10),
                          if (pendingSales.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Header
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              '#',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              'Product ID',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              LabelService().getLabel(162),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              LabelService().getLabel(171),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1),

                                    // List Items
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: pendingSales.length,
                                      separatorBuilder:
                                          (_, __) => const Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final item = pendingSales[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text('${index + 1}'),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  item['productCategoryId']
                                                      .toString(),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  item['saleCount'].toString(),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  item['salePrice'].toString(),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      pendingSales.removeAt(
                                                        index,
                                                      );
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (pendingSales.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: TextField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          // calculateTotal();
                                        },
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintText: LabelService().getLabel(
                                            172,
                                          ),
                                          hintStyle: TextStyle(fontSize: 12),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: TextField(
                                        controller: naeController,
                                        keyboardType: TextInputType.text,
                                        onChanged: (value) {},
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintText: LabelService().getLabel(
                                            173,
                                          ),
                                          hintStyle: TextStyle(fontSize: 12),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 10),
                          if (pendingSales.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: TextField(
                                        controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onChanged: (value) {
                                          // calculateTotal();
                                        },
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintText: LabelService().getLabel(
                                            174,
                                          ),
                                          hintStyle: TextStyle(fontSize: 12),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: TextField(
                                        controller: invoiceController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {},
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintText: LabelService().getLabel(
                                            175,
                                          ),
                                          hintStyle: TextStyle(fontSize: 12),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 10),
                          if (pendingSales.isNotEmpty)
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.lightBlue),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text(
                                    LabelService().getLabel(176),
                                    style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          SizedBox(height: 10),
                          if (pendingSales.isNotEmpty)
                            InkWell(
                              onTap: () async {
                                await submitAllSales();
                                quantityController.clear();
                                priceController.clear();
                                totalController.clear();
                                clcTotal();

                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Center(
                                    child: Text(
                                      LabelService().getLabel(79),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(height: 10),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                            ),
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
                              ? Center(child: LoadingAnimationWidget.discreteCircle(color: Theme.of(context).colorScheme.primary, size: 32))
                              : ListView.builder(
                                itemCount: viewModel.saleList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
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
                                              viewModel.saleList[index].saleId
                                                  .toString(),
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
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: Text(
                                            '${index + 1}.',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                  child: Text(
                                                    '${index + 1}.',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                ),
                                                            child: SizedBox(
                                                              width: 190,
                                                              // color: Colors.red,
                                                              child: Text(
                                                                viewModel
                                                                    .saleList[index]
                                                                    .productModelCode
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .blackColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                ),
                                                            child: SizedBox(
                                                              width: 190,
                                                              // color: Colors.red,
                                                              child: Text(
                                                                viewModel
                                                                        .saleList[index]
                                                                        .productModelName ??
                                                                    '',
                                                                style: TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .greyText,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                ),
                                                            child: SizedBox(
                                                              width: 190,
                                                              // color: Colors.red,
                                                              child: Text(
                                                                'Price: ${viewModel.saleList[index].saleValue}',
                                                                style: TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .blackColor,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 0,
                                                      ),
                                                  child: Text(
                                                    viewModel
                                                        .saleList[index]
                                                        .saleQuantity
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  // color: Colors.red,
                                                  width: 70,
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 00,
                                                      ),
                                                  child: Text(
                                                    '${(viewModel.saleList[index].saleQuantity ?? 0.0) * (viewModel.saleList[index].saleValue ?? 0.0)}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                      ],
                                    ),
                                  );
                                },
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class WeeklyCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const WeeklyCalendar({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _WeeklyCalendarState createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  late DateTime _startOfWeek;
  late int _selectedDayIndex;

  @override
  void initState() {
    super.initState();
    _startOfWeek = _getStartOfWeek(widget.selectedDate);
    _selectedDayIndex = widget.selectedDate.difference(_startOfWeek).inDays;
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1)); // Monday
  }

  void _goToPreviousWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.subtract(const Duration(days: 7));
      _selectedDayIndex = 0;
    });
    widget.onDateSelected(_startOfWeek);
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDays =
        List.generate(
          7,
          (index) => _startOfWeek.add(Duration(days: index)),
        ).where((date) => !date.isAfter(DateTime.now())).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header with Backward Button Only
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(_startOfWeek),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _goToPreviousWeek,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Week of ${DateFormat('dd MMM').format(_startOfWeek)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Week Days Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                weekDays.asMap().entries.map((entry) {
                  int index = entry.key;
                  DateTime date = entry.value;
                  bool isSelected = index == _selectedDayIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDayIndex = index;
                      });
                      widget.onDateSelected(date);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.secondary
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('d').format(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('E').format(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
