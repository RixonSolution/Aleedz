import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/models/store_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/user_training/user_training_promoter.dart';
import 'package:aleedz/viewmodel/user_training_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserTrainingStores extends ConsumerStatefulWidget {
  final String trainingName, trainingId;

  UserTrainingStores({required this.trainingName, required this.trainingId});

  @override
  ConsumerState<UserTrainingStores> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<UserTrainingStores> {
  TextEditingController searchController = TextEditingController();
  final Set<int> selectedStoreIds = {}; // Use storeId, not index
  List<StoreModel> filteredStores = [];

  List<int> storeIds = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchStore();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadUserAndFetchStore() async {
    final notifier = ref.read(userTrainingModelProvider.notifier);
    await notifier.getCoverageList(context);
    filteredStores = notifier.stores;

    searchController.addListener(() {
      filterSearchResults();
    });
  }

  void addStoreIds(int id) {
    if (storeIds.contains(id)) {
      storeIds.remove(id);
      setState(() {});
    } else {
      storeIds.add(id);
      setState(() {});
    }
  }

  void filterSearchResults() {
    final viewModel = ref.watch(userTrainingModelProvider);

    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredStores = viewModel.stores;
      } else {
        filteredStores =
            viewModel.stores.where((store) {
              return store.storeName.toLowerCase().contains(query) ||
                  store.address.toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(userTrainingModelProvider);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          color: Colors.white,
          child: ElevatedButton(
            onPressed: () async {
              NavigationService.navigateTo(
                UserTrainingPromoter(
                  trainingName: widget.trainingName,
                  trainingId: widget.trainingId,
                  storeIds: storeIds.join(','),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: Text(
              'Next',
              style: TextStyle(fontSize: 14, color: AppColors.whiteColor),
            ),
          ),
        ),

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
                            'Trainings',
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
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(vertical: 12),

                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Center(
                        child: Text(
                          widget.trainingName,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Light grey background
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          /// Search TextField
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              style: const TextStyle(
                                color: AppColors.blackColor,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(color: AppColors.greyText),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                              ),
                            ),
                          ),

                          /// Selected Count
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              "${selectedStoreIds.length}", // <- Use your selected count
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(5),
                        itemCount: filteredStores.length,
                        itemBuilder: (context, index) {
                          final isSelected = selectedStoreIds.contains(
                            filteredStores[index].storeId,
                          );

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Text Info
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${index + 1}.  ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: AppColors.blackColor,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    child: Text(
                                                      filteredStores[index]
                                                          .storeName,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                        color:
                                                            AppColors
                                                                .blackColor,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 200,
                                                    child: Text(
                                                      filteredStores[index]
                                                          .address,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors
                                                                .blackColor,
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

                                    /// Custom Circular Checkbox
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          final storeId =
                                              filteredStores[index].storeId;
                                          if (isSelected) {
                                            selectedStoreIds.remove(storeId);
                                          } else {
                                            selectedStoreIds.add(storeId);
                                          }
                                          addStoreIds(
                                            filteredStores[index].storeId,
                                          );
                                        });
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                          top: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              isSelected
                                                  ? Colors.black
                                                  : Colors.grey[400],
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 25),
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
