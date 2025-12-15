import 'dart:io';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/issues_veiwmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DeployementSubmitView extends ConsumerStatefulWidget {
  String checkInTime, storeName, activityCategoryName;
  int storeId, divisionId, activityTypeId, activitiCategoryId;

  DeployementSubmitView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.activityCategoryName,
    required this.divisionId,
    required this.activityTypeId,
    required this.activitiCategoryId,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<DeployementSubmitView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<DeployementSubmitView> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();

  void _showImagePickerDialog() {
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
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedImage =
                        await ImagePicker().pickImage(source: ImageSource.camera);
                    if (pickedImage != null &&
                        ref
                                .read(issuesModelProvider.notifier)
                                .beforeActivityImages
                                .length <
                            4) {
                      ref
                          .read(issuesModelProvider.notifier)
                          .beforeActivityImages
                          .add(File(pickedImage.path));
                      ref.read(issuesModelProvider.notifier).notifyListeners();
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading:
                      const Icon(Icons.photo_library, color: Colors.white),
                  title: Text(
                    LabelService().getLabel(113),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedImages = await ImagePicker().pickMultiImage();
                    if (pickedImages.isNotEmpty) {
                      for (var image in pickedImages) {
                        if (ref
                                .read(issuesModelProvider.notifier)
                                .beforeActivityImages
                                .length >=
                            4) {
                          break;
                        }
                        ref
                            .read(issuesModelProvider.notifier)
                            .beforeActivityImages
                            .add(File(image.path));
                      }
                      ref.read(issuesModelProvider.notifier).notifyListeners();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(loadUserAndFetchActivity);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    barcodeController.dispose();
    super.dispose();
  }

  Future<void> loadUserAndFetchActivity() async {
    await ref.read(issuesModelProvider.notifier).getMarketActivityList(
          storeId: widget.storeId.toString(),
          activityCategoryId: widget.activitiCategoryId.toString(),
          activityTypeId: widget.activityTypeId.toString(),
          brandId: '1',
        );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(issuesModelProvider);
    final labelService = LabelService();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                            labelService.getLabel(121),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              _openFilterSheet();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.filter_alt_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
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
                        widget.activityCategoryName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                const SizedBox(height: 10),
                Expanded(
                  child: viewModel.loader
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                          children: const [],
                        ),
                ),
              ],
            ),
            _AddDeploymentButton(onTap: () {
              _openAddDeploymentSheet(viewModel);
            }),
          ],
        ),
      ),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Deployment Category',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2F3F5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.activityCategoryName,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Store: ${widget.storeName}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAddDeploymentSheet(IssuesViewModel viewModel) {
    // reset inputs each time sheet opens
    descriptionController.clear();
    barcodeController.clear();
    viewModel.beforeActivityImages.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        bool localSubmitting = false;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add New Deployment',
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2F3F5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: Colors.grey.shade300, height: 1),
                      const SizedBox(height: 16),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          minLines: 2,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: LabelService().getLabel(118),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      BarcodeScannerUI(
                        controller: barcodeController,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFD8B2)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0F000000),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (viewModel.beforeActivityImages.length < 4) {
                                  _showImagePickerDialog();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        LabelService().getLabel(114),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4E8),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFFFD8B2),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.camera_alt,
                                      color: AppColors.primary,
                                      size: 28,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Add Photo',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 90,
                                child: viewModel.beforeActivityImages.isEmpty
                                    ? Center(
                                        child: Text(
                                          'No photos added',
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: viewModel
                                            .beforeActivityImages.length,
                                        itemBuilder: (context, index) {
                                          final file = viewModel
                                              .beforeActivityImages[index];
                                          return Stack(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  right: 10,
                                                ),
                                                height: 90,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFFFFD8B2),
                                                  ),
                                                  image: DecorationImage(
                                                    image: FileImage(file),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 6,
                                                right: 6,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    viewModel
                                                        .beforeActivityImages
                                                        .removeAt(index);
                                                    viewModel.notifyListeners();
                                                    setModalState(() {});
                                                  },
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.black54,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(4),
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
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: localSubmitting || viewModel.loader
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  if (descriptionController.text.isEmpty) {
                                    AppSnackBar.showError(
                                      context,
                                      LabelService().getLabel(157),
                                    );
                                    return;
                                  }
                                  if (viewModel.beforeActivityImages.isEmpty) {
                                    AppSnackBar.showError(
                                      context,
                                      LabelService().getLabel(115),
                                    );
                                    return;
                                  }
                                  setModalState(() {
                                    localSubmitting = true;
                                  });
                                  await viewModel.marketActivityAdd(
                                    storeID: widget.storeId.toString(),
                                    activityTypeId:
                                        widget.activityTypeId.toString(),
                                    activityCategoryId:
                                        widget.activitiCategoryId.toString(),
                                    brandId: '1',
                                    activityDescription:
                                        descriptionController.text,
                                    statusId: '1',
                                    quantity: '1',
                                    deployementReason: '1',
                                    beforeActivityPictures:
                                        viewModel.beforeActivityImages,
                                  );
                                  descriptionController.clear();
                                  viewModel.beforeActivityImages.clear();
                                  setModalState(() {
                                    localSubmitting = false;
                                  });
                                  if (mounted) Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AddDeploymentButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddDeploymentButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Add New Deployment',
                  style: TextStyle(
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
    );
  }
}

class BarcodeScannerUI extends StatefulWidget {
  final TextEditingController controller;
  const BarcodeScannerUI({Key? key, required this.controller}) : super(key: key);

  @override
  State<BarcodeScannerUI> createState() => _BarcodeScannerUIState();
}

class _BarcodeScannerUIState extends State<BarcodeScannerUI> {
  bool hasScanned = false;
  MobileScannerController cameraController = MobileScannerController();
  bool _torchOn = false;
  bool _showScanner = false;

  void _handleScan(String value) {
    widget.controller.text = value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Barcode: $value')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.qr_code_scanner, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter / Scan Barcode',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                hasScanned = false;
                _showScanner = !_showScanner;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _showScanner ? 'Hide Scanner' : 'Scan Barcode',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        if (_showScanner) ...[
          const SizedBox(height: 8),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: MobileScanner(
                    controller: cameraController,
                    onDetect: (capture) {
                      if (hasScanned) return;
                      final barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        final String? rawValue = barcode.rawValue;
                        if (rawValue != null) {
                          hasScanned = true;
                          _handleScan(rawValue);
                          break;
                        }
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
                    color: Colors.white,
                    onPressed: () async {
                      await cameraController.toggleTorch();
                      setState(() {
                        _torchOn = !_torchOn;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
