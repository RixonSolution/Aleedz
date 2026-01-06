import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/store_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/user_training/user_training_promoter.dart';
import 'package:aleedz/viewmodel/user_training_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserTrainingStores extends ConsumerStatefulWidget {
  final String trainingName, trainingId;

  UserTrainingStores({required this.trainingName, required this.trainingId});

  @override
  ConsumerState<UserTrainingStores> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<UserTrainingStores> {
  TextEditingController searchController = TextEditingController();
  final Set<int> selectedStoreIds = {};
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
                LabelService().getLabel(291),
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
            widget.trainingName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body:
            viewModel.loader
                ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                )
                : Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        header,
                        const SizedBox(height: 12),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  style: const TextStyle(
                                    color: AppColors.blackColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: LabelService().getLabel(135),
                                    hintStyle: TextStyle(
                                      color: AppColors.greyText,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${selectedStoreIds.length}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 88),
                            itemCount: filteredStores.length,
                            itemBuilder: (context, index) {
                              final store = filteredStores[index];
                              final isSelected = selectedStoreIds.contains(
                                store.storeId,
                              );

                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  12,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x14000000),
                                        blurRadius: 14,
                                        offset: Offset(0, 6),
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
                                              topLeft: Radius.circular(18),
                                              bottomLeft: Radius.circular(18),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${index + 1}',
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
                                          14,
                                          14,
                                          14,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    store.storeName,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    store.address,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (isSelected) {
                                                    selectedStoreIds.remove(
                                                      store.storeId,
                                                    );
                                                  } else {
                                                    selectedStoreIds.add(
                                                      store.storeId,
                                                    );
                                                  }
                                                  addStoreIds(store.storeId);
                                                });
                                              },
                                              child: Icon(
                                                isSelected
                                                    ? Icons.check_circle
                                                    : Icons
                                                        .check_circle_outline,
                                                size: 32,
                                                color:
                                                    isSelected
                                                        ? AppColors.primary
                                                        : Colors.grey.shade400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: GestureDetector(
                            onTap: () async {
                              NavigationService.navigateTo(
                                UserTrainingPromoter(
                                  trainingName: widget.trainingName,
                                  trainingId: widget.trainingId,
                                  storeIds: storeIds.join(','),
                                ),
                              );
                            },
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  LabelService().getLabel(145),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
