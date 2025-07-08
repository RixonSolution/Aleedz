import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        bottomNavigationBar:
            viewModel.loader
                ? Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
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
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.zero, // Removes rounded corners
                        ),
                        backgroundColor: AppColors.secondary,
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

        body: SingleChildScrollView(
          child: Column(
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
                            'Transfer: ${formattedDate}',
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
                            '${widget.transferStore}',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,

                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '${widget.transferStoreAddress}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              viewModel.loader
                  ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  )
                  : Builder(
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
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                                            children: [
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
                                                width: 80,
                                                child: Text(
                                                  LabelService().getLabel(60),
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
                              Column(
                                children: [
                                  // Product Rows
                                  ...brandItems.asMap().entries.map((entry) {
                                    int index = entry.key + 1; // Start from 1
                                    var item = entry.value;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Column(
                                        children: [
                                          //
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start, // Important for alignment
                                            children: [
                                              // Index + Product Info
                                              Expanded(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          24, // Adjust width to fit index cleanly
                                                      child: Text(
                                                        '$index.',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              AppColors
                                                                  .blackColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item.productModelCode,
                                                            style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  AppColors
                                                                      .blackColor,
                                                            ),
                                                          ),
                                                          Text(
                                                            item.productModelName,
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  AppColors
                                                                      .blackColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Availability Check
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

                                                    if (existing.displayCheck ==
                                                        0) {
                                                      existing
                                                          .displayCheckCount = 0;
                                                    }

                                                    newIsTransfer =
                                                        existing.displayCheck;
                                                    newCount =
                                                        existing
                                                            .displayCheckCount;
                                                  } else {
                                                    final newProduct =
                                                        ProductSelection(
                                                          productId:
                                                              item.productId,
                                                          displayCheck: 1,
                                                          displayCheckCount: 0,
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

                                                    viewModel.selectedProducts
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
                                                        transferCount: newCount,
                                                        token:
                                                            viewModel
                                                                .user!
                                                                .apiToken
                                                                .toString(),
                                                        storeId: widget.storeId,
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

                                                  viewModel.notifyListeners();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 5,
                                                      ),
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
                                                              ? Colors.black
                                                              : Colors
                                                                  .grey
                                                                  .shade400,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Quantity (Less than 3 Check)
                                              // Inside your widget tree
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
                                                      existing?.displayCheck ==
                                                      1;

                                                  if (!isAvailable) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Please mark this product as available first.",
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
                                                                .quantityControllers[key] =
                                                            TextEditingController(
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
                                                        controller: controller,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        readOnly: !isAvailable,
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
                                                              const SnackBar(
                                                                content: Text(
                                                                  "Please mark this product as available first.",
                                                                ),
                                                                backgroundColor:
                                                                    Colors.red,
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
                                                                  ? Colors.black
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
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                          isDense: true,
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 4,
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
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color:
                                                                          Colors
                                                                              .black,
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
                                          const Divider(),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
