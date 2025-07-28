import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/stock/stock_details.dart';
import 'package:aleedz/viewmodel/stock_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockSummaryView extends ConsumerStatefulWidget {
  String storeName, checkInTime;
  int storeId, visitId;
  StockSummaryView({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.visitId,
  }) : super(key: key);

  @override
  ConsumerState<StockSummaryView> createState() =>
      _DisplayAuditCheckSummaryState();
}

class _DisplayAuditCheckSummaryState extends ConsumerState<StockSummaryView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(stockModelProvider.notifier).getBrandDropDown();
      ref
          .read(stockModelProvider.notifier)
          .checkSummary(widget.storeId, 0, widget.visitId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(stockModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
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
                'Checked In ${widget.checkInTime}',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonFormField<int>(
                value: viewModel.selectedBrand?.brandId,
                decoration: InputDecoration(
                  hintText: 'All Brands ',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondary),
                  ),
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

            SizedBox(height: 5),
            viewModel.loader
                ? Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.brands.length,
                    itemBuilder: (context, brandIndex) {
                      final brand = viewModel.brands[brandIndex];
                      int index = brandIndex++;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: AppColors.darkGreyBackground,
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      brand.brandName,
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 70,
                                          child: Text(
                                            LabelService().getLabel(86),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ...brand.products.asMap().entries.map((entry) {
                            int productIndex =
                                entry.key + 1; // Start from 1 (optional)
                            var item = entry.value;

                            return GestureDetector(
                              onTap: () {
                                NavigationService.navigateTo(
                                  StockDetails(
                                    storeName: widget.storeName,
                                    checkInTime: widget.checkInTime,
                                    storeId: widget.storeId,
                                    visitId: viewModel.visitId,
                                    lastUpdate: item.lastUpdate,
                                    brandName: brand.brandName,
                                    productName: item.productCategoryName,
                                    productCategoryId: item.productCategoryId,
                                    brandId: brand.brandId,
                                    inputTypeId: 0,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      // color: AppColors.lightGreyBackground,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('$productIndex. '),
                                                    Text(
                                                      item.productCategoryName,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '$productIndex. ',
                                                      style: TextStyle(
                                                        color:
                                                            AppColors
                                                                .lightGreyBackground,
                                                      ),
                                                    ),
                                                    Text(
                                                      item.lastUpdate,
                                                      style: TextStyle(
                                                        color:
                                                            item.lastUpdate ==
                                                                    '1'
                                                                ? AppColors
                                                                    .primary
                                                                : AppColors
                                                                    .blackColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // SizedBox(width: 24),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 70,
                                            child: Text(
                                              item.noOfProducts.toString(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Divider(thickness: 1),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
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
