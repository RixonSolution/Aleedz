import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/store/display_audit_check.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayAuditCheckSummary extends ConsumerStatefulWidget {
  String storeName, checkInTime;
  int storeId;
  DisplayAuditCheckSummary({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<DisplayAuditCheckSummary> createState() =>
      _DisplayAuditCheckSummaryState();
}

class _DisplayAuditCheckSummaryState
    extends ConsumerState<DisplayAuditCheckSummary> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(coverageModelProvider.notifier).getBrandDropDown();
      ref.read(coverageModelProvider.notifier).checkSummary(widget.storeId, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(coverageModelProvider);

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
                    'Display Audit',
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
                  viewModel.selectBrand(widget.storeId, selected, context);
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
                                          width: 60,
                                          child: Text(
                                            LabelService().getLabel(41),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            LabelService().getLabel(42),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
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
                                  DisplayAuditCheck(
                                    storeName: widget.storeName,
                                    checkInTime: widget.checkInTime,
                                    storeId: widget.storeId,
                                    categoryId: item.productCategoryId,
                                    categoryName: item.productCategoryName,
                                    lastUpdate: item.lastUpdate,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
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
                                                Text(
                                                  '$productIndex. ',
                                                ), // ✅ This is your index
                                                Text(item.productCategoryName),
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
                                                Text(item.lastUpdate),
                                              ],
                                            ),
                                            // SizedBox(width: 24),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 65,
                                        child: Text(
                                          item.modelCount.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 65,
                                        child: Text(
                                          item.displayCheckCount.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),

                          const Divider(thickness: 1),
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
