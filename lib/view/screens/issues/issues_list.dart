import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/activity_category_Id_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/issues/issues_submit.dart';
import 'package:aleedz/viewmodel/issues_veiwmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class IssuesList extends ConsumerStatefulWidget {
  String checkInTime, storeName;
  int storeId;

  IssuesList({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<IssuesList> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<IssuesList> {
  TextEditingController searchController = TextEditingController();
  List<ActivityCategoryModel> filteredIssuesList = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchIssues();
    });

    searchController.addListener(() {
      filterActivityList(searchController.text);
    });
  }

  Future<void> loadUserAndFetchIssues() async {
    final notifier = ref.read(issuesModelProvider.notifier);
    await notifier.loadActivity();
    setState(() {
      filteredIssuesList = List.from(notifier.issueList);
    });
  }

  void filterActivityList(String query) {
    final lowerQuery = query.toLowerCase();
    final fullList = ref.read(issuesModelProvider.notifier).issueList;

    setState(() {
      filteredIssuesList =
          fullList.where((item) {
            final name = item.activityCategoryName?.toLowerCase() ?? '';
            return name.contains(lowerQuery);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(issuesModelProvider);

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
                          const Text(
                            'Issues',
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(color: AppColors.blackColor),
                        decoration: InputDecoration(
                          hintText: LabelService().getLabel(135),
                          hintStyle: TextStyle(color: AppColors.greyText),
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.greyText),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (filteredIssuesList.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(LabelService().getLabel(134)),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(5),
                          itemCount: filteredIssuesList.length,
                          itemBuilder: (context, index) {
                            final activity = filteredIssuesList[index];

                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    NavigationService.navigateTo(
                                      IssueSubmitView(
                                        storeName: widget.storeName,
                                        checkInTime: widget.checkInTime,
                                        storeId: widget.storeId,
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
                                            activity.activityCategoryName ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/icons/arrow_right.jpeg',
                                          height: 30,
                                          width: 30,
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
