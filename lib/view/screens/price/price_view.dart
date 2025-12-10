import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/price_model.dart';
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
      ref
          .read(priceModelProvider.notifier)
          .loadPriceData(widget.storeId, 0, widget.visiteId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(priceModelProvider);
    final labelService = LabelService();

    final Map<String, List<PriceModel>> groupedBrands = {};
    for (final item in viewModel.brands) {
      final key = item.brandName ?? 'Unknown Brand';
      groupedBrands.putIfAbsent(key, () => []).add(item);
    }
    final brandEntries = groupedBrands.entries.toList();

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
                        'Price Promotions',
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
                          Icons.access_time_filled,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${labelService.getLabel(14)} ${widget.checkInTime}',
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
                      viewModel.selectBrand(
                        widget.storeId,
                        selected,
                        widget.visiteId.toString(),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  viewModel.loader
                      ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.secondary,
                        ),
                      )
                      : brandEntries.isEmpty
                      ? Center(
                        child: Text(
                          'No brand data available',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: brandEntries.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, brandIndex) {
                          final brandEntry = brandEntries[brandIndex];
                          final products = brandEntry.value;
                          final totalModelCount = products.fold<int>(
                            0,
                            (sum, item) => sum + (item.noOfModels ?? 0),
                          );
                          final totalUpdatedCount = products.fold<int>(
                            0,
                            (sum, item) =>
                                sum +
                                (int.tryParse(item.nofModelUpdated ?? '0') ??
                                    0),
                          );

                          return Container(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            brandEntry.key,
                                            style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Visit time: ${widget.checkInTime}',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              labelService.getLabel(67),
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              '$totalModelCount',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              labelService.getLabel(68),
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              '$totalUpdatedCount',
                                              style: const TextStyle(
                                                color: Colors.orange,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 1,
                                ),
                                const SizedBox(height: 8),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: products.length,
                                  separatorBuilder:
                                      (context, index) =>
                                          Divider(color: Colors.grey.shade300),
                                  itemBuilder: (context, listIndex) {
                                    final item = products[listIndex];
                                    final isUpdated =
                                        item.updatedBy?.toString() == '1';

                                    return GestureDetector(
                                      onTap: () {
                                        NavigationService.navigateTo(
                                          PriceSubmit(
                                            storeName: widget.storeName,
                                            checkInTime: widget.checkInTime,
                                            storeId: widget.storeId,
                                            brandId: item.brandID ?? 0,
                                            visiteId: widget.visiteId,
                                            productCategoryId:
                                                item.productCategoryID ?? 0,
                                            productName:
                                                item.productCategoryName
                                                    .toString(),
                                            brandName:
                                                item.brandName.toString(),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: Text(
                                                '${listIndex + 1}.',
                                                style: const TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.productCategoryName
                                                            ?.toString() ??
                                                        '',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          isUpdated
                                                              ? AppColors
                                                                  .primary
                                                                  .withOpacity(
                                                                    0.12,
                                                                  )
                                                              : Colors
                                                                  .grey
                                                                  .shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      isUpdated
                                                          ? 'Updated'
                                                          : 'Pending',
                                                      style: TextStyle(
                                                        color:
                                                            isUpdated
                                                                ? AppColors
                                                                    .primary
                                                                : Colors
                                                                    .grey
                                                                    .shade600,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      labelService.getLabel(67),
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade600,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      item.noOfModels
                                                              ?.toString() ??
                                                          '0',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 12),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      labelService.getLabel(68),
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade600,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      item.nofModelUpdated ??
                                                          '0',
                                                      style: const TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
    );
  }
}
