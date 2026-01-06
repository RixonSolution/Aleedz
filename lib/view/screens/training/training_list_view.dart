import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/training/training_promoter.dart';
import 'package:aleedz/view/screens/training/training_submit.dart';
import 'package:aleedz/viewmodel/training_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TrainingListView extends ConsumerStatefulWidget {
  String checkInTime, storeName;
  int storeId, visiteId;

  TrainingListView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
    required this.visiteId,
  }) : super(key: key);

  @override
  ConsumerState<TrainingListView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<TrainingListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchCoverage();
    });
  }

  Future<void> loadUserAndFetchCoverage() async {
    final notifier = ref.read(trainingModelProvider.notifier);
    await notifier.loadTraining(widget.storeId.toString());
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
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 16,
                            right: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12),

                            // border: Border.all(color: Colors.grey.shade300),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        '#   ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        LabelService().getLabel(138),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    LabelService().getLabel(139),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 88),
                            itemCount: viewModel.trainingList.length,
                            itemBuilder: (context, index) {
                              final item = viewModel.trainingList[index];
                              return GestureDetector(
                                onTap: () {
                                  NavigationService.navigateTo(
                                    TrainingSubmit(
                                      storeName: widget.storeName,
                                      checkInTime: widget.checkInTime,
                                      storeId: widget.storeId,
                                      trainingName:
                                          item.trainingModelTitle ?? '',
                                      trainingId:
                                          item.trainingID?.toString() ?? '-',
                                      storeCount: 0,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    5,
                                    16,
                                    5,
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
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${LabelService().getLabel(140)}: ${item.trainingID}',
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
                                                      LabelService().getLabel(
                                                        165,
                                                      ),
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade600,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      item.description
                                                          .toString(),
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade700,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      item.trainingDateTime
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color:
                                                            AppColors
                                                                .blackColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                item.attendese.toString(),
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
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
                    SafeArea(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: GestureDetector(
                            onTap: () {
                              NavigationService.navigateTo(
                                TrainingPromoter(
                                  storeName: widget.storeName,
                                  checkInTime: widget.checkInTime,
                                  storeId: widget.storeId,
                                  trainingName: '',
                                  storeCount: 0,
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
                                  LabelService().getLabel(136),
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
