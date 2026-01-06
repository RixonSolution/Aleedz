import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/viewmodel/alert_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class AlertView extends ConsumerStatefulWidget {
  const AlertView({super.key});

  @override
  ConsumerState<AlertView> createState() => _AlertViewState();
}

class _AlertViewState extends ConsumerState<AlertView> {
  final Map<int, int> _imagePageIndex = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(alertProvider).init());
  }

  Future<void> _pickDate({
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      onSelected(pickedDate);
    }
  }

  Widget _dateField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 16,
              color: AppColors.greyText,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.greyText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.secondary : AppColors.greyText,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.blackColor.withOpacity(0.45),
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 1.8),
      ),
    );
  }

  List<String> _imageUrls(String? url1, String? url2) {
    final urls = <String>[];
    if (url1 != null && url1.isNotEmpty) {
      urls.add(_normalizeImageUrl(url1));
    }
    if (url2 != null && url2.isNotEmpty) {
      urls.add(_normalizeImageUrl(url2));
    }
    return urls;
  }

  String _normalizeImageUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return '${ApiConstants.baseUrl}/$url';
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return 'NA';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(alertProvider);

    final alertTypes = [
      {'label': 'Activity', 'type': 1},
      {'label': 'Issue', 'type': 2},
      {'label': 'Deployment', 'type': 3},
    ];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1f2937), Color(0xFF0f172a)],
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
                        onTap:
                            () => NavigationService.resetTo(
                              DashboardView(initialIndex: 0),
                            ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        LabelService().getLabel(9),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _dateField(
                              label: 'From',
                              value: viewModel.formattedStartDate,
                              onTap:
                                  () => _pickDate(
                                    initialDate: viewModel.startDate,
                                    onSelected: (date) {
                                      ref
                                          .read(alertProvider)
                                          .setStartDate(date);
                                    },
                                  ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _dateField(
                              label: 'To',
                              value: viewModel.formattedEndDate,
                              onTap:
                                  () => _pickDate(
                                    initialDate: viewModel.endDate,
                                    onSelected: (date) {
                                      ref.read(alertProvider).setEndDate(date);
                                    },
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              alertTypes.map((tab) {
                                final type = tab['type'] as int;
                                return _tabChip(
                                  label: tab['label'] as String,
                                  selected: viewModel.selectedAlertType == type,
                                  onTap:
                                      () => ref
                                          .read(alertProvider)
                                          .setAlertType(type),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: viewModel.selectedChannel?.channelId,
                      decoration: _inputDecoration(hint: 'Select Channel'),
                      style: const TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                      ),
                      hint: Text(
                        LabelService().getLabel(207),
                        style: TextStyle(
                          color: AppColors.blackColor.withOpacity(0.45),
                          fontSize: 14,
                        ),
                      ),
                      items:
                          viewModel.channelList.map((channel) {
                            return DropdownMenuItem<int>(
                              value: channel.channelId,
                              child: Text(channel.channelName),
                            );
                          }).toList(),
                      onChanged:
                          viewModel.channelList.isEmpty
                              ? null
                              : (int? channelId) {
                                if (channelId == null) return;
                                final selected = viewModel.channelList
                                    .firstWhere(
                                      (c) => c.channelId == channelId,
                                    );
                                ref
                                    .read(alertProvider)
                                    .setSelectedChannel(selected);
                              },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child:
                          viewModel.loader
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.secondary,
                                ),
                              )
                              : viewModel.alerts.isEmpty
                              ? Center(
                                child: Text(
                                  LabelService().getLabel(208),
                                  style: TextStyle(
                                    color: AppColors.greyText,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                              : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 16),
                                itemCount: viewModel.alerts.length,
                                itemBuilder: (context, index) {
                                  final alert = viewModel.alerts[index];
                                  final images = _imageUrls(
                                    alert.imageActivity,
                                    alert.imageActivity2,
                                  );
                                  final statusLabel =
                                      (alert.quantity?.isNotEmpty ?? false)
                                          ? '${LabelService().getLabel(221)} ${alert.quantity}'
                                          : '${LabelService().getLabel(206)}';
                                  final itemKey = alert.activityId ?? index;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 8,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x19000000),
                                            blurRadius: 18,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                        border: const Border(
                                          left: BorderSide(
                                            color: AppColors.primary,
                                            width: 4,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
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
                                                        alert.activityTypeName ??
                                                            '',
                                                        style: const TextStyle(
                                                          color: Color(
                                                            0xFF111827,
                                                          ),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        alert.activityCategoryName ??
                                                            '',
                                                        style: const TextStyle(
                                                          color: Color(
                                                            0xFF111827,
                                                          ),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        '#${alert.activityId ?? '-'} • ${alert.storeName ?? '-'}',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors
                                                                  .greyText,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        alert.activityDateTime ??
                                                            '',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors
                                                                  .greyText,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFFFF4EC,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    statusLabel,
                                                    style: const TextStyle(
                                                      color: Color(0xFFf97316),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (images.isNotEmpty) ...[
                                              const SizedBox(height: 14),
                                              SizedBox(
                                                height: 180,
                                                child: Stack(
                                                  children: [
                                                    PageView.builder(
                                                      controller: PageController(
                                                        initialPage:
                                                            _imagePageIndex[itemKey] ??
                                                            0,
                                                      ),
                                                      itemCount: images.length,
                                                      onPageChanged: (page) {
                                                        setState(() {
                                                          _imagePageIndex[itemKey] =
                                                              page;
                                                        });
                                                      },
                                                      itemBuilder: (
                                                        context,
                                                        imgIndex,
                                                      ) {
                                                        return ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                                images[imgIndex],
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (
                                                                  context,
                                                                  url,
                                                                ) => Shimmer.fromColors(
                                                                  baseColor:
                                                                      Colors
                                                                          .grey[300]!,
                                                                  highlightColor:
                                                                      Colors
                                                                          .grey[100]!,
                                                                  child: Container(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                ),
                                                            errorWidget:
                                                                (
                                                                  context,
                                                                  url,
                                                                  error,
                                                                ) => const Icon(
                                                                  Icons.error,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Positioned(
                                                      bottom: 8,
                                                      left: 0,
                                                      right: 0,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: List.generate(images.length, (
                                                          dotIndex,
                                                        ) {
                                                          final isActive =
                                                              (_imagePageIndex[itemKey] ??
                                                                  0) ==
                                                              dotIndex;
                                                          return AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                                  milliseconds:
                                                                      200,
                                                                ),
                                                            margin:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 4,
                                                                ),
                                                            height: 8,
                                                            width:
                                                                isActive
                                                                    ? 16
                                                                    : 8,
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  isActive
                                                                      ? AppColors
                                                                          .primary
                                                                      : Colors
                                                                          .white
                                                                          .withOpacity(
                                                                            0.7,
                                                                          ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    4,
                                                                  ),
                                                              boxShadow:
                                                                  isActive
                                                                      ? [
                                                                        BoxShadow(
                                                                          color: AppColors.primary.withOpacity(
                                                                            0.4,
                                                                          ),
                                                                          blurRadius:
                                                                              6,
                                                                          offset: const Offset(
                                                                            0,
                                                                            2,
                                                                          ),
                                                                        ),
                                                                      ]
                                                                      : [],
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            if ((alert.activityDescription ??
                                                    '')
                                                .isNotEmpty) ...[
                                              const SizedBox(height: 14),
                                              Text(
                                                alert.activityDescription ?? '',
                                                style: const TextStyle(
                                                  color: Color(0xFF4B5563),
                                                  fontSize: 14,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                            const SizedBox(height: 12),
                                            Divider(
                                              color: Colors.grey.shade300,
                                              height: 1,
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor:
                                                      AppColors.primary,
                                                  child: Text(
                                                    _initials(
                                                      alert.teamMemberName,
                                                    ),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    alert.teamMemberName ?? '',
                                                    style: const TextStyle(
                                                      color: Color(0xFF4B5563),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFFFF4EC,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    LabelService().getLabel(
                                                      209,
                                                    ),
                                                    style: TextStyle(
                                                      color: Color(0xFFf97316),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
            ),
          ],
        ),
      ),
    );
  }
}
