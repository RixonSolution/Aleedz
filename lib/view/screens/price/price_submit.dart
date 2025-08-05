import 'dart:io';

import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/price_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PriceSubmit extends ConsumerStatefulWidget {
  String storeName, checkInTime, brandName, productName;
  int storeId, brandId, visiteId, productCategoryId;
  PriceSubmit({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.brandId,
    required this.visiteId,
    required this.brandName,
    required this.productName,
    required this.productCategoryId,
  }) : super(key: key);

  @override
  ConsumerState<PriceSubmit> createState() => _DisplayAuditCheckSummaryState();
}

class _DisplayAuditCheckSummaryState extends ConsumerState<PriceSubmit> {
  void _showImagePickerDialog(
    String direction, {
    required Function(String) onImageSelected,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondary,
          title: Text(
            LabelService().getLabel(111),
            style: TextStyle(color: AppColors.whiteColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  LabelService().getLabel(112),
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                onTap: () async {
                  final path = await ref
                      .read(priceModelProvider.notifier)
                      .pickFromCamera(direction);
                  Navigator.pop(context);
                  if (path != null) onImageSelected(path);
                },
              ),
              ListTile(
                title: Text(
                  LabelService().getLabel(113),
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                onTap: () async {
                  final path = await ref
                      .read(priceModelProvider.notifier)
                      .pickFromGallery(direction);
                  Navigator.pop(context);
                  if (path != null) onImageSelected(path);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(priceModelProvider.notifier)
          .pricePromotionList(
            brandId: widget.brandId.toString(),
            productCategoryId: widget.productCategoryId.toString(),
            storeId: widget.storeId.toString(),
            visiteId: widget.visiteId.toString(),
          );
    });
  }

  String? getChecklistImagePath(String productId) {
    final viewModel = ref.watch(priceModelProvider);

    final matchingEntries = viewModel.productEntries.where(
      (e) => e.productId == productId,
    );

    if (matchingEntries.isNotEmpty) {
      return matchingEntries.first.priceImage;
    }

    return null;
  }

  bool? getOutOfStock(String productId) {
    final viewModel = ref.watch(priceModelProvider);

    final matchingEntries = viewModel.productEntries.where(
      (e) => e.productId == productId,
    );

    if (matchingEntries.isNotEmpty) {
      return matchingEntries.first.isOutOfStock;
    }

    return false;
  }

  String? getPrice(String productId) {
    final viewModel = ref.watch(priceModelProvider);

    final matchingEntries = viewModel.productEntries.where(
      (e) => e.productId == productId,
    );

    if (matchingEntries.isNotEmpty) {
      return matchingEntries.first.price;
    }

    return null;
  }

  String? getNetPrice(String productId) {
    final viewModel = ref.watch(priceModelProvider);

    final matchingEntries = viewModel.productEntries.where(
      (e) => e.productId == productId,
    );

    if (matchingEntries.isNotEmpty) {
      return matchingEntries.first.netPrice;
    }

    return null;
  }

  String? getPromotiion(String productId) {
    final viewModel = ref.watch(priceModelProvider);

    final matchingEntries = viewModel.productEntries.where(
      (e) => e.productId == productId,
    );

    if (matchingEntries.isNotEmpty) {
      return matchingEntries.first.promotion;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(priceModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Removes focus from any text field
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          bottomNavigationBar: GestureDetector(
            onTap: () async {
              await viewModel.submitAllPrices(
                widget.storeId,
                widget.visiteId.toString(),
              );
              AppSnackBar.showSuccess(context, 'Price Promotions submitted}');
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0), // Optional padding
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: AppColors.secondary),
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    viewModel.loader
                        ? Center(child: CircularProgressIndicator())
                        : Text(
                          LabelService().getLabel(73),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                  ],
                ),
              ),
            ),
          ),
          body:
              viewModel.loader
                  ? Center(child: CircularProgressIndicator())
                  : Column(
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
                          '${LabelService().getLabel(14)} ${widget.checkInTime}',
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.secondary),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.brandName.toString(),
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.productName.toString(),
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: ListView.builder(
                          primary: true,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: viewModel.priceList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final isOutOfStock = getOutOfStock(
                              viewModel.priceList[index].productID.toString(),
                            );

                            final priceController = TextEditingController(
                              text: getPrice(
                                viewModel.priceList[index].productID.toString(),
                              ),
                            );
                            final netPriceController = TextEditingController(
                              text: getNetPrice(
                                viewModel.priceList[index].productID.toString(),
                              ),
                            );

                            final promotionController = TextEditingController(
                              text: getPromotiion(
                                viewModel.priceList[index].productID.toString(),
                              ),
                            );

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: getOutOfStock(
                                        viewModel.priceList[index].productID
                                            .toString(),
                                      ),
                                      onChanged: (value) {
                                        setState(() {});
                                        viewModel.updateProductEntry(
                                          productId:
                                              viewModel
                                                  .priceList[index]
                                                  .productID
                                                  .toString(),
                                          storeId: widget.storeId.toString(),
                                          visitId: widget.visiteId.toString(),
                                          token: viewModel.user?.apiToken ?? '',
                                          teamMemberId:
                                              viewModel.user?.teamMemberID
                                                  .toString(),
                                          isOutOfStock: value,
                                          price: '0',
                                          netPrice: '0',
                                          promotion: '',
                                          imagePath: '',
                                        );
                                      },
                                    ),
                                    Text(LabelService().getLabel(72)),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${index + 1}  ',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 200,
                                                      child: Text(
                                                        viewModel
                                                                .priceList[index]
                                                                .productmodelname ??
                                                            '',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),

                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      color:
                                                          AppColors
                                                              .lightGreyBackground,
                                                      child: TextField(
                                                        controller:
                                                            priceController,
                                                        enabled:
                                                            !(isOutOfStock ??
                                                                false),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onChanged: (value) {
                                                          viewModel.updateProductEntry(
                                                            productId:
                                                                viewModel
                                                                    .priceList[index]
                                                                    .productID
                                                                    .toString(),
                                                            storeId:
                                                                widget.storeId
                                                                    .toString(),
                                                            visitId:
                                                                widget.visiteId
                                                                    .toString(),
                                                            token:
                                                                viewModel
                                                                    .user
                                                                    ?.apiToken ??
                                                                '',
                                                            teamMemberId:
                                                                viewModel
                                                                    .user
                                                                    ?.teamMemberID
                                                                    .toString(),

                                                            price: value,
                                                          );
                                                        },
                                                        textAlign:
                                                            TextAlign.center,
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        decoration: InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          hintText:
                                                              LabelService()
                                                                  .getLabel(69),
                                                          border:
                                                              OutlineInputBorder(),
                                                          filled: true,
                                                          fillColor:
                                                              AppColors
                                                                  .lightGreyBackground,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      width: 100,
                                                      color:
                                                          AppColors
                                                              .lightGreyBackground,
                                                      child: TextField(
                                                        controller:
                                                            netPriceController,
                                                        enabled:
                                                            !(isOutOfStock ??
                                                                false),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onChanged: (value) {
                                                          viewModel.updateProductEntry(
                                                            productId:
                                                                viewModel
                                                                    .priceList[index]
                                                                    .productID
                                                                    .toString(),
                                                            storeId:
                                                                widget.storeId
                                                                    .toString(),
                                                            visitId:
                                                                widget.visiteId
                                                                    .toString(),
                                                            token:
                                                                viewModel
                                                                    .user
                                                                    ?.apiToken ??
                                                                '',
                                                            teamMemberId:
                                                                viewModel
                                                                    .user
                                                                    ?.teamMemberID
                                                                    .toString(),

                                                            netPrice: value,
                                                          );
                                                        },
                                                        textAlign:
                                                            TextAlign.center,
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        decoration: InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          hintText:
                                                              LabelService()
                                                                  .getLabel(70),
                                                          border:
                                                              OutlineInputBorder(),
                                                          filled: true,
                                                          fillColor:
                                                              AppColors
                                                                  .lightGreyBackground,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (getOutOfStock(
                                                    viewModel
                                                        .priceList[index]
                                                        .productID
                                                        .toString(),
                                                  ) ==
                                                  false) {
                                                _showImagePickerDialog(
                                                  'left',
                                                  onImageSelected: (
                                                    String path,
                                                  ) {
                                                    setState(() {
                                                      print(
                                                        'selected image $path',
                                                      );
                                                    });

                                                    viewModel.updateProductEntry(
                                                      productId:
                                                          viewModel
                                                              .priceList[index]
                                                              .productID
                                                              .toString(),
                                                      storeId:
                                                          widget.storeId
                                                              .toString(),
                                                      visitId:
                                                          widget.visiteId
                                                              .toString(),
                                                      token:
                                                          viewModel
                                                              .user
                                                              ?.apiToken ??
                                                          '',
                                                      teamMemberId:
                                                          viewModel
                                                              .user
                                                              ?.teamMemberID
                                                              .toString(),
                                                      imagePath: path,
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColors
                                                        .lightGreyBackground,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Builder(
                                                builder: (_) {
                                                  final imagePath =
                                                      getChecklistImagePath(
                                                        viewModel
                                                            .priceList[index]
                                                            .productID
                                                            .toString(),
                                                      );
                                                  if (imagePath != null &&
                                                      imagePath.isNotEmpty) {
                                                    return Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          child: Image.file(
                                                            File(imagePath),
                                                            width: 100,
                                                            height: 100,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 4,
                                                          right: 4,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {});
                                                              viewModel.updateProductEntry(
                                                                productId:
                                                                    viewModel
                                                                        .priceList[index]
                                                                        .productID
                                                                        .toString(),
                                                                storeId:
                                                                    widget
                                                                        .storeId
                                                                        .toString(),
                                                                visitId:
                                                                    widget
                                                                        .visiteId
                                                                        .toString(),
                                                                token:
                                                                    viewModel
                                                                        .user
                                                                        ?.apiToken ??
                                                                    '',
                                                                teamMemberId:
                                                                    viewModel
                                                                        .user
                                                                        ?.teamMemberID
                                                                        .toString(),
                                                                imagePath: '',
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    Colors
                                                                        .black54,
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                              ),
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    4,
                                                                  ),
                                                              child: Icon(
                                                                Icons.close,
                                                                size: 18,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return Icon(
                                                      Icons.camera_alt,
                                                      size: 32,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      // Promotions field
                                      Container(
                                        color: AppColors.lightGreyBackground,
                                        child: TextField(
                                          controller: promotionController,
                                          enabled: !(isOutOfStock ?? false),
                                          keyboardType: TextInputType.text,
                                          onChanged: (value) {
                                            viewModel.updateProductEntry(
                                              productId:
                                                  viewModel
                                                      .priceList[index]
                                                      .productID
                                                      .toString(),
                                              storeId:
                                                  widget.storeId.toString(),
                                              visitId:
                                                  widget.visiteId.toString(),
                                              token:
                                                  viewModel.user?.apiToken ??
                                                  '',
                                              teamMemberId:
                                                  viewModel.user?.teamMemberID
                                                      .toString(),

                                              promotion: value,
                                            );
                                          },
                                          decoration: InputDecoration(
                                            labelText: LabelService().getLabel(
                                              71,
                                            ),
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor:
                                                AppColors.lightGreyBackground,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(indent: 15, endIndent: 15),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
