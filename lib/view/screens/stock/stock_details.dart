import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/stock_view_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/stock_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockDetails extends ConsumerStatefulWidget {
  String storeName, checkInTime, lastUpdate, brandName, productName;
  int storeId, visitId, brandId, productCategoryId, inputTypeId;
  StockDetails({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.visitId,
    required this.lastUpdate,
    required this.brandName,
    required this.productName,
    required this.brandId,
    required this.productCategoryId,
    required this.inputTypeId,
  }) : super(key: key);

  @override
  ConsumerState<StockDetails> createState() => _StockDetailsState();
}

class _StockDetailsState extends ConsumerState<StockDetails> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(stockModelProvider.notifier).getBrandDropDown();
      ref
          .read(stockModelProvider.notifier)
          .stockView(
            widget.storeId,
            widget.brandId,
            widget.visitId,
            widget.productCategoryId,
            widget.inputTypeId,
          );
    });
  }

  List<StockProductModel> stockProducts = [];
  void updateStockList(StockListModel source, int newStock) {
    final index = stockProducts.indexWhere(
      (p) => p.productId == source.productID,
    );

    if (index >= 0) {
      stockProducts[index] = StockProductModel(
        productId: source.productID ?? 0,
        storeId: widget.storeId, // Pass storeId via widget or context
        inputType: source.inputType ?? 0,
        productModelCode: source.productModelCode ?? '',
        productModelName: source.productModelName ?? '',
        productCategoryName: source.productCategoryName ?? '',
        brandName: source.brandName ?? '',
        brandId: source.brandID ?? 0,
        stock: newStock,
      );
    } else {
      stockProducts.add(
        StockProductModel(
          productId: source.productID ?? 0,
          storeId: widget.storeId,
          inputType: source.inputType ?? 0,
          productModelCode: source.productModelCode ?? '',
          productModelName: source.productModelName ?? '',
          productCategoryName: source.productCategoryName ?? '',
          brandName: source.brandName ?? '',
          brandId: source.brandID ?? 0,
          stock: newStock,
        ),
      );
    }
  }

  Future<void> submitStockList() async {
    final viewModel = ref.watch(stockModelProvider);

    for (var item in stockProducts) {
      // Skip empty or zero values
      if (item.stock == 0) continue;

      await viewModel.stockAdd(
        item.storeId,
        item.brandId,
        widget.visitId,
        item.productId,
        item.stock,
      );
    }
    stockProducts = [];

    // Optionally show success message or navigate
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Stock successfully submitted"),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  final TextEditingController searchController = TextEditingController();
  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(stockModelProvider);
    final filteredList =
        viewModel.stockViewList.where((item) {
          final code = item.productModelCode?.toLowerCase() ?? '';
          final name = item.productModelName?.toLowerCase() ?? '';
          return code.contains(searchTerm) || name.contains(searchTerm);
        }).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        bottomNavigationBar:
            viewModel.stockViewList.isNotEmpty &&
                    viewModel.stockViewList.first.inputType == 0
                ? const SizedBox(height: 0.0, width: 0.0)
                : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                    onTap: () {
                      submitStockList();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                      ),
                      width: double.infinity,
                      height: 50,
                      child: const Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                    'Stock',
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
                '${LabelService().getLabel(14)} ${widget.checkInTime}',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: LabelService().getLabel(181),
                prefixIcon: Icon(Icons.search),
                border: UnderlineInputBorder(), // Only bottom line
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value.toLowerCase().trim();
                });
              },
            ),
            SizedBox(height: 20),

            /// Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.brandName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "last update ${widget.lastUpdate}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// Sub-header
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.productName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    LabelService().getLabel(87),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// Product List
            viewModel.loader
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: filteredList.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      // Get if this item is already in the stockProducts list
                      final currentItemIndex = stockProducts.indexWhere(
                        (e) => e.productId == item.productID,
                      );

                      // Get stock if item was already added, otherwise 0
                      final currentStock =
                          currentItemIndex != -1
                              ? stockProducts[currentItemIndex].stock
                              : 0;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          item.productModelCode ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(item.productModelName ?? ''),
                        trailing:
                            item.inputType == 1
                                ? GestureDetector(
                                  onTap: () {
                                    final newStock = currentStock == 1 ? 0 : 1;
                                    updateStockList(item, newStock);
                                    setState(() {});
                                  },
                                  child: Icon(
                                    currentStock == 1
                                        ? Icons
                                            .check_circle // filled when selected
                                        : Icons
                                            .check_circle_outline, // empty when not selected
                                    color:
                                        currentStock == 1
                                            ? Colors.black
                                            : Colors.grey, // change as needed
                                    size: 28,
                                  ),
                                )
                                : item.inputType == 0
                                ? Container(
                                  margin: EdgeInsets.only(right: 8, left: 8),
                                  // width: 60,
                                  height: 36,
                                  child: Text(
                                    item.stock.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                : SizedBox(
                                  width: 60,
                                  height: 36,
                                  child: TextFormField(
                                    maxLength: 5,
                                    initialValue:
                                        currentStock == 0
                                            ? ''
                                            : currentStock.toString(),

                                    decoration: InputDecoration(
                                      counterText:
                                          '', // Hides the character count

                                      hintText: LabelService().getLabel(162),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      final qty = int.tryParse(value) ?? 0;
                                      updateStockList(item, qty);
                                    },
                                  ),
                                ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class StockProductModel {
  final int productId;
  final int storeId;
  final int inputType;
  final String productModelCode;
  final String productModelName;
  final String productCategoryName;
  final String brandName;
  final int brandId;
  final int stock;

  StockProductModel({
    required this.productId,
    required this.storeId,
    required this.inputType,
    required this.productModelCode,
    required this.productModelName,
    required this.productCategoryName,
    required this.brandName,
    required this.brandId,
    required this.stock,
  });

  factory StockProductModel.fromJson(Map<String, dynamic> json) {
    return StockProductModel(
      productId: json['ProductID'],
      storeId: json['StoreID'] ?? 0, // Default if not provided
      inputType: json['InputType'],
      productModelCode: json['ProductModelCode'] ?? '',
      productModelName: json['ProductModelName'] ?? '',
      productCategoryName: json['ProductCategoryName'] ?? '',
      brandName: json['BrandName'] ?? '',
      brandId: json['BrandID'] ?? 0,
      stock: json['Stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductID': productId,
      'StoreID': storeId,
      'InputType': inputType,
      'ProductModelCode': productModelCode,
      'ProductModelName': productModelName,
      'ProductCategoryName': productCategoryName,
      'BrandName': brandName,
      'BrandID': brandId,
      'Stock': stock,
    };
  }
}
