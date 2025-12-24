import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/category_store_share_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/store_share_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StoreShareView extends ConsumerStatefulWidget {
  String checkInTime, storeName;
  int storeId;

  StoreShareView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<StoreShareView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<StoreShareView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchIssues();
    });
  }

  Future<void> loadUserAndFetchIssues() async {
    final notifier = ref.read(storeShareModelProvider.notifier);
    await notifier.loadShare();
  }

  int selectedTab = 0;

  // Temporary hardcoded permissions
  final Map<int, String> permissions = {
    44: 'Y', // For Brand
    45: 'N', // For Category
    46: 'Y', // For Product
  };

  bool showCheckIcon(int tabIndex) {
    if (tabIndex == 0) return permissions[44] == 'Y';
    if (tabIndex == 1) return permissions[45] == 'Y';
    if (tabIndex == 2) return permissions[46] == 'Y';
    return false;
  }

  Widget _buildTabButton(String label, int index) {
    final bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          margin: EdgeInsets.only(right: 1),
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: isSelected ? AppColors.secondary : Colors.grey[300],
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, List<CategoryStoreShareModel>> groupByBrand(
    List<CategoryStoreShareModel> list,
  ) {
    final Map<String, List<CategoryStoreShareModel>> grouped = {};
    for (var item in list) {
      if (item.brandName == null) continue;
      grouped.putIfAbsent(item.brandName!, () => []).add(item);
    }
    return grouped;
  }

  Widget _buildGroupedList() {
    final viewModel = ref.watch(storeShareModelProvider);

    final groupedData = groupByBrand(viewModel.categoryShareList);

    return ListView(
      children:
          groupedData.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Header
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        showCheckIcon(selectedTab) ? "Available" : "Count",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // List of Categories under this Brand
                ...entry.value.map(
                  (item) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.productCategoryName ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            showCheckIcon(selectedTab)
                                ? const Icon(
                                  Icons.check_circle,
                                  color: AppColors.greyText,
                                  size: 26,
                                )
                                : SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: TextField(
                                    controller: TextEditingController(
                                      text: (item.count ?? '').toString(),
                                    ),
                                    onChanged: (value) {
                                      item.count = int.tryParse(value) ?? 0;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 0,
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildBrandList() {
    final viewModel = ref.watch(storeShareModelProvider);

    return ListView.builder(
      itemCount: viewModel.brandShareList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${index + 1}.  ${viewModel.brandShareList[index].brandName.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  showCheckIcon(0)
                      ? const Icon(
                        Icons.check_circle,
                        color: AppColors.greyText,
                        size: 28,
                      )
                      : SizedBox(
                        width: 100,
                        height: 40,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 0,
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
            if (index != viewModel.brandShareList.length - 1)
              const Divider(height: 0),
          ],
        );
      },
    );
  }

  Widget _buildProductList() {
    final viewModel = ref.watch(storeShareModelProvider);

    return ListView.builder(
      itemCount: viewModel.productShareList.length,
      itemBuilder: (context, index) {
        final product = viewModel.productShareList[index];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product Name
                  SizedBox(
                    width: 250,
                    child: Text(
                      product.productModelName ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  // Count or Check Icon
                  showCheckIcon(selectedTab)
                      ? const Icon(
                        Icons.check_circle,
                        color: AppColors.greyText,
                        size: 26,
                      )
                      : SizedBox(
                        width: 100,
                        height: 40,
                        child: TextField(
                          controller: TextEditingController(
                            text: (product.count ?? '').toString(),
                          ),
                          onChanged: (value) {
                            product.count = int.tryParse(value) ?? 0;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 0,
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
            const Divider(height: 0),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeShareModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body:
            viewModel.loader
                ? Center(child: LoadingAnimationWidget.discreteCircle(color: Theme.of(context).colorScheme.primary, size: 32))
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
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
                            LabelService().getLabel(184),
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
                    const SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(color: AppColors.primary, height: 0),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        widget.storeName,
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '${LabelService().getLabel(14)} ${widget.checkInTime}',
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    // Top Tab Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          _buildTabButton('Brand', 0),
                          _buildTabButton('Category', 1),
                          _buildTabButton('Product', 2),
                        ],
                      ),
                    ),
                    Divider(thickness: 1, indent: 12, endIndent: 12),
                    // Table Headers
                    selectedTab == 0
                        ? Container(
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  '  Brand',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Available',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                        : Padding(
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
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                ),
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

                    // Divider(thickness: 1, indent: 12, endIndent: 12),
                    // List Items
                    Expanded(
                      child:
                          selectedTab == 0
                              ? _buildBrandList()
                              : selectedTab == 1
                              ? _buildGroupedList()
                              : _buildProductList(),
                    ),
                  ],
                ),
      ),
    );
  }
}
