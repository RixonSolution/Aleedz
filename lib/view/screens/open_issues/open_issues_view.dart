import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/viewmodel/open_issues_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class StoreIssuesScreen extends ConsumerStatefulWidget {
  @override
  _StoreIssuesScreenState createState() => _StoreIssuesScreenState();
}

class _StoreIssuesScreenState extends ConsumerState<StoreIssuesScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadData();
    });
  }

  void loadData() async {
    ref.read(openIssueModelProvider.notifier).loadIssues();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(openIssueModelProvider);

    final filteredList =
        viewModel.openIssueList.where((issue) {
          final query = searchQuery.toLowerCase();
          return issue.storeName!.toLowerCase().contains(query) ||
              issue.activityCategoryName!.toLowerCase().contains(query) ||
              issue.activityTypeName!.toLowerCase().contains(query);
        }).toList();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      NavigationService.resetTo(
                        DashboardView(initialIndex: 0),
                      ); // or any index like 2
                    },
                    child: Image.asset(
                      AppIcons.backArrow,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Text(
                    LabelService().getLabel(80),
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.refresh,
                      size: 30,
                      color: AppColors.whiteColor,
                    ),
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

            // --- Header Section remains unchanged ---
            SizedBox(height: 10),
            // 🔥 Search TextField 🔥
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by Store, Category, or Type',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(color: AppColors.greyText, height: 0),
            ),
            viewModel.loader
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${index + 1} ${viewModel.openIssueList[index].storeName}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${viewModel.openIssueList[index].activityCategoryName}/${viewModel.openIssueList[index].activityTypeName}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Issue Reported: ${viewModel.openIssueList[index].activityDateTime}',
                                ),
                                SizedBox(height: 8),
                                Text(
                                  viewModel
                                      .openIssueList[index]
                                      .activityDescription
                                      .toString(),
                                ),
                                SizedBox(height: 8),
                                SizedBox(
                                  height: 100,
                                  width: double.infinity,
                                  child: Image.network(
                                    '${ApiConstants.baseUrl}/${viewModel.openIssueList[index].imageActivity.toString()}'
                                        .trim(),
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(color: Colors.white),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 8),
                                Center(
                                  child: Text(
                                    'Close Issue',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
