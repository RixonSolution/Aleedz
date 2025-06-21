import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/price/price_submit.dart';
import 'package:aleedz/viewmodel/price_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PriceView extends ConsumerStatefulWidget {
  String storeName, checkInTime;
  int storeId, visiteId;
  PriceView({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.visiteId,
  }) : super(key: key);

  @override
  ConsumerState<PriceView> createState() => _DisplayAuditCheckSummaryState();
}

class _DisplayAuditCheckSummaryState extends ConsumerState<PriceView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(priceModelProvider.notifier).loadPriceData(widget.storeId, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(priceModelProvider);

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
                    'Price Promotions',
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
                        child: Text(brand.brandName.toString()),
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

                      final productIndex = brandIndex + 1;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🟢 Header (if needed only once)
                          if (brandIndex == 0)
                            Container(
                              color: AppColors.darkGreyBackground,
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    brand.brandName.toString(),
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
                                          LabelService().getLabel(67),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      SizedBox(
                                        width: 70,
                                        child: Text(
                                          LabelService().getLabel(68),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          // 🔵 Brand Row
                          GestureDetector(
                            onTap: () {
                              NavigationService.navigateTo(
                                PriceSubmit(
                                  storeName: widget.storeName,
                                  checkInTime: widget.checkInTime,
                                  storeId: widget.storeId,
                                  brandId: brand.brandID!,
                                  visiteId: widget.visiteId,
                                  productCategoryId: brand.productCategoryID!,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                color: AppColors.lightGreyBackground,
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
                                                brand.productCategoryName
                                                    .toString(),
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
                                                brand.updatedBy.toString(),
                                                style: TextStyle(
                                                  color:
                                                      brand.updatedBy == '1'
                                                          ? AppColors.primary
                                                          : AppColors
                                                              .blackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        brand.noOfModels.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        brand.nofModelUpdated.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Divider(thickness: 1),
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
