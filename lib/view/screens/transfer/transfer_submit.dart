import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/audit_model.dart';
import 'package:aleedz/models/product_selection_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/transfer_viewmodel.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TransferSubmit extends ConsumerStatefulWidget {
  String storeName,
      checkInTime,
      categoryName,
      lastUpdate,
      updateBy,
      transferStore,
      transferStoreAddress;
  int storeId, categoryId, visiteId;
  TransferSubmit({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.categoryId,
    required this.categoryName,
    required this.lastUpdate,
    required this.updateBy,
    required this.transferStore,
    required this.transferStoreAddress,
    required this.visiteId,
  }) : super(key: key);

  @override
  ConsumerState<TransferSubmit> createState() => _DisplayAuditCheckState();
}

class _DisplayAuditCheckState extends ConsumerState<TransferSubmit> {
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(transferModelProvider.notifier)
          .transferSubmitList(widget.storeId, widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(transferModelProvider);
    DateTime ddate4 = DateTime.now();

    String formattedDate = DateFormat('dd/MM/yyyy').format(ddate4);
    print(formattedDate); // e.g., "01/06/2025"
    final header = Container(
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
                'Product Transfer',
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check, color: AppColors.primary, size: 16),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        bottomNavigationBar:
            viewModel.loader
                ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: AppColors.secondary,
                    size: 32,
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        await viewModel.transferSubmit(
                          transferModel: viewModel.selectedProducts1,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Removes rounded corners
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            const SizedBox(height: 12),
            viewModel.loader
                ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: AppColors.secondary,
                    size: 32,
                  ),
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
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
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
                                        Text(
                                          brandName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.lastUpdate,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                widget.updateBy == '1'
                                                    ? AppColors.primary
                                                    : AppColors.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.categoryName,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 60,
                                              child: Text(
                                                "Available",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                LabelService().getLabel(60),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey.shade700,
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
                              const SizedBox(height: 10),
                              ...brandItems.asMap().entries.map((entry) {
                                int index = entry.key + 1; // Start from 1
                                var item = entry.value;

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
                                              '$index',
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
                                                      item.productModelCode,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color:
                                                            AppColors
                                                                .blackColor,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      item.productModelName,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            AppColors
                                                                .blackColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      final existing = viewModel
                                                          .selectedProducts
                                                          .firstWhereOrNull(
                                                            (e) =>
                                                                e.productId ==
                                                                item.productId,
                                                          );

                                                      // Toggle value based on previous state
                                                      int newIsTransfer;
                                                      int newCount;

                                                      if (existing != null) {
                                                        existing.displayCheck =
                                                            existing.displayCheck ==
                                                                    1
                                                                ? 0
                                                                : 1;

                                                        if (existing
                                                                .displayCheck ==
                                                            0) {
                                                          existing
                                                              .displayCheckCount = 0;
                                                        }

                                                        newIsTransfer =
                                                            existing
                                                                .displayCheck;
                                                        newCount =
                                                            existing
                                                                .displayCheckCount;
                                                      } else {
                                                        final newProduct =
                                                            ProductSelection(
                                                              productId:
                                                                  item.productId,
                                                              displayCheck: 1,
                                                              displayCheckCount:
                                                                  0,
                                                              token:
                                                                  viewModel
                                                                      .user!
                                                                      .apiToken
                                                                      .toString(),
                                                              storeId:
                                                                  widget.storeId
                                                                      .toString(),
                                                              teamMemberId:
                                                                  viewModel
                                                                      .user!
                                                                      .teamMemberID
                                                                      .toString(),
                                                            );

                                                        viewModel
                                                            .selectedProducts
                                                            .add(newProduct);
                                                        newIsTransfer = 1;
                                                        newCount = 0;
                                                      }

                                                      // Now call update after local state is changed
                                                      viewModel
                                                          .addOrUpdateProductSelection(
                                                            productId:
                                                                item.productId,
                                                            isTransfer:
                                                                newIsTransfer,
                                                            transferCount:
                                                                newCount,
                                                            token:
                                                                viewModel
                                                                    .user!
                                                                    .apiToken
                                                                    .toString(),
                                                            storeId:
                                                                widget.storeId,
                                                            teamMemberId:
                                                                viewModel
                                                                    .user!
                                                                    .teamMemberID
                                                                    .toString(),
                                                            transferId:
                                                                item.productId
                                                                    .toString(),
                                                            visitId:
                                                                widget.visiteId,
                                                          );

                                                      viewModel
                                                          .notifyListeners();
                                                    },
                                                    child: SizedBox(
                                                      width: 60,
                                                      child: Icon(
                                                        viewModel.selectedProducts.any(
                                                              (e) =>
                                                                  e.productId ==
                                                                      item.productId &&
                                                                  e.displayCheck ==
                                                                      1,
                                                            )
                                                            ? Icons.check_circle
                                                            : Icons
                                                                .check_circle_outline,
                                                        size: 30,
                                                        color:
                                                            viewModel.selectedProducts.any(
                                                                  (e) =>
                                                                      e.productId ==
                                                                          item.productId &&
                                                                      e.displayCheck ==
                                                                          1,
                                                                )
                                                                ? AppColors
                                                                    .primary
                                                                : Colors
                                                                    .grey
                                                                    .shade400,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      final existing = viewModel
                                                          .selectedProducts
                                                          .firstWhereOrNull(
                                                            (e) =>
                                                                e.productId ==
                                                                item.productId,
                                                          );

                                                      // ✅ Check if product is marked as available
                                                      final isAvailable =
                                                          existing
                                                              ?.displayCheck ==
                                                          1;

                                                      if (!isAvailable) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              LabelService()
                                                                  .getLabel(
                                                                    189,
                                                                  ),
                                                            ),
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        );
                                                        return;
                                                      }
                                                    },
                                                    child: SizedBox(
                                                      width: 60,
                                                      child: Builder(
                                                        builder: (context) {
                                                          final key =
                                                              item.productId
                                                                  .toString();

                                                          if (!viewModel
                                                                  .quantityControllers
                                                                  .containsKey(
                                                                    key,
                                                                  ) ||
                                                              viewModel
                                                                      .quantityControllers[key] ==
                                                                  null) {
                                                            final existing = viewModel
                                                                .selectedProducts
                                                                .firstWhereOrNull(
                                                                  (e) =>
                                                                      e.productId ==
                                                                      item.productId,
                                                                );

                                                            viewModel
                                                                .quantityControllers[key] = TextEditingController(
                                                              text:
                                                                  (existing?.displayCheckCount ??
                                                                              0) ==
                                                                          0
                                                                      ? ''
                                                                      : existing!
                                                                          .displayCheckCount
                                                                          .toString(),
                                                            );
                                                          }

                                                          final controller =
                                                              viewModel
                                                                  .quantityControllers[key]!;

                                                          final isAvailable =
                                                              viewModel
                                                                  .selectedProducts
                                                                  .firstWhereOrNull(
                                                                    (e) =>
                                                                        e.productId ==
                                                                        item.productId,
                                                                  )
                                                                  ?.displayCheck ==
                                                              1;

                                                          return TextField(
                                                            controller:
                                                                controller,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            readOnly:
                                                                !isAvailable,
                                                            textAlign:
                                                                TextAlign
                                                                    .center, // ✅ Center align text
                                                            inputFormatters: [
                                                              LengthLimitingTextInputFormatter(
                                                                3,
                                                              ), // ✅ Max 3 characters
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly, // ✅ Allow only digits
                                                            ],
                                                            onTap: () {
                                                              if (!isAvailable) {
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                      LabelService()
                                                                          .getLabel(
                                                                            189,
                                                                          ),
                                                                    ),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            onChanged: (value) {
                                                              final count =
                                                                  int.tryParse(
                                                                    value,
                                                                  ) ??
                                                                  0;
                                                              final existing = viewModel
                                                                  .selectedProducts
                                                                  .firstWhereOrNull(
                                                                    (e) =>
                                                                        e.productId ==
                                                                        item.productId,
                                                                  );

                                                              if (existing !=
                                                                      null &&
                                                                  existing.displayCheck ==
                                                                      1) {
                                                                viewModel.addOrUpdateProductSelection(
                                                                  productId:
                                                                      item.productId,
                                                                  isTransfer: 1,
                                                                  transferCount:
                                                                      count,
                                                                  token:
                                                                      viewModel
                                                                          .user!
                                                                          .apiToken
                                                                          .toString(),
                                                                  storeId:
                                                                      widget
                                                                          .storeId,
                                                                  teamMemberId:
                                                                      viewModel
                                                                          .user!
                                                                          .teamMemberID
                                                                          .toString(),
                                                                  transferId:
                                                                      item.productId
                                                                          .toString(),
                                                                  visitId:
                                                                      widget
                                                                          .visiteId,
                                                                );
                                                              }
                                                            },
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  isAvailable
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .grey
                                                                          .shade500,
                                                            ),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor:
                                                                  Colors
                                                                      .grey
                                                                      .shade200,
                                                              hintText: '0',
                                                              hintStyle:
                                                                  TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .grey,
                                                                  ),
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        4,
                                                                    vertical: 8,
                                                                  ),
                                                              border: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .grey
                                                                          .shade300,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      4,
                                                                    ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .grey
                                                                          .shade300,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      4,
                                                                    ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color:
                                                                          AppColors.primary,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      4,
                                                                    ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
