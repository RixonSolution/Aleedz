import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/training/training_model_view.dart';
import 'package:aleedz/viewmodel/training_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TrainingPromoter extends ConsumerStatefulWidget {
  String checkInTime, storeName, trainingName;
  int storeId, storeCount;

  TrainingPromoter({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
    required this.trainingName,
    required this.storeCount,
  }) : super(key: key);

  @override
  ConsumerState<TrainingPromoter> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<TrainingPromoter> {
  TextEditingController searchController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  final Set<int> selectedIndexes = {};

  List<Promoter> promoterList = [];
  List<Promoter> promoterNames1 = [];

  void addName() {
    if (idController.text.isNotEmpty && nameController.text.isNotEmpty) {
      setState(() {
        promoterList.add(
          Promoter(
            id: idController.text.trim(),
            name: nameController.text.trim(),
          ),
        );
        idController.clear();
        nameController.clear();
      });
    }
  }

  void removeName(int index) {
    setState(() {
      promoterList.removeAt(index);
    });
  }

  void addPromoterName(String name, String id) {
    final existingIndex = promoterNames1.indexWhere(
      (promoter) => promoter.id == id,
    );

    setState(() {
      if (existingIndex != -1) {
        promoterNames1.removeAt(existingIndex);
      } else {
        promoterNames1.add(Promoter(id: id.trim(), name: name.trim()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchPromoter();
    });
  }

  Future<void> loadUserAndFetchPromoter() async {
    final notifier = ref.read(trainingModelProvider.notifier);
    await notifier.getPromoterList(storeId: widget.storeId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(trainingModelProvider);
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
            widget.storeName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${LabelService().getLabel(14)} ${widget.checkInTime}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check, color: AppColors.primary, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${LabelService().getLabel(14)} ${widget.checkInTime}',
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
                        const SizedBox(height: 20),

                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 88),
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                                itemCount: viewModel.promoterList.length,
                                itemBuilder: (context, index) {
                                  final isSelected = selectedIndexes.contains(
                                    index,
                                  );
                                  void toggleSelection() {
                                    setState(() {
                                      if (isSelected) {
                                        selectedIndexes.remove(index);
                                      } else {
                                        selectedIndexes.add(index);
                                      }
                                    });
                                    addPromoterName(
                                      viewModel
                                          .promoterList[index]
                                          .teamMemberName
                                          .toString(),
                                      viewModel.promoterList[index].teamMemberID
                                          .toString(),
                                    );
                                  }

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
                                        border: Border.all(
                                          color: Colors.transparent,
                                        ),
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
                                                  bottomLeft: Radius.circular(
                                                    18,
                                                  ),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        viewModel
                                                                .promoterList[index]
                                                                .teamMemberName ??
                                                            '',
                                                        style: const TextStyle(
                                                          color:
                                                              AppColors
                                                                  .blackColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        viewModel
                                                                .promoterList[index]
                                                                .storeName
                                                                ?.toString() ??
                                                            '',
                                                        style: TextStyle(
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade600,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: toggleSelection,
                                                  child: Icon(
                                                    isSelected
                                                        ? Icons.check_circle
                                                        : Icons
                                                            .check_circle_outline,
                                                    size: 35,
                                                    color:
                                                        isSelected
                                                            ? AppColors.primary
                                                            : Colors
                                                                .grey
                                                                .shade400,
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

                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 16,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  // border: Border.all(
                                  //   color: Colors.grey.shade300,
                                  // ),
                                  color: AppColors.whiteColor,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      LabelService().getLabel(146),
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    /// ID Field
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        controller: idController,
                                        decoration: InputDecoration(
                                          hintText: LabelService().getLabel(
                                            147,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    /// Name Field
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          hintText: LabelService().getLabel(
                                            148,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    /// Add Button
                                    GestureDetector(
                                      onTap: addName,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              /// Table Header
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          '#',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          'ID',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          'Name',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          LabelService().getLabel(149),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// List of Entries
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: promoterList.length,
                                itemBuilder: (context, index) {
                                  final promoter = promoterList[index];
                                  return Container(
                                    margin: const EdgeInsets.fromLTRB(
                                      16,
                                      8,
                                      16,
                                      0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Center(
                                            child: Text(
                                              promoter.id,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Center(
                                            child: Text(
                                              promoter.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: InkWell(
                                              onTap: () => removeName(index),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.orange,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.orange,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
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
                                TrainingModelView(
                                  storeName: widget.storeName,
                                  checkInTime: widget.checkInTime,
                                  storeId: widget.storeId,
                                  trainingName: widget.trainingName,
                                  storeCount: widget.storeCount,
                                  promotorCount: selectedIndexes.length,
                                  promoterNames1: promoterNames1,
                                  promoterList: promoterList,
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

class Promoter {
  final String id;
  final String name;

  Promoter({required this.id, required this.name});
}
