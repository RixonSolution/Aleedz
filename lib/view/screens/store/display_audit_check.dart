import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/models/audit_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayAuditCheck extends ConsumerStatefulWidget {
  String storeName, checkInTime, categoryName, lastUpdate;
  int storeId, categoryId;
  DisplayAuditCheck({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.categoryId,
    required this.categoryName,
    required this.lastUpdate,
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

      ref.read(storeModelProvider.notifier).clearData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeModelProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Your submit logic
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Removes rounded corners
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
                                          widget.lastUpdate,
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
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 5,
                                                ),
                                                child: SizedBox(
                                                  width: 60,
                                                  child: Icon(
                                                    item.displayCheck == 0
                                                        ? Icons
                                                            .check_circle_outline
                                                        : Icons.check_circle,
                                                    color:
                                                        item.displayCheck == 0
                                                            ? Colors
                                                                .grey
                                                                .shade400
                                                            : Colors.black,
                                                  ),
                                                ),
                                              ),

                                              // Less than 2 Check
                                              SizedBox(
                                                width: 60,
                                                child: Icon(
                                                  item.displayCheckCount == 0
                                                      ? Icons
                                                          .check_circle_outline
                                                      : Icons.check_circle,
                                                  color:
                                                      item.displayCheckCount ==
                                                              0
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
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: TextField(
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your comments...',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        // Camera Image Picker
                                        Expanded(
                                          child:
                                              viewModel.cameraImage != null
                                                  ? Stack(
                                                    children: [
                                                      Image.file(
                                                        viewModel.cameraImage!,
                                                        fit: BoxFit.cover,
                                                        height: 150,
                                                        width: double.infinity,
                                                      ),
                                                      Positioned(
                                                        top: 4,
                                                        right: 4,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            viewModel
                                                                    .cameraImage =
                                                                null;
                                                            viewModel
                                                                .notifyListeners(); // if using ChangeNotifier
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                                  color:
                                                                      AppColors
                                                                          .secondary,
                                                                  shape:
                                                                      BoxShape
                                                                          .circle,
                                                                ),
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  4,
                                                                ),
                                                            child: const Icon(
                                                              Icons.close,
                                                              size: 16,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : GestureDetector(
                                                    onTap: () {
                                                      viewModel
                                                          .pickFromCamera();
                                                    },
                                                    child: Container(
                                                      height: 150,
                                                      color:
                                                          Colors.grey.shade300,
                                                      child: const Center(
                                                        child: Text(
                                                          "Pick from Camera",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                        ),

                                        const SizedBox(width: 10),

                                        // Gallery Image Picker
                                        Expanded(
                                          child:
                                              viewModel.galleryImage != null
                                                  ? Stack(
                                                    children: [
                                                      Image.file(
                                                        viewModel.galleryImage!,
                                                        fit: BoxFit.cover,
                                                        height: 150,
                                                        width: double.infinity,
                                                      ),
                                                      Positioned(
                                                        top: 4,
                                                        right: 4,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            viewModel
                                                                    .galleryImage =
                                                                null;
                                                            viewModel
                                                                .notifyListeners(); // if using ChangeNotifier
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                                  color:
                                                                      AppColors
                                                                          .secondary,
                                                                  shape:
                                                                      BoxShape
                                                                          .circle,
                                                                ),
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  4,
                                                                ),
                                                            child: const Icon(
                                                              Icons.close,
                                                              size: 16,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : GestureDetector(
                                                    onTap: () {
                                                      viewModel
                                                          .pickFromGallery();
                                                    },
                                                    child: Container(
                                                      height: 150,
                                                      color:
                                                          Colors.grey.shade300,
                                                      child: const Center(
                                                        child: Text(
                                                          "Pick from Gallery",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 20),
                                ],
                              ),
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
