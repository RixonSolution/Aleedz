import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/training/training_promoter.dart';
import 'package:aleedz/viewmodel/training_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TrainingModelView extends ConsumerStatefulWidget {
  String checkInTime, storeName, trainingName;
  int storeId, storeCount, promotorCount;
  List<Promoter> promoterNames1;
  List<Promoter> promoterList;

  TrainingModelView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
    required this.trainingName,
    required this.storeCount,
    required this.promotorCount,
    required this.promoterList,
    required this.promoterNames1,
  }) : super(key: key);

  @override
  ConsumerState<TrainingModelView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<TrainingModelView> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  bool _isTitleFocused = false;
  bool _isDescriptionFocused = false;

  final Set<int> selectedIndexes = {};

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    descriptionController.dispose();
    titleController.dispose();
    super.dispose();
  }

  void _showImagePickerDialog(String direction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1f2937), Color(0xFF0f172a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LabelService().getLabel(111),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.camera_alt, color: Colors.white),
                  title: Text(
                    LabelService().getLabel(112),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ref
                        .read(trainingModelProvider.notifier)
                        .pickFromCameras(direction);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.photo_library, color: Colors.white),
                  title: Text(
                    LabelService().getLabel(113),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ref
                        .read(trainingModelProvider.notifier)
                        .pickFromGallerys(direction);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              dayPeriodTextColor: AppColors.blackColor,
              dialTextColor: AppColors.blackColor,
              entryModeIconColor: AppColors.primary,
              helpTextStyle: const TextStyle(fontWeight: FontWeight.w700),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '-- : --';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  String formatTimeOfDays(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<String> selectedTraining = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchModel();
    });
  }

  Future<void> loadUserAndFetchModel() async {
    final notifier = ref.read(trainingModelProvider.notifier);
    await notifier.getTrainingModelList();
    print(widget.promoterNames1);
  }

  String formatPromoterLists(List<Promoter> list1, List<Promoter> list2) {
    final mergedList = [...list1, ...list2];

    return mergedList
        .asMap()
        .entries
        .map((entry) {
          final promoter = entry.value;
          return '0:${promoter.name}:${promoter.id}';
        })
        .join(',');
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
              const Text(
                'Trainings',
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
          Row(
            children: [
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
              SizedBox(width: 10),
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
                    Text(
                      '${widget.promoterList.length + widget.promoterNames1.length}  ${LabelService().getLabel(141)}',
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
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 88),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                                itemCount: viewModel.trainingModel.length,
                                itemBuilder: (context, index) {
                                  final isSelected = selectedIndexes.contains(
                                    index,
                                  );
                                  final itemString =
                                      '${viewModel.trainingModel[index].trainingModelID}:${viewModel.trainingModel[index].trainingModelFeatureID}';

                                  void toggleSelection() {
                                    setState(() {
                                      if (isSelected) {
                                        selectedIndexes.remove(index);
                                        selectedTraining.remove(itemString);
                                      } else {
                                        selectedIndexes.add(index);
                                        selectedTraining.add(itemString);
                                      }
                                    });
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
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
                                                                .trainingModel[index]
                                                                .trainingModelTitle ??
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
                                                                .trainingModel[index]
                                                                .trainingModelFeatureTitle
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

                              Focus(
                                onFocusChange: (value) {
                                  setState(() {
                                    _isTitleFocused = value;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          _isTitleFocused
                                              ? AppColors.primary
                                              : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: titleController,
                                          focusNode: _titleFocus,
                                          style: const TextStyle(
                                            color: AppColors.blackColor,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: LabelService().getLabel(
                                              142,
                                            ),
                                            hintStyle: TextStyle(
                                              color: AppColors.greyText,
                                            ),
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 6,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              Focus(
                                onFocusChange: (value) {
                                  setState(() {
                                    _isDescriptionFocused = value;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          _isDescriptionFocused
                                              ? AppColors.primary
                                              : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: descriptionController,
                                          focusNode: _descriptionFocus,
                                          style: const TextStyle(
                                            color: AppColors.blackColor,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: LabelService().getLabel(
                                              155,
                                            ),
                                            hintStyle: TextStyle(
                                              color: AppColors.greyText,
                                            ),
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Start Time Picker
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LabelService().getLabel(143),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap:
                                              () => _selectTime(context, true),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 50,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            child: Text(
                                              formatTimeOfDay(startTime),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // End Time Picker
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LabelService().getLabel(144),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap:
                                              () => _selectTime(context, false),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 50,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            child: Text(
                                              formatTimeOfDay(endTime),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  children: [
                                    // Image Picker Button on Left
                                    GestureDetector(
                                      onTap: () {
                                        if (viewModel.rightImages.length < 4) {
                                          _showImagePickerDialog('right');
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                LabelService().getLabel(114),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    // Images Display with Remove Button on Right
                                    Expanded(
                                      child: SizedBox(
                                        height: 80,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              viewModel.rightImages.length,
                                          itemBuilder: (context, index) {
                                            final file =
                                                viewModel.rightImages[index];
                                            return Stack(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    right: 10,
                                                  ),
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                    image: DecorationImage(
                                                      image: FileImage(file),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 4,
                                                  right: 4,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        viewModel.rightImages
                                                            .removeAt(index);
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                            color:
                                                                Colors.black54,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: const Icon(
                                                        Icons.close,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SafeArea(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: GestureDetector(
                              onTap: () async {
                                if (startTime == null || endTime == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please select start and end time.',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                await viewModel.trainingSubmit(
                                  storeId: widget.storeId.toString(),
                                  description: descriptionController.text,
                                  trainingDateTime: DateTime.now().toString(),
                                  startTime: formatTimeOfDays(startTime!),
                                  endTime: formatTimeOfDays(endTime!),
                                  attendeseTypeId: '1',
                                  trainingTypeId: '1',
                                  trainingTitle: titleController.text,
                                  noOfAttendees:
                                      widget.promoterNames1.length.toString(),
                                  attendees: formatPromoterLists(
                                    widget.promoterList,
                                    widget.promoterNames1,
                                  ),
                                  store: widget.storeId.toString(),
                                  trainingModel:
                                      selectedTraining.join(',').trim(),
                                );
                                NavigationService.goBack();
                                NavigationService.goBack();
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.whiteColor,
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
