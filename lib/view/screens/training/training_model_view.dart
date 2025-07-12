import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/training_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingModelView extends ConsumerStatefulWidget {
  String checkInTime, storeName, trainingName;
  int storeId, storeCount, promotorCount;
  List<String> promoterNames1;

  TrainingModelView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
    required this.trainingName,
    required this.storeCount,
    required this.promotorCount,
    required this.promoterNames1,
  }) : super(key: key);

  @override
  ConsumerState<TrainingModelView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<TrainingModelView> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  final Set<int> selectedIndexes = {};

  void _showImagePickerDialog(String direction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondary,
          title: Text(
            'Pick an image',
            style: TextStyle(color: AppColors.whiteColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'From Camera',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                onTap: () {
                  ref
                      .read(trainingModelProvider.notifier)
                      .pickFromCameras(direction);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  'From Gallery',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                onTap: () {
                  ref
                      .read(trainingModelProvider.notifier)
                      .pickFromGallerys(direction);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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

  String formatList(List<String> names) {
    return names
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key + 1;
          final name = entry.value;
          return '$index:$name';
        })
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(trainingModelProvider);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar:
            viewModel.loader
                ? const Center(child: CircularProgressIndicator())
                : Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  color: Colors.white,
                  child: ElevatedButton(
                    onPressed: () async {
                      await viewModel.trainingSubmit(
                        storeId: widget.storeId.toString(),
                        description: descriptionController.text,
                        trainingDateTime: DateTime.now().toString(),
                        startTime: formatTimeOfDays(startTime!),
                        endTime: formatTimeOfDays(endTime!),
                        attendeseTypeId: '1',
                        trainingTypeId: '1',
                        trainingTitle: titleController.text,
                        noOfAttendees: widget.promoterNames1.length.toString(),
                        attendees: formatList(widget.promoterNames1),
                        store: widget.storeId.toString(),
                        trainingModel: selectedTraining.join(',').trim(),
                      );
                      NavigationService.goBack();
                      NavigationService.goBack();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),

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
                      padding: const EdgeInsets.symmetric(
                        // horizontal: 16,
                        vertical: 8,
                      ),

                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color:
                                    Colors.grey[200], // Light grey background
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: descriptionController,
                                enabled: false,
                                style: const TextStyle(
                                  color: AppColors.blackColor,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      '${widget.promotorCount.toString()}  Promoters Selected',

                                  hintStyle: TextStyle(
                                    color: AppColors.greyText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            padding: const EdgeInsets.all(5),
                            itemCount: viewModel.trainingModel.length,
                            itemBuilder: (context, index) {
                              final isSelected = selectedIndexes.contains(
                                index,
                              );
                              final itemString =
                                  '${viewModel.trainingModel[index].trainingModelID}:${viewModel.trainingModel[index].trainingModelFeatureID}';

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// Text Info
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${index + 1}.  ',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${viewModel.trainingModel[index].trainingModelTitle}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14,
                                                          color:
                                                              AppColors
                                                                  .blackColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        viewModel
                                                            .trainingModel[index]
                                                            .trainingModelFeatureTitle
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              AppColors
                                                                  .blackColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        /// Custom Circular Checkbox
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (isSelected) {
                                                selectedIndexes.remove(index);
                                                selectedTraining.remove(
                                                  itemString,
                                                );
                                              } else {
                                                selectedIndexes.add(index);
                                                selectedTraining.add(
                                                  itemString,
                                                );
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                              top: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  isSelected
                                                      ? Colors.black
                                                      : Colors.grey[400],
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 25),
                                ],
                              );
                            },
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200], // Light grey background
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: titleController,
                                    style: const TextStyle(
                                      color: AppColors.blackColor,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Title',
                                      hintStyle: TextStyle(
                                        color: AppColors.greyText,
                                      ),
                                      border:
                                          InputBorder
                                              .none, // 🔴 Remove underline
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200], // Light grey background
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: descriptionController,
                                    style: const TextStyle(
                                      color: AppColors.blackColor,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Description',
                                      hintStyle: TextStyle(
                                        color: AppColors.greyText,
                                      ),
                                      border:
                                          InputBorder
                                              .none, // 🔴 Remove underline
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Start Time Picker
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Start Time',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _selectTime(context, true),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 50,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            8,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'End Time',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _selectTime(context, false),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 50,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            8,
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

                          Row(
                            children: [
                              // Image Picker Button on Left
                              GestureDetector(
                                onTap: () {
                                  if (viewModel.rightImages.length < 4) {
                                    _showImagePickerDialog('right');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Maximum 4 images allowed.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: 10,
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
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
                                    itemCount: viewModel.rightImages.length,
                                    itemBuilder: (context, index) {
                                      final file = viewModel.rightImages[index];
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
                                                  BorderRadius.circular(8),
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
                                                decoration: const BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: const EdgeInsets.all(
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
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
