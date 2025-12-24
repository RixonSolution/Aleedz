import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/stock_view_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/stock_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  bool _submitting = false;
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final notifier = ref.read(stockModelProvider.notifier);
      await notifier.getBrandDropDown();
      try {
        await notifier.stockView(
          widget.storeId,
          widget.brandId,
          widget.visitId,
          widget.productCategoryId,
          widget.inputTypeId,
        );
      } finally {
        if (mounted) {
          setState(() => _initialLoading = false);
        }
      }
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
        storeId: widget.storeId,
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
    final viewModel = ref.read(stockModelProvider);
    final notifier = ref.read(stockModelProvider.notifier);
    if (_submitting) return;
    setState(() => _submitting = true);

    try {
      for (var item in stockProducts) {
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                colors: [Color(0xFF111827), Color(0xFF0B1120)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Text(
              "Stock successfully submitted",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );

      await notifier.checkSummary(
        widget.storeId,
        widget.brandId,
        widget.visitId,
      );
      if (!mounted) return;
      NavigationService.goBack();
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  final TextEditingController searchController = TextEditingController();
  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(stockModelProvider);
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final bool showSubmitButton =
        viewModel.stockViewList.isNotEmpty &&
        viewModel.stockViewList.first.inputType != 0 &&
        !isKeyboardOpen;
    final filteredList =
        viewModel.stockViewList.where((item) {
          final code = item.productModelCode?.toLowerCase() ?? '';
          final name = item.productModelName?.toLowerCase() ?? '';
          return code.contains(searchTerm) || name.contains(searchTerm);
        }).toList();

    return SafeArea(
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
                            LabelService().getLabel(180),
                            style: const TextStyle(
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
                        widget.brandName,
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 14,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: LabelService().getLabel(181),
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchTerm = value.toLowerCase().trim();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 14,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.productName,
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Last update: ${widget.lastUpdate}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              LabelService().getLabel(87),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child:
                      _initialLoading
                          ? Center(
                            child: LoadingAnimationWidget.discreteCircle(
                              color: Theme.of(context).colorScheme.primary,
                              size: 32,
                            ),
                          )
                          : ListView.separated(
                            padding: EdgeInsets.fromLTRB(
                              16,
                              0,
                              16,
                              showSubmitButton ? 100 : 24,
                            ),
                            itemCount: filteredList.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              final currentItemIndex = stockProducts.indexWhere(
                                (e) => e.productId == item.productID,
                              );
                              final currentStock =
                                  currentItemIndex != -1
                                      ? stockProducts[currentItemIndex].stock
                                      : 0;

                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF111827),
                                              Color(0xFF0B1120),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        40,
                                        12,
                                        12,
                                        12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.productModelCode ?? '',
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  item.productModelName ?? '',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          item.inputType == 1
                                              ? Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    final newStock =
                                                        currentStock == 1
                                                            ? 0
                                                            : 1;
                                                    updateStockList(
                                                      item,
                                                      newStock,
                                                    );
                                                    setState(() {});
                                                  },
                                                  child: Icon(
                                                    currentStock == 1
                                                        ? Icons.check_circle
                                                        : Icons
                                                            .check_circle_outline,
                                                    color:
                                                        currentStock == 1
                                                            ? AppColors.primary
                                                            : Colors.grey,
                                                    size: 28,
                                                  ),
                                                ),
                                              )
                                              : item.inputType == 0
                                              ? Container(
                                                constraints:
                                                    const BoxConstraints(
                                                      minWidth: 60,
                                                    ),
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors
                                                          .lightGreyBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  item.stock.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                              : SizedBox(
                                                width: 78,
                                                child: TextFormField(
                                                  maxLength: 5,
                                                  textAlign: TextAlign.center,
                                                  initialValue:
                                                      currentStock == 0
                                                          ? ''
                                                          : currentStock
                                                              .toString(),
                                                  decoration: InputDecoration(
                                                    counterText: '',
                                                    hintText: LabelService()
                                                        .getLabel(162),
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 10,
                                                        ),
                                                    filled: true,
                                                    fillColor:
                                                        AppColors
                                                            .lightGreyBackground,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (value) {
                                                    final qty =
                                                        int.tryParse(value) ??
                                                        0;
                                                    updateStockList(item, qty);
                                                  },
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
            if (showSubmitButton)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                    elevation: 6,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _submitting ? null : submitStockList,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child:
                        _submitting
                            ? SizedBox(
                              key: ValueKey('loader'),
                              height: 20,
                              width: 20,
                              child: LoadingAnimationWidget.discreteCircle(
                                size: 32,

                                color: AppColors.secondary,
                              ),
                            )
                            : const Text(
                              'Submit',
                              key: ValueKey('text'),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
      storeId: json['StoreID'] ?? 0,
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
