import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/models/user_training_type.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/user_training/user_training_stores.dart';
import 'package:aleedz/viewmodel/user_training_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserTrainingView extends ConsumerStatefulWidget {
  UserTrainingView({Key? key}) : super(key: key);

  @override
  ConsumerState<UserTrainingView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<UserTrainingView> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchType();
    });
  }

  Future<void> loadUserAndFetchType() async {
    final notifier = ref.read(userTrainingModelProvider.notifier);
    await notifier.userTrainingType();
    filteredTrainingList = notifier.trainingTypeList;
    searchController.addListener(() {
      filterSearchResults();
    });
  }

  List<UserTrainingType> filteredTrainingList = [];

  void filterSearchResults() {
    final viewModel = ref.watch(userTrainingModelProvider);

    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredTrainingList = viewModel.trainingTypeList;
      } else {
        filteredTrainingList =
            viewModel.trainingTypeList.where((item) {
              return item.trainingTypeName!.toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(userTrainingModelProvider);

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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(color: AppColors.blackColor),
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: AppColors.greyText),
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.greyText),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.greyText),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(5),
                        itemCount: filteredTrainingList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  NavigationService.navigateTo(
                                    UserTrainingStores(
                                      trainingName:
                                          viewModel
                                              .trainingTypeList[index]
                                              .trainingTypeName
                                              .toString(),
                                      trainingId:
                                          viewModel
                                              .trainingTypeList[index]
                                              .trainingTypeID
                                              .toString(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        child: Text(
                                          '${index + 1}.',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          viewModel
                                              .trainingTypeList[index]
                                              .trainingTypeName
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
