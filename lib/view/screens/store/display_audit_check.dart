import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/models/audit_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayAuditCheck extends ConsumerStatefulWidget {
  String storeName, checkInTime, categoryName;
  int storeId, categoryId;
  DisplayAuditCheck({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  ConsumerState<DisplayAuditCheck> createState() => _DisplayAuditCheckState();
}

class _DisplayAuditCheckState extends ConsumerState<DisplayAuditCheck> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(storeModelProvider.notifier)
          .checkAudit(widget.storeId, widget.categoryId);
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

            SizedBox(height: 5),
            viewModel.loader
                ? Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                )
                : Expanded(
                  child: Builder(
                    builder: (context) {
                      // Group audit items by brand name
                      final groupedAudit = <String, List<AuditItem>>{};
                      for (var item in viewModel.auditList) {
                        groupedAudit
                            .putIfAbsent(item.brandName, () => [])
                            .add(item);
                      }

                      final brandNames = groupedAudit.keys.toList();

                      return ListView.builder(
                        itemCount: brandNames.length,
                        itemBuilder: (context, brandIndex) {
                          final brandName = brandNames[brandIndex];
                          final brandItems = groupedAudit[brandName]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Brand Header Row
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          brandName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'last update 10-April 2025',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      color: AppColors.lightGreyBackground,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            widget.categoryName,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: const [
                                              SizedBox(
                                                width: 60,
                                                child: Text(
                                                  "Available",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              SizedBox(
                                                width: 60,
                                                child: Text(
                                                  "Less than 2?",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
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
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),

                              // Product Rows
                              ...brandItems.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Product Name & Code
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.productModelCode,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: AppColors.blackColor,
                                                  ),
                                                ),
                                                Text(
                                                  item.productModelName,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.blackColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Availability Check
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 5,
                                            ),
                                            child: SizedBox(
                                              width: 60,
                                              child: Icon(
                                                item.displayCheck == 0
                                                    ? Icons.check_circle_outline
                                                    : Icons.check_circle,

                                                color:
                                                    item.displayCheck == 0
                                                        ? Colors.grey.shade400
                                                        : Colors.black,
                                              ),
                                            ),
                                          ),

                                          // Less than 2 Check
                                          SizedBox(
                                            width: 60,
                                            child: Icon(
                                              item.displayCheckCount == 0
                                                  ? Icons.check_circle_outline
                                                  : Icons.check_circle,

                                              color:
                                                  item.displayCheckCount == 0
                                                      ? Colors.grey.shade400
                                                      : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        },
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
