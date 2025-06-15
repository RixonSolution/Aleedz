import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/models/activity_type_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/activity/activity_category_view.dart';
import 'package:aleedz/view/screens/checklist/checklist_submit.dart';
import 'package:aleedz/viewmodel/activity_viewmodel.dart';
import 'package:aleedz/viewmodel/checklist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChecklistView extends ConsumerStatefulWidget {
  String checkInTime, storeName;
  int storeId;

  ChecklistView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<ChecklistView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<ChecklistView> {
  TextEditingController searchController = TextEditingController();
  List<ActivityModelType> filteredActivityType = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchCoverage();
    });

    searchController.addListener(() {
      filterActivityList(searchController.text);
    });
  }

  Future<void> loadUserAndFetchCoverage() async {
    final notifier = ref.read(checklistModelProvider.notifier);
    await notifier.loadActivity();
    setState(() {
      filteredActivityType = List.from(notifier.activityType);
    });
  }

  void filterActivityList(String query) {
    final lowerQuery = query.toLowerCase();
    final fullList = ref.read(checklistModelProvider.notifier).activityType;

    setState(() {
      filteredActivityType =
          fullList.where((item) {
            final name = item.activityTypeName?.toLowerCase() ?? '';
            return name.contains(lowerQuery);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(checklistModelProvider);

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
                            'Checklist',
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
                    if (filteredActivityType.isEmpty)
                      const Expanded(
                        child: Center(child: Text('No results found')),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(5),
                          itemCount: filteredActivityType.length,
                          itemBuilder: (context, index) {
                            final activity = filteredActivityType[index];

                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    NavigationService.navigateTo(
                                      ChecklistSubmit(
                                        storeName: widget.storeName,
                                        checkInTime: widget.checkInTime,
                                        storeId: widget.storeId,
                                        checklistName:
                                            activity.activityTypeName ?? '',
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
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
                                            activity.activityTypeName ?? '',
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
