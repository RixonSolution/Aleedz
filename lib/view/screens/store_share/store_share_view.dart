import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/store_share_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  final List<String> brandList = ['1. Logitec', '2. Razer', '3. HP'];

  final Map<String, List<String>> categoriesByBrand = {
    'Logitec': ['B2C Category', 'Headphone'],
    'Brand 2': ['B2C Category', 'Headphone'],
  };

  final Map<String, List<String>> productsByBrand = {
    'Logitec': ['MX Master 3', 'Z200 Speakers'],
    'Razer': ['BlackWidow V3', 'Kraken X'],
  };

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

  Widget _buildGroupedList(Map<String, List<String>> groupedData) {
    return ListView(
      children:
          groupedData.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
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
                              item,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            showCheckIcon(selectedTab)
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.black,
                                  size: 26,
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
    return ListView.builder(
      itemCount: brandList.length,
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
                    brandList[index],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  showCheckIcon(0)
                      ? const Icon(
                        Icons.check_circle,
                        color: Colors.black,
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
            if (index != brandList.length - 1) const Divider(height: 0),
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
                ? const Center(child: CircularProgressIndicator())
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
                          const Text(
                            'Store Share',
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
                        'Checked In ${widget.checkInTime}',
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
                                  'Brand',
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
                                  color: AppColors.secondary,
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
                              : _buildGroupedList(
                                selectedTab == 1
                                    ? categoriesByBrand
                                    : productsByBrand,
                              ),
                    ),
                  ],
                ),
      ),
    );
  }
}
