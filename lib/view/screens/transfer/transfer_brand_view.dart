import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/transfer_check_brand.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/transfer/transfer_submit.dart';
import 'package:aleedz/viewmodel/transfer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransferBrandView extends ConsumerStatefulWidget {
  String storeName, checkInTime, transferStore, transferStoreAddress;
  int storeId, visiteId;
  TransferBrandView({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.transferStore,
    required this.transferStoreAddress,
    required this.visiteId,
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
          .transferCheckBrand(widget.storeId, 0, widget.visiteId.toString());
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

    DateTime ddate4 = DateTime.now();

    String formattedDate = DateFormat('dd/MM/yyyy').format(ddate4);
    print(formattedDate); // e.g., "01/06/2025"

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
                      Text(
                        LabelService().getLabel(33),
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
                    widget.transferStoreAddress,
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
                    child: Text(
                      'Transfer: $formattedDate • ${widget.transferStore}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
            viewModel.loader
                ? Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                )
                : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: groupedByBrand.length,
                    itemBuilder: (context, index) {
                      final brandName = groupedByBrand.keys.elementAt(index);
                      final products = groupedByBrand[brandName]!;

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
                                      brandName,
                                      style: const TextStyle(
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
                                SizedBox(
                                  width: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        LabelService().getLabel(58),
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        '${products.length}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...products.asMap().entries.map((entry) {
                            int productIndex = entry.key + 1;
                            final item = entry.value;

                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
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
                                          '$productIndex',
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
                                          TransferSubmit(
                                            storeName: widget.storeName,
                                            checkInTime: widget.checkInTime,
                                            storeId: item.storeID!,
                                            categoryId: item.productCategoryID!,
                                            categoryName:
                                                item.productCategoryName ?? '',
                                            lastUpdate:
                                                item.lastUpdateDate ?? '',
                                            updateBy: item.updatedBy ?? '',
                                            transferStore: widget.transferStore,
                                            transferStoreAddress:
                                                widget.transferStoreAddress,
                                            visiteId: widget.visiteId,
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
                                                    item.productCategoryName ??
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
                                                  Text(
                                                    'Updated by: ${item.updatedBy ?? '-'}',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 70,
                                              child: Text(
                                                item.transferModelCount
                                                        ?.toString() ??
                                                    '0',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
