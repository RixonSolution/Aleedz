import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/checklist_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/checklist/checklist_submit.dart';
import 'package:aleedz/viewmodel/checklist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChecklistView extends ConsumerStatefulWidget {
  String checkInTime, storeName;
  int storeId, visiteId;

  ChecklistView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
    required this.visiteId,
  }) : super(key: key);

  @override
  ConsumerState<ChecklistView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<ChecklistView> {
  TextEditingController searchController = TextEditingController();
  List<ChecklistModel> filteredActivityType = [];

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
    await notifier.loadActivity(widget.storeId.toString());
    setState(() {
      filteredActivityType = List.from(notifier.checkList);
    });
  }

  void filterActivityList(String query) {
    final lowerQuery = query.toLowerCase();
    final fullList = ref.read(checklistModelProvider.notifier).checkList;

    setState(() {
      filteredActivityType =
          fullList.where((item) {
            final name = item.checklist?.toLowerCase() ?? '';
            return name.contains(lowerQuery);
          }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(checklistModelProvider);
    final labelService = LabelService();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                        labelService.getLabel(65),
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
                    widget.storeName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_filled,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${labelService.getLabel(14)} ${widget.checkInTime}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: AppColors.blackColor),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: labelService.getLabel(135),
                      hintStyle: TextStyle(color: AppColors.greyText),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.search,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  viewModel.loader
                      ? Center(
                        child: LoadingAnimationWidget.discreteCircle(
                          color: AppColors.secondary,
                          size: 32,
                        ),
                      )
                      : filteredActivityType.isEmpty
                      ? Center(
                        child: Text(
                          labelService.getLabel(134),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filteredActivityType.length,
                        itemBuilder: (context, index) {
                          final activity = filteredActivityType[index];

                          final LinearGradient headerGradient =
                              const LinearGradient(
                                colors: [Color(0xFF111827), Color(0xFF0B1120)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              );
                          final bool isPrefilled = viewModel.checklistEntries
                              .any(
                                (e) =>
                                    e.checkListID ==
                                        activity.checklistCategoryID
                                            ?.toString() &&
                                    ((e.checkListStatus?.isNotEmpty ?? false) ||
                                        (e.description?.isNotEmpty ?? false)),
                              );

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                              onTap: () {
                                NavigationService.navigateTo(
                                  ChecklistSubmit(
                                    storeName: widget.storeName,
                                    checkInTime: widget.checkInTime,
                                    storeId: widget.storeId,
                                    checklistName: activity.checklist ?? '',
                                    visiteId: widget.visiteId,
                                    checklistTypeId:
                                        activity.checklistCategoryID!,
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    bottomLeft: Radius.circular(18),
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x0F000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Index strip
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          width: 30,
                                          decoration: BoxDecoration(
                                            gradient: headerGradient,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        56,
                                        16,
                                        0,
                                        16,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            activity.checklist ?? '',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                        ],
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
