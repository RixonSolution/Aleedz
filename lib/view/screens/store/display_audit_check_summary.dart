import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/store/display_audit_check.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayAuditCheckSummary extends ConsumerStatefulWidget {
  String storeName, checkInTime, address;
  int storeId, visitId;
  DisplayAuditCheckSummary({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.address,
    required this.storeId,
    required this.visitId,
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
      ref.read(storeModelProvider.notifier).getBrandDropDown();
      ref
          .read(storeModelProvider.notifier)
          .checkSummary(widget.storeId, 0, widget.visitId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                      const Text(
                        'Display Audit',
                        style: TextStyle(
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
                      color: Color(0x19000000), // slightly stronger
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<int>(
                    value: viewModel.selectedBrand?.brandId,
                    isDense: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'All Brands',
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
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
                    onChanged: (int? branddlId) {
                      final selected = viewModel.brandList.firstWhere(
                        (c) => c.brandId == branddlId,
                      );
                      viewModel.selectBrand(widget.storeId, selected);
                    },
                  ),
                ),
              ),
            ),

            SizedBox(height: 5),
            SizedBox(height: 12),
            viewModel.loader
                ? Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                )
                : Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: viewModel.brands.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, brandIndex) {
                      final brand = viewModel.brands[brandIndex];
                      final totalModelCount = brand.products.fold<int>(
                        0,
                        (sum, item) => sum + (item.modelCount),
                      );
                      final totalDisplayCount = brand.products.fold<int>(
                        0,
                        (sum, item) => sum + (item.displayCheckCount),
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
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
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      brand.brandName,
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Last update: ${widget.checkInTime}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Model',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          '$totalModelCount',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Display',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          '$totalDisplayCount',
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: brand.products.length,
                            itemBuilder: (context, listIndex) {
                              final item = brand.products[listIndex];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
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
                                            '${listIndex + 1}',
                                            style: const TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationService.navigateTo(
                                            DisplayAuditCheck(
                                              storeName: widget.storeName,
                                              checkInTime: widget.checkInTime,
                                              address: widget.address,
                                              storeId: widget.storeId,
                                              categoryId:
                                                  item.productCategoryId,
                                              categoryName:
                                                  item.productCategoryName,
                                              lastUpdate: item.lastUpdate,
                                              updateBy: item.updateBy,
                                              brandId: brand.brandId.toString(),
                                              visitId: widget.visitId,
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            40,
                                            12,
                                            12,
                                            12,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.productCategoryName,
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.blackColor,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Updated by: ${item.updateBy}',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: 50,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          item.modelCount
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  SizedBox(
                                                    width: 60,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          item.displayCheckCount
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Colors.orange,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
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
                              );
                            },
                          ),
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
