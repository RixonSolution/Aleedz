import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/transfer_check_brand.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/store/display_audit_check.dart';
import 'package:aleedz/view/screens/transfer/transfer_submit.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:aleedz/viewmodel/transfer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferBrandView extends ConsumerStatefulWidget {
  String storeName, checkInTime;
  int storeId;
  TransferBrandView({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<TransferBrandView> createState() =>
      _DisplayAuditCheckSummaryState();
}

class _DisplayAuditCheckSummaryState extends ConsumerState<TransferBrandView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(transferModelProvider.notifier).getBrandDropDown();
      ref
          .read(transferModelProvider.notifier)
          .transferCheckBrand(widget.storeId, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(transferModelProvider);

    final groupedByBrand = <String, List<TransferCheckBrand>>{};

    for (var item in viewModel.transferCheck) {
      final brand = item.brandName ?? 'Unknown Brand';
      if (!groupedByBrand.containsKey(brand)) {
        groupedByBrand[brand] = [];
      }
      groupedByBrand[brand]!.add(item);
    }

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
                    LabelService().getLabel(33),
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
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: AppColors.secondary),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Transfer: 22/05/2025',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          'XCITE - Avanues Mall, Kuwait',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
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
                    itemCount: groupedByBrand.length,
                    itemBuilder: (context, index) {
                      final brandName = groupedByBrand.keys.elementAt(index);
                      final products = groupedByBrand[brandName]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: AppColors.darkGreyBackground,
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  brandName,
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Models\nTransfered',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...products.asMap().entries.map((entry) {
                            int productIndex = entry.key + 1;
                            final item = entry.value;

                            return GestureDetector(
                              onTap: () {
                                NavigationService.navigateTo(
                                  TransferSubmit(
                                    storeName: widget.storeName,
                                    checkInTime: widget.checkInTime,
                                    storeId: item.storeID!,
                                    categoryId: item.productCategoryID!,
                                    categoryName:
                                        item.productCategoryName ?? '',
                                    lastUpdate: item.lastUpdateDate ?? '',
                                    updateBy: item.updatedBy ?? '',
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
                                        child: Row(
                                          children: [
                                            Text('$productIndex. '),
                                            Text(
                                              item.productCategoryName ?? '',
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        child: Text(
                                          item.transferModelCount?.toString() ??
                                              '0',
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
