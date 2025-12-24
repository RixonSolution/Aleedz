import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/activity/activity_submit_view.dart';
import 'package:aleedz/viewmodel/activity_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ActivityCategoryView extends ConsumerStatefulWidget {
  String checkInTime, storeName, activityTypeName;
  int storeId, divisionId, activityTypeId;

  ActivityCategoryView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
    required this.activityTypeName,
    required this.divisionId,
    required this.activityTypeId,
  }) : super(key: key);

  @override
  ConsumerState<ActivityCategoryView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<ActivityCategoryView> {
  TextEditingController searchController = TextEditingController();
  List filteredList = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await loadUserAndFetchCoverage();
      applyFilter();
    });
    searchController.addListener(applyFilter);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadUserAndFetchCoverage() async {
    await ref
        .read(activityModelProvider.notifier)
        .getActivityCategoryId(
          divisionId: widget.divisionId.toString(),
          categoryTypeId: widget.activityTypeId.toString(),
        );
  }

  void applyFilter() {
    final viewModel = ref.read(activityModelProvider);
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredList =
          viewModel.activityCategoryId
              .where(
                (item) =>
                    item.activityCategoryName?.toLowerCase().contains(query) ??
                    false,
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(activityModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body:
            viewModel.loader
                ? Center(child: LoadingAnimationWidget.discreteCircle(color: Theme.of(context).colorScheme.primary, size: 32))
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
                            LabelService().getLabel(117),
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
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              widget.activityTypeName,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(color: AppColors.blackColor),
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
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(5),
                        itemCount: filteredList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  NavigationService.navigateTo(
                                    ActivitySubmitView(
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
                                          '${index + 1}.  ',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.activityCategoryName ?? '',
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
